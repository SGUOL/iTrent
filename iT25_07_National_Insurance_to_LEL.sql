USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.iT25_07_National_Insurance_to_LEL
AS
SELECT PER_REF_NO
	,'Niable pay' AS ELEMENT_NAME
	,NI2LEL AS INPUT_CASH
	,'ELE' AS HISTORY_TYPE
	,'LEL' AS [TYPE]
	,NI_CATEGORY
FROM dbo.PaySlipInfo
WHERE NI2LEL > 0;
GO
