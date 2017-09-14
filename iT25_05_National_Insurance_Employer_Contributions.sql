USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.iT25_05_National_Insurance_Employer_Contributions
AS
SELECT PER_REF_NO
	,'NI' AS ELEMENT_NAME
	,NI_ER_Contributions AS INPUT_CASH
	,'ELE' AS HISTORY_TYPE
	,'ER_CONT' AS [TYPE]
	,NI_CATEGORY
FROM dbo.PaySlipInfo
WHERE NI_ER_Contributions > 0;
GO
