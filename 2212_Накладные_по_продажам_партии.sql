/*
SELECT		TABLE_NAME AS [Имя таблицы],
			COLUMN_NAME AS [Имя столбца],
			DATA_TYPE AS [Тип данных столбца],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='InventDim'
order by 2
*/

select RContractTable.DATAAREAID 
	,CustInvoiceJour.SALESID
	--,CASE 
	--	WHEN CustInvoiceJour.SZ_InventTransfer = '0' THEN 'Нет'
	--	WHEN CustInvoiceJour.SZ_InventTransfer = '1' THEN 'Да'
	-- END as Перемещение_по_накл
	--,CONVERT(date,InventBatch.arrivalDate,103) as Дата_прихода_партии
	--,InventBatch.SZ_VendAccount
	--,VENDTABLE.NAME
--	,CustInvoiceTrans.InvoiceId as Код_Накладной_DAX
	,CustInvoiceJour.INVOICEEXTERNALID
	,CustInvoiceTrans.LineNUM
--	,InventTrans.INVENTTRANSID
	,InventTrans.ITEMID
	,InventTrans.Storno_RU
--	,CustInvoiceTrans.QTY as InvoiceTransQTY
--	,InventTrans.QTY
	,InventDim.INVENTBATCHID 
	,SUM(CAST(InventTrans.QTY as int)) OVER (PARTITION BY CustInvoiceTrans.InvoiceId,CustInvoiceTrans.LineNUM) as Кол_во_в_строке_накладной
	--,CASE
	--	WHEN INVENTTRANS.STATUSISSUE = 0 THEN ''
	--	WHEN INVENTTRANS.STATUSISSUE = 1 THEN 'Продано'
	--	WHEN INVENTTRANS.STATUSISSUE = 2 THEN 'Отпущено'
	--	WHEN INVENTTRANS.STATUSISSUE = 3 THEN 'Скоплектовано'
	--	WHEN INVENTTRANS.STATUSISSUE = 4 THEN 'Физ.резерв'
	--	WHEN INVENTTRANS.STATUSISSUE = 5 THEN 'Резерв.в.заказах'
	--	WHEN INVENTTRANS.STATUSISSUE = 6 THEN 'Заказано'
	--	WHEN INVENTTRANS.STATUSISSUE = 7 THEN 'Расход по предложению'
	-- END as INVENTTRANSSTATUS
	, CustInvoiceTrans.SalesPrice as Цена_за_ед_изм
--	,CustInvoiceTrans.LineAmount
	, CustInvoiceTrans.LineAmount / CustInvoiceTrans.Qty * InventTrans.QTY as Сумма_без_НДС
	, CustInvoiceTrans.TAXAMOUNT / CustInvoiceTrans.Qty * InventTrans.QTY as Сумма_налога
	, (CustInvoiceTrans.LineAmount / CustInvoiceTrans.Qty * InventTrans.QTY + CustInvoiceTrans.TAXAMOUNT / CustInvoiceTrans.Qty * InventTrans.QTY) as Сумма_с_налогом
	,CAST(SalesTable.AmountTotalExclTax AS NUMERIC(20,2)) as Сумма_в_заказе_Без_НДС
	,SUM(CustInvoiceTrans.LineAmount / CustInvoiceTrans.Qty * InventTrans.QTY) OVER (PARTITION BY SALESTABLE.salesid)  as Расчетная_сумма_по_заказу_БезНДС
--	, CustInvoiceTrans.TaxItemGroup as Налоговая_группа
	--, CASE 
	--	WHEN InventTable.ItemType = '0' THEN 'Номенклатура' 
	--	WHEN InventTable.ItemType = '1' THEN 'Спецификация'
	--	WHEN InventTable.ItemType = '2' THEN 'Услуга'
	--	WHEN InventTable.ItemType = '100' THEN 'Основные_средства'
	--  END as Тип_номенклатуры

from CustInvoiceJour
JOIN CustInvoiceTrans	ON CustInvoiceJour.INVOICEID = CUSTINVOICETRANS.INVOICEID 
	AND CustInvoiceJour.SALESID				= CUSTINVOICETRANS.SALESID
	AND CustInvoiceJour.INVOICEDATE			= CUSTINVOICETRANS.INVOICEDATE
	AND CustInvoiceJour.NUMBERSEQUENCEGROUP = CUSTINVOICETRANS.NUMBERSEQUENCEGROUP
	AND CustInvoiceJour.DATAAREAID			= CUSTINVOICETRANS.DATAAREAID
	AND CustInvoiceJour.creaTEDDATETIME > '2022-12-31T00:00:00.000'
--	AND CUSTINVOICETRANS.INVOICEID IN ('0312674','00001153_094')
JOIN SALESTABLE on CustInvoiceJour.salesid = SALESTABLE.salesid
JOIN RContractTable		ON CustInvoiceJour.RContractAccount = RContractTable.RContractAccount
	AND CustInvoiceJour.DATAAREAID = RContractTable.DATAAREAID
	and RContractTable.DATAAREAID = 'sz'
--	AND CustInvoiceJour.RContractAccount = 'ДГ00019247'
JOIN InventTrans		ON CUSTINVOICETRANS.INVENTTRANSID = InventTrans.INVENTTRANSID
	AND CustInvoiceJour.LEDGERVOUCHER = InventTrans.VOUCHER 
	AND CUSTINVOICETRANS.INVOICEID	 = InventTrans.INVOICEID
	AND CUSTINVOICETRANS.DATAAREAID	 = InventTrans.DATAAREAID
	AND CUSTINVOICETRANS.SALESID	 = InventTrans.TransRefId
	AND CUSTINVOICETRANS.ITEMID		 = InventTrans.ITEMID
JOIN InventDim			ON InventTrans.INVENTDIMID = InventDim.INVENTDIMID
	AND InventDim.DATAAREAID = 'vir'
JOIN InventBatch		ON InventDim.INVENTBATCHID = InventBatch.inventBatchId
	AND InventTrans.ITEMID = InventBatch.ITEMID
	AND InventBatch.DATAAREAID = 'sz'
	AND InventBatch.arrivalDate BETWEEN '2022-12-01T00:00:00.000' AND '2022-12-31T00:00:00.000'
JOIN VENDTABLE			ON InventBatch.SZ_VendAccount = VENDTABLE.ACCOUNTNUM
	AND VENDTABLE.DATAAREAID = 'vir'
	AND InventBatch.SZ_VendAccount = 'П006033'
ORDER BY 2,3,4
 




/*
select * from inventTransReference
select
	SALESLINE.SALESID
	,SALESLINE.LINENUM
	,INVENTTRANS.INVENTTRANSID
	,INVENTTRANS.ITEMID
	,INVENTTRANS.QTY
	,INVENTTRANS.INVOICEID
	,INVENTTRANS.STORNO_RU
	,INVENTTRANS.STORNOPHYSICAL_RU
	,INVENTTRANS.SZ_ISFILIAL
	,INVENTTRANS.TAXAMOUNTPHYSICAL
	,INVENTTRANS.VOUCHER
	,InventTrans.CostAmountPosted
from SALESLINE
JOIN INVENTTRANS ON SALESLINE.INVENTTRANSID = INVENTTRANS.INVENTTRANSID
			AND INVENTTRANS.DATAAREAID	= SALESLINE.DATAAREAID
			AND InventTrans.TransRefId	= SALESLINE.SALESID
			AND InventTrans.ITEMID		= SALESLINE.ITEMID
JOIN CUSTINVOICETRANS on INVENTTRANS.VOUCHER = CUSTINVOICETRANS.

WHERE INVENTTRANS.DATAAREAID = 'SZ'
	AND InventTrans.TransType	= 0
	AND InventTrans.TransRefId = '00587317_069'
*/