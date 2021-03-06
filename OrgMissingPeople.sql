USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.OrgMissingPeople
AS
SET NOCOUNT ON;
WITH Appoints
AS
(
	SELECT A.EMP_NO AS EMP_NO
		,A.JOB_TITLE
		,CAST(A.DATE_APPOINTED AS date) AS DATE_APPOINTED
		,ROW_NUMBER() OVER (PARTITION BY A.EMP_NO ORDER BY CASE WHEN D.IS_MASTER = 'Y' THEN 0 ELSE 1 END, A.DATE_APPOINTED) AS rn
	FROM dbo.APPOINTMENTS A
		JOIN CONTRACT_DETAILS D
			ON A.EMP_NO = D.EMP_NO
				AND A.CONTRACT_NO = D.CONTRACT_NO
	WHERE A.CURRENT_INDICATOR = 'C'
)
SELECT P.EMP_NO, P.PERSON_STATUS, P.SURNAME, P.FORENAMES, CAST(P.DATE_OF_START AS date) AS DATE_OF_START
	,COALESCE(A.JOB_TITLE, 'NoAppointment') AS JOB_TITLE
FROM dbo.PERSON P
	LEFT JOIN Appoints A
		ON P.EMP_NO = A.EMP_NO
			AND A.rn = 1
	CROSS APPLY
	(
		VALUES
		(
			RIGHT('00000' + LTRIM(RTRIM(P.EMP_NO)), 6)
		)
	) X (PER_REF_NO)
WHERE LEN(P.EMP_NO) < 7
	AND P.PERSON_STATUS NOT LIKE 'L%'
	AND NOT EXISTS
	(
		SELECT *
		FROM dbo.EMP_NO_X_POS_REF E
		WHERE E.EMP_NO = X.PER_REF_NO
	)
ORDER BY SURNAME, FORENAMES;
GO
