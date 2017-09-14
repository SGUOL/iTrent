USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.iT25_09_National_Insurance_to_UEL
AS
SELECT PER_REF_NO
	,'Niable pay' AS ELEMENT_NAME
	,NI2UEL AS INPUT_CASH
	,'ELE' AS HISTORY_TYPE
	,'UEL' AS [TYPE]
	,NI_CATEGORY
FROM dbo.PaySlipInfo
WHERE NI2UEL > 0;
GO