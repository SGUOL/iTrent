USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.iT25_04_National_Insurance_Employee_Contributions
AS
SELECT PER_REF_NO
	,'NI' AS ELEMENT_NAME
	,NI_EE_Contributions AS INPUT_CASH
	,'ELE' AS HISTORY_TYPE
	,'EE_CONT' AS [TYPE]
	,NI_CATEGORY
FROM dbo.PaySlipInfo
WHERE NI_EE_Contributions > 0;
GO
