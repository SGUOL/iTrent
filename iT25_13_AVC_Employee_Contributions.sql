USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.iT25_13_AVC_Employee_Contributions
AS
SELECT PER_REF_NO
	,SchemeName AS ELEMENT_NAME
	,YTD_EE_VALUE AS INPUT_CASH
	,'ELE' AS HISTORY_TYPE
FROM dbo.PaySlipPensions
WHERE IsAVC = 'Y'
	AND YTD_EE_VALUE > 0;
GO
