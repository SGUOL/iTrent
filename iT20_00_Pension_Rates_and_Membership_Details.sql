USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
ALTER VIEW dbo.iT20_00_Pension_Rates_and_Membership_Details
AS
WITH Pensions
-- ignore award contracts
AS
(
	SELECT P.EMP_NO, X2.CONTRACT_NO, P.PENSION, P.PENSION_START, T.SchemeName
		,CASE
			--Cash Values
			WHEN P.PENSION IN ('NHSSLLS','USSDCAC','USSLSAV','USSLSPR')
			THEN P.EE_VALUE
			ELSE 0
		END AS EE_CASH_VALUE
		,CASE
			--Cash Values
			WHEN P.PENSION IN ('NHSSLLS','USSDCAC','USSLSAV','USSLSPR')
			THEN 0
			ELSE P.EE_VALUE
		END AS EE_VALUE
		,P.ER_VALUE
		,PH.PEN_EE_CONTRIB, PH.PEN_ER_CONTRIB, PH.PEN_EE_CALC, PH.PEN_ER_CALC, T.SchemeType
		,COALESCE(M.POS_REF_NO, '') AS POS_REF_NO
	FROM dbo.PENSION_CONDITION P
		JOIN dbo.TransPensions T
			ON P.PENSION = T.PENSION
				AND (T.SchemeName = 'NHS' OR T.SchemeType LIKE 'Additional Voluntary Contributions%')
		JOIN dbo.PENSION PH
			ON P.PENSION = PH.PENSION
		CROSS APPLY
		(
			VALUES (CASE WHEN ISNUMERIC(P.POST_NO) = 1 THEN P.POST_NO END)
		) X1 (CONTRACT_NO)
		LEFT JOIN dbo.CONTRACT_DETAILS D
			ON P.EMP_NO = D.EMP_NO
				AND X1.CONTRACT_NO = D.CONTRACT_NO
				AND D.IS_MASTER = 'Y'
		LEFT JOIN dbo.MultiPaidContracts M
			ON P.EMP_NO = M.EMP_NO
				AND X1.CONTRACT_NO= M.CONTRACT_NO
		CROSS APPLY
		(
			VALUES (COALESCE(D.CONTRACT_NO, M.CONTRACT_NO))
		) X2 (CONTRACT_NO)
	WHERE (P.PENSION_STOP IS NULL OR P.PENSION_STOP >= DATEADD(d, DATEDIFF(d, 0, CURRENT_TIMESTAMP), 0))
		AND X2.CONTRACT_NO IS NOT NULL
		-- 20170829 Do not include USS Matched DC AVC Sal Sac
		AND P.PENSION <> 'USSMPP'
)
,FilteredPensions
AS
(
	SELECT EMP_NO, CONTRACT_NO, PENSION, PENSION_START, SchemeName, EE_CASH_VALUE, EE_VALUE, ER_VALUE
		,PEN_EE_CONTRIB, PEN_ER_CONTRIB, PEN_EE_CALC, PEN_ER_CALC, POS_REF_NO, SchemeType
	FROM Pensions P
	WHERE NOT EXISTS
	(
		SELECT 1
		FROM Pensions P1
		WHERE P1.EMP_NO = P.EMP_NO
			AND P1.CONTRACT_NO = P.CONTRACT_NO
			AND
			(
				(P.PENSION = 'USSCARE' AND P1.PENSION = 'USSCPP')
				OR
				(P.PENSION = 'USSDCAM' AND P1.PENSION = 'USSMPP')
				OR
				(P.PENSION = 'SAULCRB' AND P1.PENSION = 'SAULCPP')
			)
	)
)
,JobTitles
AS
(
	SELECT EMP_NO, JOB_TITLE_FULL AS JOB_TITLE, iTrentPositionRef AS POST_NO
		--,ROW_NUMBER() OVER (PARTITION BY EMP_NO, JOB_TITLE_FULL ORDER BY iTrentPositionRef) AS rn
		,ROW_NUMBER() OVER (PARTITION BY EMP_NO ORDER BY iTrentPositionRef) AS rn
	FROM iTLoads.dbo.EMP_NO_X_POS_REF
)
--select * from FilteredPensions
SELECT
	--pension, f.contract_no, schemetype,
	RTRIM(X.PER_REF_NO) AS PER_REF_NO
	,F.SchemeName AS SCHEME
	,'M' AS RATE_FREQUENCY
	,CONVERT(char(8), F.PENSION_START, 112) AS EFFECTIVE_DATE
	,'9999999.00' AS EARNINGS_LEVEL
	,CASE
		WHEN F.EE_CASH_VALUE > 0
		THEN CAST(F.EE_CASH_VALUE AS varchar(20))
		ELSE ''
	END AS EE_CASH_VALUE
	,CASE
		WHEN F.EE_CASH_VALUE > 0
		THEN CAST(0 AS varchar(20))
		ELSE ''
	END AS ER_CASH_VALUE
	,CASE
		WHEN F.EE_CASH_VALUE > 0
		THEN ''
		WHEN F.EE_VALUE > 0
		THEN CAST(F.EE_VALUE AS varchar(20))
		WHEN F.PEN_EE_CONTRIB > 0
		THEN CAST(F.PEN_EE_CONTRIB AS varchar(20))
		--WHEN F.PEN_EE_CALC IS NOT NULL
		WHEN F.PEN_EE_CALC IS NOT NULL OR F.PEN_ER_CALC IS NOT NULL
		THEN '1'
		ELSE '0'
	END AS EE_PERCENTAGE
	,CASE
		WHEN F.EE_CASH_VALUE > 0
		THEN ''
		--Not convinced about NHS.
		WHEN F.SchemeName = 'NHS'
		THEN '0'
		WHEN F.ER_VALUE > 0
		THEN CAST(F.ER_VALUE AS varchar(20))
		WHEN F.PEN_ER_CONTRIB > 0
		THEN CAST(F.PEN_ER_CONTRIB AS varchar(20))
		--WHEN F.PEN_ER_CALC IS NOT NULL
		--THEN '1'
		ELSE '0'
	END AS ER_PERCENTAGE
	--,F.EE_VALUE, F.PEN_EE_CONTRIB, F.PEN_EE_CALC, F.ER_VALUE, F.PEN_ER_CONTRIB, F.PEN_ER_CALC
	,'POSITION' AS [OBJECT]
	,JT.JOB_TITLE AS [NAME]
	--,F.POS_REF_NO AS POST_NO
	,JT.POST_NO
	,'' AS MEMBERSHIP_NUMBER
	,'' AS AUTO_ENTROL_DATE
	,'' AS JOIN_TYPE
	,'' AS JOIN_REQ_DATE
	,'' AS REFUND_I
	,'' AS MEMB_END_TYPE
	,'' AS OPT_OUT_REF
FROM dbo.PERSON P
	CROSS APPLY
	(
		VALUES
		(
			--CASE
			--	WHEN LEN(P.EMP_NO) < 6
			--	THEN RIGHT('00000' + RTRIM(P.EMP_NO), 6)
			--	ELSE P.EMP_NO
			--END
			LTRIM(RTRIM(P.EMP_NO))
		)
	) X (PER_REF_NO)
	JOIN dbo.APPOINTMENTS A
		ON P.EMP_NO = A.EMP_NO
	LEFT JOIN JobTitles JT
		ON A.EMP_NO = JT.EMP_NO
			--AND JT.JOB_TITLE LIKE LTRIM(RTRIM(A.JOB_TITLE)) + '%'
			AND JT.rn = 1
	JOIN FilteredPensions F
		ON A.EMP_NO = F.EMP_NO
			AND A.CONTRACT_NO = F.CONTRACT_NO
WHERE P.PERSON_STATUS NOT LIKE 'L%'
	AND
	(
		A.CURRENT_INDICATOR IN ('C','L')
		OR
		(
			A.CURRENT_INDICATOR = 'J'
			AND
			(
				NOT EXISTS
				(
						SELECT 1
						FROM dbo.APPOINTMENTS A1
						WHERE A1.EMP_NO = A.EMP_NO
							AND A1.CURRENT_INDICATOR = 'C'		
				)
				OR A.CHANGE_DATE <= CURRENT_TIMESTAMP
			)
		)
	)
	AND EXISTS
	(
		SELECT 1
		FROM dbo.REFNO RN
		WHERE RN.PAYROLL_EMP_NO = P.EMP_NO
			AND RN.PAY_GROUP = 'MTH'
	)
	--order by X.PER_REF_NO, PENSION
GO