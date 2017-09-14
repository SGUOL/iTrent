-- Created : S P Satyanarayana/CIS
-- Date : 2017 07 27
-- Project : PSE To Midland HR data load
--------------------------------------------
-- SCRIPT NOTES AS PER CARL OF HR
--------------------------------------------
-- UID to be EmpID as Staff_ID is used 
-- HEP_START_OVR to remain blank as it is a field that has to be filtered from the full result set and acted upon separately
-- HE_PARLEAV1 field to map to PARLEAVE in PSE
-- HE_PARLEAV2 field to map to PARLEAVE2 in PSE
-- LEAVER_MUSTER to remain blank as it is not currently known 
-- Date criteria is that the person is currently employed (wherein the DATE_OF_LEAVING is NULL) 
-- -- or the person left organisation in the current HESA year (wherein the DATE_OF_LEAVING will be greater than 01 Aug 2016)
--------------------------------------------
-- END OF SCRIPT NOTES
--------------------------------------------
USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO
ALTER VIEW dbo.iT_HESA_Personal_Details
AS 
SELECT RIGHT('00000' + RTRIM(H.EMP_NO), 6) AS UID,
	COALESCE(CONVERT(char(8), H.DATEFHEI, 112), '') AS HESA_RECORD_DATE, 
	--H.DATEFHEI AS HESA_RECORD_DATE, 
	  H.STAFFID AS STAFF_ID, COALESCE (H.ORCID, '') AS HE_ORCID, 
      COALESCE (H.NATION , '') AS NATIONALITY, 
      COALESCE (H.HQHELD , '') AS HIGH_QUAL_HELD, 
      COALESCE (H.ABLWELSH , '') AS ABILITY_WELSH, 
      COALESCE (H.PREVEMP, '') AS PREV_EMP, 
      COALESCE (H.NATIOND1, '') AS NATIONAL_ID1, 
      COALESCE (H.NATIOND2, '') AS NATIONAL_ID2, 
      COALESCE (H.PREVHEI , '') AS PREV_HEI, '' AS HEP_START_OVR, 
      H.GENDERID AS HE_GENDER, 
      COALESCE (H.DISABLE, '') AS HE_DISABLE, 
      COALESCE (H.PARLEAVE, '') AS HE_PARLEAV1, 
      COALESCE (H.PARLEAVE2, '') AS HE_PARLEAV2, 
      COALESCE (H.ACTLEAVE, '') AS HE_ACTLEAV, 
      COALESCE (H.LOCLEAVE, '') AS HE_LOCLEAV, 
      COALESCE (H.CLINARD, '') AS HE_CLINARD, 
      COALESCE (H.ACTCHQUAL1, '') AS HE_ACTCHQ1, 
      COALESCE (H.ACTCHQUAL2, '') AS HE_ACTCHQ2, 
      COALESCE (H.ACTCHQUAL3, '') AS HE_ACTCHQ3, 
      COALESCE (H.ACTCHQUAL4, '') AS HE_ACTCHQ4, 
      COALESCE (H.ACTCHQUAL5, '') AS HE_ACTCHQ5, 
      COALESCE (H.ACTCHQUAL6, '') AS HE_ACTCHQ6, 
      COALESCE (H.CURACCDIS1, '') AS HE_CURACD1, 
      COALESCE (H.CURACCDIS2, '') AS  HE_CURACD2, 
      COALESCE (H.CURACCDIS3, '') AS HE_CURACD3, 
      COALESCE (H.REFUOA, '') AS HE_REFUOA, 
      COALESCE (H.REGBODY1, '') AS HE_REGBOD1, 
      COALESCE (H.REGBODY2, '') AS HE_REGBOD2, '' AS LEAVER_MUSTER
FROM dbo.HESA_XML_PERSON H
	INNER JOIN dbo.PERSON P
		ON H.EMP_NO = P.EMP_NO
WHERE P.DATE_OF_LEAVING > '20160801'
	OR P.DATE_OF_LEAVING IS NULL;