USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
ALTER VIEW iT23_00_Time_and_Attendance
AS
SELECT
	RTRIM(X.PER_REF_NO) AS PER_REF_NO
	,'POSITION' AS [OBJECT]
	-- May need translating
	,EP.JOB_TITLE AS [NAME]
	,EP.iTrentPositionRef AS POST_NO
	,CONVERT(char(8), AA.ABS_START_DATE, 112) AS ABSENCE_START_DATE
	,COALESCE(CONVERT(char(8), AA.ABS_END_DATE, 112), '') AS ABSENCE_END_DATE
	,'' AS ABSENCE_START_TIME
	,'' AS ABSENCE_END_TIME
	,CASE 
		WHEN AA.START_PART_WORKED_YN = 'Y'
		THEN 'HALF_PM'
		WHEN AA.ABS_START_DATE = AA.ABS_END_DATE
			AND AA.END_PART_WORKED_YN = 'Y'
		THEN 'HALF_AM'
		ELSE 'FULL'
	END AS ABSENCE_START_TYPE
	,CASE 
		WHEN AA.END_PART_WORKED_YN = 'Y'
		THEN 'HALF_AM'
		WHEN AA.ABS_START_DATE = AA.ABS_END_DATE
			AND AA.START_PART_WORKED_YN = 'Y'
		THEN 'HALF_PM'
		ELSE 'FULL'
	END AS ABSENCE_END_TYPE
	--,AA.START_PART_WORKED_YN
	--,AA.END_PART_WORKED_YN
	--,AA.CATEGORY
	,'' AS ABSENCE_START_HOURS
	,'' AS ABSENCE_END_HOURS
	,'Sickness' AS ABSENCE_TYPE
	-- May need translating
	--,ACR.[DESCRIPTION] AS ABSENCE_REASON
	,S.NewReason AS ABSENCE_REASON
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
	JOIN dbo.EMP_NO_X_POS_REF EP
		ON P.EMP_NO = EP.EMP_NO
	JOIN dbo.APPT_ABSENCE AA
		ON P.EMP_NO = AA.EMP_NO
			AND AA.CATEGORY = 'SICKNESS'
			AND AA.ABS_START_DATE >= DATEADD(year, -3, CURRENT_TIMESTAMP)
	JOIN dbo.ABS_CATEGORY_REASON ACR
		ON AA.CATEGORY = ACR.CATEGORY
			AND AA.REASON = ACR.REASON
	JOIN dbo.SicknessReasons S
		ON ACR.[DESCRIPTION] = S.OldReason 
WHERE P.PERSON_STATUS NOT LIKE 'L%'
	AND LEN(P.EMP_NO) < 7;
GO
