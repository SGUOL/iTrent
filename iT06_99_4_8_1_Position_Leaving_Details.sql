USE iTLoads;
GO
/****** Object:  View [dbo].[iT06_02_Create_Leaver_Positions_from_Post]    Script Date: 17/08/2017 14:35:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[iT06_99_4_8_1_Position_Leaving_Details]
AS
SELECT X.PER_REF_NO
      ,TRANSFER_DATE AS END_DATE
	  ,'F' AS EXIT_INTERVIEW_DONE
      ,'Transfer' AS POS_LEAVING_REASON
      ,'POSITION' AS [OBJECT]
      ,POST_NO
      ,'POSITION' AS PARENT_OBJECT
      ,NEW_POST_NO AS PARENT_POST_NO
	  ,TRANSFER_DATE AS EFFECTIVE_DATE
FROM dbo.OrgStructTrans T
	CROSS APPLY
	(
		VALUES
		(
			RIGHT('00000' + LTRIM(RTRIM(T.PER_REF_NO)), 6)
		)
	) X (PER_REF_NO);
GO


