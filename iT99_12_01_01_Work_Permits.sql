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
--Prefixes for View Name?
CREATE VIEW [dbo].[iT99_12_01_01_Work_Permits]
AS
--12.1.1 User Defined Fields - File Formats
SELECT RIGHT('00000' + RTRIM(R.EMP_NO), 6) AS PER_REF_NO
	,COALESCE(CONVERT(char(8), R.EXPIRY_DATE, 112), '') AS EXPIRY_DATE
	,R.WORK_PERMIT_NO AS WORK_PERMIT_NO
	,COALESCE(CONVERT(char(8), P.DATE_OF_START, 112), '') AS START_DATE
	--Use Employee Start date as Work Permit Start Date - we don't hold
	--Work Permit Start Date 
	,'F' AS INDEV_LEAVE_TO_REM -- Don't have, so default to F - false?


FROM dbo.PERSON P
	JOIN dbo.EMPLOYEE_WORK_PERMIT R
		ON P.EMP_NO = R.EMP_NO
WHERE LEN(P.EMP_NO) < 7
	AND
	(
		P.PERSON_STATUS NOT LIKE 'L%'
		OR
		(P.PERSON_STATUS LIKE 'L%' AND P.DATE_OF_LEAVING >= '20170401')
	);
GO
