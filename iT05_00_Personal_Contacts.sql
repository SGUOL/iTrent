USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
ALTER VIEW iT05_00_Personal_Contacts
AS
WITH Contacts
AS
(
	SELECT
		RTRIM(X.PER_REF_NO) AS PER_REF_NO
		,CASE N.N
			WHEN 1 THEN 'Work Telephone'
			WHEN 2 THEN  'Mobile Telephone'
			WHEN 3 THEN 'Fax'
			WHEN 4 THEN 'Personal E-mail address'
			WHEN 5 THEN 'LinkedIn'
			WHEN 6 THEN 'Home Telephone'
		END AS CONTACT_TYPE
		,CASE N.N
			WHEN 1 THEN RTRIM(P.OFFICE_TELEPHONE)
			WHEN 2 THEN RTRIM(P.MOBILE_TELEPHONE)
			WHEN 3 THEN RTRIM(P.FAX_NUMBER)
			WHEN 4 THEN RTRIM(P.EMAIL_ADDRESS)
			WHEN 5 THEN RTRIM(P.LINKEDIN_URL)
			WHEN 6 THEN RTRIM(P.TELEPHONE)
		END AS CONTACT_NO
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
		CROSS JOIN ( VALUES (1),(2),(3),(4),(5),(6)) N(N)
	WHERE P.PERSON_STATUS NOT LIKE 'L%'
		AND LEN(P.EMP_NO) < 7
)
SELECT DISTINCT PER_REF_NO, CONTACT_TYPE, CONTACT_NO
FROM Contacts
WHERE CONTACT_NO IS NOT NULL
	AND LEN(CONTACT_NO) > 0;
GO
