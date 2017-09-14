USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
ALTER VIEW iT24_00_Reporting_Managers
AS
WITH CurrentPeople
AS
(
	SELECT EMP_NO
	FROM dbo.PERSON P
	WHERE LEN(P.EMP_NO) < 7
		AND P.PERSON_STATUS NOT LIKE 'L%'
)
,AllHierarchy
AS
(
	SELECT H.emp_no, H.reports_to_emp_no
		,ROW_NUMBER() OVER (PARTITION BY H.emp_no ORDER BY H.IS_MASTER DESC, reports_to_emp_no) AS rn
	FROM temp_hierarchy_final H
		JOIN CurrentPeople E
			ON H.emp_no = E.EMP_NO
		JOIN CurrentPeople R
			ON H.reports_to_emp_no = R.EMP_NO
)
,EmpPosRef
AS
(
	SELECT *
		,ROW_NUMBER() OVER (PARTITION BY EMP_NO ORDER BY iTrentPositionRef) AS rn
	FROM iTLoads.dbo.EMP_NO_X_POS_REF
)
,Hierarchy
AS
(
	SELECT H.emp_no, H.reports_to_emp_no

	FROM AllHierarchy H
		JOIN EmpPosRef E
			ON H.emp_no = E.EMP_NO
				AND E.rn = 1
		JOIN EmpPosRef R
			ON H.reports_to_emp_no = R.EMP_NO
				AND R.rn = 1
	WHERE H.rn = 1
)
,People
AS
(
	SELECT P.EMP_NO
		,LTRIM(RTRIM(EP.JOB_TITLE_FULL)) AS JOB_TITLE
		,EP.iTrentPositionRef
		,C.DATE_IN_POST
	FROM dbo.Person P
		JOIN dbo.EMP_NO_X_POS_REF EP
				ON P.EMP_NO = EP.EMP_NO
		JOIN dbo.APPOINTMENTS A
			ON P.EMP_NO = A.EMP_NO
				AND EP.JOB_TITLE LIKE RTRIM(A.JOB_TITLE) + '%'
				AND A.CURRENT_INDICATOR = 'C'
		JOIN dbo.[CONTRACT] C
			ON A.EMP_NO = C.EMP_NO
				AND A.CONTRACT_NO = C.CONTRACT_NO
	WHERE C.DATE_LEFT_POST IS NULL
)
SELECT RIGHT('00000' + LTRIM(RTRIM(P.EMP_NO)), 6) AS PER_REF_NO
	,'POSITION' AS [OBJECT]
	,P.JOB_TITLE AS [NAME]
	,P.iTrentPositionRef AS POST_NO
	-- Need the later date
	--,CONVERT(char(8), P.DATE_IN_POST, 112) AS EFFECTIVE_DATE
	,CASE
		WHEN P.DATE_IN_POST > R.DATE_IN_POST
		THEN CONVERT(char(8), P.DATE_IN_POST, 112)
		ELSE CONVERT(char(8), R.DATE_IN_POST, 112)
	END AS EFFECTIVE_DATE
	,LTRIM(RTRIM(R.EMP_NO)) AS REP_PER_REF_NO
	,'POSITION' AS REP_OBJECT
	,R.JOB_TITLE AS REP_NAME
	,R.iTrentPositionRef AS REP_POST_NO
FROM People P
	JOIN Hierarchy H
		ON P.EMP_NO = H.emp_no
	JOIN People R
		ON H.reports_to_emp_no = R.EMP_NO
WHERE P.EMP_NO <> R.EMP_NO;
GO
