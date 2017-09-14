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
--What should name ptrefixes be?
CREATE VIEW [dbo].[iT99_12_01_01_Next_Of_Kin]
AS
--12.1.1 User Defined Fields - File Formats
SELECT RIGHT('00000' + RTRIM(R.EMP_NO), 6) AS PER_REF_NO
	,CASE WHEN R.KIN_TITLE is null then ''
	      WHEN R.KIN_TITLE = 'MI' then 'Miss'
		  WHEN R.KIN_TITLE = 'MR' then 'Mr'
	      WHEN R.KIN_TITLE = 'MRS' then 'Mrs'
		  WHEN R.KIN_TITLE = 'DR' then 'Dr'
		  WHEN R.KIN_TITLE = 'MS' then 'Ms'
		  WHEN R.KIN_TITLE = 'PROF' then 'Prof'
		  WHEN R.KIN_TITLE = 'REV' then 'Rev'
	      ELSE COALESCE(R.KIN_TITLE, '') END +' '
	+COALESCE(R.KIN_FORENAMES,'')+' '
	+COALESCE(KIN_SURNAME,'') AS NAME
	,CASE WHEN R.KIN_ADDRESS_1 is null THEN   'T' 
	      WHEN R.KIN_ADDRESS_1 = 'same' THEN 'T'
	      WHEN R.KIN_ADDRESS_1 = 'As Above' THEN 'T'
	      WHEN R.KIN_ADDRESS_1 = 'Same as Home' THEN 'T'
	      ELSE 'F' END 
	      AS DEFAULT_ADDRESS_I      -- 'T' if same as home address, else 'F' 
	, ' ' AS BIRTH_DATE
	, ' ' AS BIRTH_DATE_VERIFIED_DATE
	,COALESCE(R.KIN_RELATIONSHIP, '') AS RELATIONSHIP  -- Next to translate to code
	,'' AS ADDRESS_TYPE -- Need correct code We don't have lists of acceptable values
	,CASE WHEN R.KIN_ADDRESS_1 is null THEN   '' 
	      WHEN R.KIN_ADDRESS_1 = 'same' THEN ''
	      WHEN R.KIN_ADDRESS_1 = 'As Above' THEN ''
		  WHEN R.KIN_ADDRESS_1 = 'Same as Home' THEN ''
	      ELSE  R.KIN_ADDRESS_1 END AS ADDR_LINE_1
	,COALESCE(R.KIN_ADDRESS_2, '') AS ADDR_LINE_2
	,COALESCE(R.KIN_ADDRESS_3, '') AS ADDR_LINE_3
	,COALESCE(R.KIN_TOWN, '') AS ADDR_LINE_4
	,COALESCE(R.KIN_COUNTY, '') AS ADDR_LINE_5
	,COALESCE(R.KIN_POSTCODE, '') AS ADDR_LINE_6
	,COALESCE(R.KIN_COUNTRY, '') AS ADDRESS_COUNTRY

FROM dbo.PERSON P
	JOIN dbo.DEPENDENTS R
		ON P.EMP_NO = R.EMP_NO
WHERE LEN(P.EMP_NO) < 7
	AND
	(
		P.PERSON_STATUS NOT LIKE 'L%'
		OR
		(P.PERSON_STATUS LIKE 'L%' AND P.DATE_OF_LEAVING >= '20170401')
	);
GO
