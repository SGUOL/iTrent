USE iTLoads;
GO
/****** Object:  View [dbo].[iT06_02_Create_Leaver_Positions_from_Post]    Script Date: 17/08/2017 14:35:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[iT06_99_3_16_1_Structure_Transfer]
AS
SELECT PER_REF_NO
      ,TRANSFER_DATE
      ,TRANSFER_REASON
      ,[OBJECT]
      ,POST_NO
      ,NEW_OBJECT
      ,NEW_POST_NO
FROM dbo.OrgStructTrans
GO


