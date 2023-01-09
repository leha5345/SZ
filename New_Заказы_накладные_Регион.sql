
DECLARE @DATAAREAID nvarchar(4), @VOUCHER  nvarchar(30),@INVOICEID nvarchar(30), @ITEMID nvarchar(20);
	SET @DATAAREAID = 'SC';
--	SET @VOUCHER  = '10951805_080';
	--SET @INVOICEID  = 'СЦ00000186';
	--SET @ITEMID = '64428';


select  DISTINCT
	  CustInvoiceJour.DATAAREAID as Код_компании
	, CASE 
		WHEN SALESTABLE.SZ_InventTransfer = '0' THEN 'Нет'
		WHEN SALESTABLE.SZ_InventTransfer = '1' THEN 'Да'
	  END as Перемещение_по_заказу
	, CASE 
		WHEN CustInvoiceJour.SZ_InventTransfer = '0' THEN 'Нет'
		WHEN CustInvoiceJour.SZ_InventTransfer = '1' THEN 'Да'
	  END as Перемещение_по_накл
	, SALESTABLE.SALESID as Номер_заказа
--	, SalesTable.SZ_CustAccountTransfer as Клиент_Плательщик
--  , SalesTable.CustAccount as Клиент
	, CUST.ACCOUNTNUM as Код_клиента
	, CUST.NAMEALIAS as Наименование_клиента
	, RContractTable.RContractAccount
	, RContractTable.RContractNumber as Номер_договора
	, RContractTable.RContractSubjectId as Предмет_договора
	, SalesTable.SalesResponsible as Сотрудник
	, CustInvoiceJour.InvoiceId as Код_Накладной_DAX
	, CustInvoiceJour.InvoiceExternalId as Накладная_вн_номер
--	, CustInvoiceJour.InvoiceDate as Дата_накладной
	, CONVERT(date,CustInvoiceJour.InvoiceDate,103) as Дата_накладной
	, DAY(CustInvoiceJour.InvoiceDate) as День_накладной
	, MONTH(CustInvoiceJour.InvoiceDate) as Месяц_накладной
	, YEAR(CustInvoiceJour.InvoiceDate) as Год_накладной
--	, CustInvoiceJour.SZ_InvoiceIdIssueReceiver as Накладная_МП
	, CustInvoiceTrans.ItemId as Код_номенклатуры
--	, InventTable.ItemType as Тип_номенклатуры
	, CASE 
		WHEN InventTable.ItemType = '0' THEN 'Номенклатура' 
		WHEN InventTable.ItemType = '1' THEN 'Спецификация'
		WHEN InventTable.ItemType = '2' THEN 'Услуга'
		WHEN InventTable.ItemType = '100' THEN 'Основные_средства'
	  END as Тип_номенклатуры

--	, CustInvoiceTrans.Qty as Кол_во
	, InventTrans.INVENTTRANSID
	, InventTrans.QTY *-1 as Кол_во
	, CustInvoiceTrans.LineAmount / CustInvoiceTrans.Qty * InventTrans.QTY *-1 as Сумма_без_НДС
--	, CustInvoiceTrans.LineAmount
	, CustInvoiceTrans.TAXAMOUNT / CustInvoiceTrans.Qty * InventTrans.QTY *-1 as Сумма_налога
--	, CAST(CustInvoiceTrans.Qty AS decimal(10,0)) as Кол_во
--	, CustInvoiceTrans.TAXAMOUNT as Сумма_налога_0
--	, CustInvoiceTrans.LineAmount + CustInvoiceTrans.TAXAMOUNT as Сумма_с_налогом
	, CustInvoiceTrans.TaxItemGroup as Налоговая_группа
--	, SalesTable.InclTax as Цена_включает_налог
	, CustInvoiceTrans.SalesPrice as Цена_за_ед_изм
	, CASE 
		WHEN SalesTable.InclTax = '0' THEN 'Нет'
		WHEN SalesTable.InclTax = '1' THEN 'Да'
	  END as Цена_включает_налог
--	, CAST(CustInvoiceTrans.LineAmount AS NUMERIC(10,2)) as Сумма_без_НДС
--	, CAST(CustInvoiceTrans.TAXAMOUNT AS NUMERIC(10,2)) as Сумма_налога
	, (CustInvoiceTrans.LineAmount / CustInvoiceTrans.Qty * InventTrans.QTY *-1 + CustInvoiceTrans.TAXAMOUNT / CustInvoiceTrans.Qty * InventTrans.QTY *-1) as Сумма_с_налогом
--	, CAST(CustInvoiceTrans.LineAmount AS NUMERIC(20,2)) + CAST(CustInvoiceTrans.TAXAMOUNT AS NUMERIC(20,2)) as Сумма_с_налогом
--	, CUSTTRANS.AMOUNTCUR
--	, CUSTTRANS.LEDGERACCOUNT
	, CustInvoiceJour.SZ_STORNO as Сторнирующий_док--= 0
	, CustInvoiceJour.SZ_STORNED as Сторнирован--= 0
	, CustInvoiceJour.Correct_RU as Корректировка
--	, SalesTable.AmountTotalExclTax as Сумма_без_НДС_по_заказу --<> 0
	, InventDim.INVENTBATCHID as Партия
	, CUSTINVOICETRANSPURCHREAL31176.PurchRealPrice as РВЦ
	, InventTable.Vital as ЖВ	
	--, InventDim.INVENTDIMID as Код_аналитики
	, AddressState.NAME as Регион -- взят с таблицы CUSTTABLE
	, InventTable.ItemName as Наименование_номенклатуры -- всегда ставить последним столбом
from CustInvoiceJour
JOIN CustInvoiceTrans	ON CustInvoiceJour.INVOICEID = CUSTINVOICETRANS.INVOICEID 
	AND CustInvoiceJour.SALESID				= CUSTINVOICETRANS.SALESID
	AND CustInvoiceJour.INVOICEDATE			= CUSTINVOICETRANS.INVOICEDATE
	AND CustInvoiceJour.NUMBERSEQUENCEGROUP = CUSTINVOICETRANS.NUMBERSEQUENCEGROUP
	AND CustInvoiceJour.DATAAREAID			= CUSTINVOICETRANS.DATAAREAID
JOIN RContractTable	ON CustInvoiceJour.RContractAccount = RContractTable.RContractAccount
	AND CustInvoiceJour.DATAAREAID = RContractTable.DATAAREAID
JOIN SALESTABLE			ON CustInvoiceJour.SALESID		= SALESTABLE.SALESID
LEFT JOIN InventTrans		ON CUSTINVOICETRANS.INVENTTRANSID = InventTrans.INVENTTRANSID
	AND CUSTINVOICETRANS.DATAAREAID	 = InventTrans.DATAAREAID
	AND CUSTINVOICETRANS.SALESID	 = InventTrans.TransRefId
	AND CUSTINVOICETRANS.ITEMID		 = InventTrans.ITEMID
	--AND InventTrans.TransType	= 0 -- заказ на продажу
	--AND InventTrans.StatusIssue = 1 -- Расход = Продано
	--AND InventTrans.Direction	= 2 -- Приход/Уход = Расход
LEFT JOIN WMSORDERTRANS ON InventTrans.INVENTTRANSID = WMSORDERTRANS.INVENTTRANSID
	AND InventTrans.TransRefId	= WMSOrderTrans.inventTransRefId
	AND InventTrans.ITEMID		= WMSOrderTrans.ITEMID
	AND InventTrans.INVENTDIMID = WMSOrderTrans.INVENTDIMID 
	AND InventTrans.DATAAREAID	= WMSOrderTrans.DATAAREAID
LEFT JOIN WMSPickingRoute	ON WMSORDERTRANS.ROUTEID = WMSPickingRoute.PICKINGROUTEID
	AND WMSORDERTRANS.DATAAREAID		= WMSPickingRoute.DATAAREAID
	AND WMSOrderTrans.inventTransRefId	= WMSPickingRoute.TRANSREFID
	AND WMSOrderTrans.INVENTTRANSTYPE	= WMSPickingRoute.TRANSTYPE
	AND WMSOrderTrans.SHIPMENTID		= WMSPickingRoute.shipmentId

--	JOIN CUSTTRANS			ON CustInvoiceJour.InvoiceId	= CUSTTRANS.INVOICE
JOIN CUSTTABLE AS CUST	ON CustInvoiceJour.OrderAccount = CUST.ACCOUNTNUM
LEFT JOIN CUSTTABLE as Consignee	ON WMSPickingRoute.CarrierCode = Consignee.ACCOUNTNUM
	--JOIN DirPartyAddressRelationship ON CUSTTABLE.PARTYID = DirPartyAddressRelationship.PARTYID
	--LEFT JOIN DirPartyTable			 ON DirPartyAddressRelationship.PARTYID = DirPartyTable.PARTYID
	--LEFT JOIN DIRPARTYADDRESSRELATIONSHI1066 ON DirPartyAddressRelationship.RECID = DIRPARTYADDRESSRELATIONSHI1066.PARTYADDRESSRELATIONSHIPRECID
	--LEFT JOIN ADDRESS				 ON DIRPARTYADDRESSRELATIONSHI1066.ADDRESSRECID = ADDRESS.RECID
	--AND ADDRESS.DATAAREAID = DirPartyAddressRelationship.DATAAREAID
LEFT JOIN AddressState	ON Consignee.STATE = AddressState.STATEID
JOIN InventTable		ON InventTrans.ItemId		= InventTable.ItemId
JOIN InventDim			ON InventTrans.INVENTDIMID = InventDim.INVENTDIMID
	AND InventDim.DATAAREAID = 'vir'
		
LEFT JOIN CUSTINVOICETRANSPURCHREAL31176 ON WMSOrderTrans.inventTransRefId = CUSTINVOICETRANSPURCHREAL31176.TransRefId
	AND InventTrans.InventTransId	= CUSTINVOICETRANSPURCHREAL31176.INVENTTRANSID
	AND InventTrans.INVENTDIMID		= CUSTINVOICETRANSPURCHREAL31176.INVENTDIMID
	AND InventTrans.ITEMID			= CUSTINVOICETRANSPURCHREAL31176.ITEMID
	AND InventTrans.INVENTTRANSID	= CUSTINVOICETRANSPURCHREAL31176.INVENTTRANSID
	AND CUSTINVOICETRANSPURCHREAL31176.DATAAREAID = @DATAAREAID
	AND CUSTINVOICETRANSPURCHREAL31176.TransType = 0 -- Заказ на продажу
--		AND CUSTINVOICETRANSPURCHREAL31176.Status = 1	-- Проверено

WHERE
	CustInvoiceJour.DATAAREAID = @DATAAREAID
	AND CustInvoiceTrans.DATAAREAID = @DATAAREAID
---	AND CUSTTRANS.DATAAREAID = @DATAAREAID
	AND SALESTABLE.DATAAREAID = @DATAAREAID
--	AND AddressState.COUNTRYREGIONID = 'RU'
--	AND SALESTABLE.SALESID = '00578971_069'
--	AND SALESTABLE.SALESSTATUS = 3
--AND CustInvoiceJour.InvoiceDate BETWEEN '2022-11-01T00:00:00.000' AND '2023-11-30T00:00:00.000'
--	AND InventTable.TenderInventTradeName LIKE 'ОМНИ%'
--	AND CustInvoiceTrans.NAME LIKE 'ОМНИ%'
--	AND SalesTable.CustAccount = 'Кл003100'
--	AND  SalesTable.SZ_CustAccountTransfer = 'Кл003100'
	AND CustInvoiceJour.InvoiceExternalId IN ('36220000039','36220000134') --10220025374
--	AND CUSTINVOICEJOUR.INVOICEID = @INVOICEID
--	AND CustInvoiceJour.SZ_InvoiceIdIssueReceiver = ''

	--AND CustInvoiceJour.SZ_STORNO = 0
	--AND CustInvoiceJour.SZ_STORNED = 0
	--AND SalesTable.AmountTotalExclTax <>c 0

--	AND InventTable.ITEMID = '51990'
--	AND InventTable.ItemType = 2
--	AND CustInvoiceTrans.ItemId IN ('29893')
--	AND WMSOrderTrans.ITEMID = '59338'
--	AND CustInvoiceTrans.TaxItemGroup LIKE '%20%'
--	AND SalesTable.InclTax = 0
--	AND CustInvoiceTrans.LineAmountTax <> CustInvoiceTrans.TAXAMOUNT
--	AND CUSTTRANS.VOUCHER = @VOUCHER
--	AND PurchRealPriceTable.InventBatchId = 'СЦ00000216_105-СЦ00000780_130'



