USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.BuildOrgStructPosRef
AS
SET NOCOUNT ON;

TRUNCATE TABLE dbo.OrgStructPosRef;

WITH XRef
AS
(
	SELECT X.EMP_NO, P.FORENAMES, P.SURNAME
		,S.NAME AS JOB_TITLE
		,S.POST_NO AS iTrentPositionRef
		,ROW_NUMBER() OVER (PARTITION BY X.EMP_NO ORDER BY S.POST_NO) AS rn
	FROM dbo.OrgStruct S
		CROSS APPLY
		(
			VALUES
			(
				REPLACE(REPLACE(REPLACE(RTRIM(LEFT(NAME, charindex(')', NAME))), 'T-', ''), '(', ''), ')', '')
			)

		) X1 (EMP_NO)
		CROSS APPLY
		(
			VALUES
			(
				RIGHT('00000' + X1.EMP_NO, 6)
			)
		) X (EMP_NO)
		JOIN dbo.PERSON P
			ON X1.EMP_NO = P.EMP_NO
	WHERE S.[OBJECT] = 'POSITION'
		AND S.POST_NO NOT LIKE 'PREV%'
)
INSERT INTO dbo.OrgStructPosRef
SELECT EMP_NO, FORENAMES, SURNAME
	,JOB_TITLE, iTrentPositionRef
	,EMP_NO + CHAR(64 + rn) AS PositionOccupancyReferenceNumber
FROM XRef;

TRUNCATE TABLE dbo.EMP_NO_X_POS_REF;

INSERT INTO dbo.EMP_NO_X_POS_REF
SELECT RIGHT('00000' + LTRIM(RTRIM(PR.EMP_NO)), 6) AS EMP_NO
	,LTRIM(RTRIM(PR.FORENAMES)) AS FORENAMES
	,LTRIM(RTRIM(PR.SURNAME)) AS SURNAME
	,LTRIM(RTRIM(SUBSTRING(X.JOB_TITLE, CHARINDEX(')', X.JOB_TITLE) + 1, 255))) AS JOB_TITLE
	,LTRIM(RTRIM(COALESCE(S.POST_NO, PR.iTrentPositionRef))) AS iTrentPositionRef
	--,LTRIM(RTRIM(X.JOB_TITLE)) AS JOB_TITLE_FULL
	--,LTRIM(RTRIM(PR.JOB_TITLE)) AS JOB_TITLE_LOAD
	,LTRIM(RTRIM(SUBSTRING(X.JOB_TITLE, CHARINDEX(')', X.JOB_TITLE) + 1, 255))) AS JOB_TITLE_FULL
	,LTRIM(RTRIM(SUBSTRING(X.JOB_TITLE, CHARINDEX(')', X.JOB_TITLE) + 1, 255))) AS JOB_TITLE_LOAD
	,LTRIM(RTRIM(PR.iTrentPositionRef)) AS iTrentPositionRef_LOAD
	,PR.PositionOccupancyReferenceNumber AS POS_OCC_REF_NO
	,CASE
		WHEN COUNT(*) OVER (PARTITION BY PR.EMP_NO) > 1
		THEN 1
		ELSE 0
	END AS IsMultiContract
FROM dbo.OrgStructPosRef PR
	LEFT JOIN
	(
		 dbo.OrgStructTrans T
			JOIN dbo.OrgStruct S
				ON T.NEW_POST_NO = S.POST_NO
	)
		ON PR.EMP_NO = t.PER_REF_NO
			AND PR.iTrentPositionRef = T.POST_NO
	CROSS APPLY
	(
		VALUES
		(
			COALESCE(S.NAME, PR.JOB_TITLE)
		)
	) X (JOB_TITLE);
GO