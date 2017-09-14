USE [iTLoads]
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- PST0001 is the POST_NO for the POST Leavers
ALTER VIEW dbo.iT06_02_Create_Leaver_Positions_from_Post
AS
SELECT X.PER_REF_NO
	,'PERSON' AS [OBJECT]
	,'Leaver' AS NAME
	,COALESCE(CONVERT(char(8), P.DATE_OF_START, 112), '') AS [START_DATE]
	,'POST' AS PARENT_OBJECT
	,'' AS PARENT_NAME -- blank when get Post ref no from Rashi
	,'PST0001' AS PARENT_POST_NO -- add when get Post ref no from Rashi
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
			RIGHT('00000' + LTRIM(RTRIM(P.EMP_NO)), 6)
		)
	) X (PER_REF_NO)
WHERE LEN(P.EMP_NO) < 7
	AND P.PERSON_STATUS LIKE 'L%' AND P.DATE_OF_LEAVING >= '20170401'
	-- only need these to start with
	AND EXISTS
	(
		SELECT 1
		FROM dbo.REFNO RN
		WHERE RN.PAYROLL_EMP_NO = P.EMP_NO
			AND RN.PAY_GROUP = 'MTH'
	);
