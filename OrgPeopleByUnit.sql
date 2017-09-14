USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.OrgPeopleByUnit
AS
SET NOCOUNT ON;

WITH Units
AS
(
	SELECT POST_NO
		,NAME AS Unit
		,CAST(NAME AS varchar(8000)) AS UnitPath
	FROM dbo.OrgStruct
	WHERE [OBJECT] = 'UNIT'
		AND LEN(PARENT_POST_NO) = 0
	UNION ALL
	SELECT S.POST_NO
		,NAME AS Unit
		,UnitPath + '/' + NAME AS UnitPath
	FROM dbo.OrgStruct S
		JOIN Units U
			ON S.PARENT_POST_NO collate database_default = U.POST_NO  collate database_default
	WHERE S.[OBJECT] = 'UNIT'
)
SELECT U.Unit
	,COUNT(*) OVER (PARTITION BY U.POST_NO) AS TotalInUnit
	,X.EMP_NO
	,X.FORENAMES
	,X.SURNAME
	,X.JOB_TITLE
	,U.UnitPath
FROM dbo.EMP_NO_X_POS_REF X
	JOIN dbo.OrgStruct S
		ON X.iTrentPositionRef = S.POST_NO
	JOIN dbo.OrgStruct P
		ON S.PARENT_POST_NO = P.POST_NO
	JOIN Units U
		ON P.PARENT_POST_NO = U.POST_NO
WHERE S.[OBJECT] = 'POSITION'
ORDER by Unit, SURNAME, FORENAMES;
GO
