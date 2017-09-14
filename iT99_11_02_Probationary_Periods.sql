/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2008 R2 (10.50.6220)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2008 R2
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [iTLoads]
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
-- This will only extract probation periods for people still employed, where
-- the details extracted will be for the post they were on when their probation started.
--(They may have moved to another post since then). This stops maternity leave appearing.
--For people on Maternity leave, their original job details should appear.

--Employee 103574 has a problem - There is no appointment record matching his first
--CONTRACT_DETAILS start date of 10/03/2001. So, Job Title and number
--are blank for him in this query.

--Other queries - I don't know what to put in PROB_REASON.
--I've put PSE JOB details in NAME and POST_NO. Is this correct?
--I set PARENT_OBJECT to "POST", wnd left rest blank.

CREATE VIEW [dbo].[iT99_11_02_Probationary_Periods]
AS
SELECT
	P.EMP_NO AS PER_REF_NO
	,'' AS PROB_REASON
	,CASE WHEN D.PROBATION_END_DATE <= CURRENT_TIMESTAMP  THEN 'T' 
	 ELSE 'F' END as COMPLETE_I  
	,CONVERT(char(8), D.START_DATE, 112) AS START_DATE
	,CONVERT(char(8), D.PROBATION_END_DATE, 112) AS END_DATE
	,'POSITION' AS [OBJECT]
	,COALESCE(PB.JOB_TITLE,'') AS NAME
	,COALESCE(PB.JOB_NUMBER,'') AS POST_NO
	,'POST' AS PARENT_OBJECT
	, ''      AS PARENT_NAME
	,'' AS PARENT_POST_NO 
-- Ignore PARENT OBJECT,NAME, POST_NO 2 to 4?
FROM dbo.PERSON P
	JOIN dbo.APPOINTMENTS A
		ON P.EMP_NO = A.EMP_NO 
	JOIN dbo.CONTRACT_DETAILS D
		ON A.EMP_NO = D.EMP_NO
			AND A.CONTRACT_NO = D.CONTRACT_NO
	LEFT JOIN dbo.MultiPaidContracts M
		ON A.EMP_NO = M.EMP_NO
			AND A.CONTRACT_NO = M.CONTRACT_NO
	--Next join is to pick up the appointments details that were
	--correct when probation started.
	LEFT JOIN dbo.APPOINTMENTS PB
	    ON A.EMP_NO=PB.EMP_NO
		AND D.CONTRACT_NO=PB.CONTRACT_NO
		AND D.START_DATE=PB.CHANGE_DATE
WHERE P.PERSON_STATUS NOT LIKE 'L%'
	AND D.IS_MASTER = 'Y'
	AND D.PROBATION_PERIOD > 0  
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
	);
GO




