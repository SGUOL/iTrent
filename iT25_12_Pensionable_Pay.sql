USE iTLoads;
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO
CREATE VIEW dbo.iT25_12_Pensionable_Pay
AS
SELECT PER_REF_NO
	,SchemeName + ' - Adjustment' AS ELEMENT_NAME
	,PensionablePayCalc AS INPUT_CASH
	,'ELE' AS HISTORY_TYPE
FROM dbo.PaySlipPensions
WHERE IsAVC = 'N'
	AND PensionablePayCalc > 0;
GO

--WITH DBPenPay
--AS
--(
--	SELECT PER_REF_NO, PenPayDB
--	FROM iTLoads.dbo.PaySlipInfo
--	WHERE PenPayDB > 0
--)
--,CalcPenPay
--AS
--(
--	SELECT PER_REF_NO, SchemeName, PensionablePayCalc
--	FROM iTLoads.dbo.PaySlipPensions
--	WHERE PensionablePayCalc > 0
--)
---- some of these values look odd
----SELECT *
----FROM DBPenPay D
----	FULL JOIN CalcPenPay C
----		ON D.PER_REF_NO = C.PER_REF_NO
--SELECT COALESCE(D.PER_REF_NO, C.PER_REF_NO) AS PER_REF_NO
--	,C.SchemeName + ' - Adjustment' AS ELEMENT_NAME

--	,C.PensionablePayCalc
--	,D.PenPayDB
--	,'ELE' AS HISTORY_TYPE
--FROM CalcPenPay C
--	LEFT JOIN DBPenPay D
--		ON D.PER_REF_NO = C.PER_REF_NO


--select *
--from iTLoads.dbo.PaySlipPensions
--where PensionablePayCalc > 0

--select *
--from iTLoads.dbo.PaySlipInfo
--where PenPayDB > 0