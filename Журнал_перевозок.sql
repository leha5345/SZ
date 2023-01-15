
DECLARE @JOURNALID nvarchar(10), @DATAAREAID nvarchar(4), @InvoiceId nvarchar(30), @QtyInvoiceExternalId int, @QtyInvoiceIdIssueReceiver int;
  SET @DATAAREAID = 'SZ';
  SET @JOURNALID = '221_055258';
--  SET @InvoiceId = '10220028471' 

select 
	L.DATAAREAID
	,L.JOURNALID
	,L.CREATEDDATE
	,L.Status
	,L.Тип
	,L.VEHICLETTNID
	,L.CUSTACCOUNT
	,L.CONSIGNEEACCOUNT
--	,L.Кол_во_накл_по_DAX
	,COUNT(L.STOREDINVOICEEXTERNALID) OVER (PARTITION BY L.DATAAREAID,L.JOURNALID ORDER BY L.JOURNALID) as R -- Кол-во накладных
	,SUM(CASE WHEN L.SZ_INVOICEIDISSUERECEIVER <> '' THEN 1 ELSE 0 END) OVER (PARTITION BY L.DATAAREAID,L.JOURNALID ORDER BY L.JOURNALID) as R_SUM -- Кол-во МП накладных
--	,COUNT(NULLIF(L.SZ_INVOICEIDISSUERECEIVER,'')) OVER (PARTITION BY L.DATAAREAID,L.JOURNALID ORDER BY L.JOURNALID) as R_COUNT -- тоже самое что и R_SUM просто другим способом
	,L.STOREDINVOICEEXTERNALID
	,L.SZ_INVOICEIDISSUERECEIVER

from (
	select DISTINCT
		LogisticJournalTable.DATAAREAID
		,LogisticJournalTable.JournalId
		,CONVERT(date,LogisticJournalTable.CREATEDDATETIME,103) as CREATEDDATE
		,CASE 
			WHEN LogisticJournalTable.JournalStatus = 2 THEN 'Груз погружен'
			WHEN LogisticJournalTable.JournalStatus = 9 THEN 'Проект'
		 END as Status
		,CASE 
			WHEN CARRIERROUTELINE.PARTNERTYPE = 0 THEN 'Клиент'
			WHEN CARRIERROUTELINE.PARTNERTYPE = 1 THEN 'Поставщик'
		 END as Тип
		,LogisticTTNTable.VehicleTTNId -- вывести в олап "Код ТН"
		,CARRIERROUTELINE.CUSTACCOUNT
	--  ,LogisticTTNTable.CustAccountConsignee -- грузополучатель по ТН
		,CARRIERROUTELINE.CONSIGNEEACCOUNT -- вывести в олап "Код грузополучателя"
	--  ,CarrierRouteLine.InvoiceId
		,LogisticJournalTable.OutgoingCarrierRouteQty as Кол_во_накл_по_DAX
		,WMSPickingRoute.SZ_LogisticJournalId
		,WMSPickingRoute.StoredInvoiceExternalId
		,WMSPickingRoute.SZ_InvoiceIdIssueReceiver
		

	--	,ROW_NUMBER (WMSPickingRoute.SZ_InvoiceIdIssueReceiver) OVER (PARTITION BY LogisticJournalTable.DATAAREAID,LogisticJournalTable.JOURNALID ORDER BY LogisticJournalTable.DATAAREAID,LogisticJournalTable.JOURNALID) as Row
	--	,COUNT(WMSPickingRoute.SZ_InvoiceIdIssueReceiver) OVER (PARTITION BY LogisticJournalTable.DATAAREAID,LogisticJournalTable.JournalId,WMSPickingRoute.SZ_LogisticJournalId) as QTY_MPInvoice
	 -- ,WMSORDERTRANS.ItemId
	--  ,WMSORDERTRANS.INVENTTRANSID

	from LogisticJournalTable
	LEFT JOIN CARRIERROUTELINE ON LogisticJournalTable.CARRIERROUTEID	= CARRIERROUTELINE.ROUTEID
		AND CARRIERROUTELINE.DATAAREAID = LogisticJournalTable.DATAAREAID
	LEFT JOIN LogisticTTNTable ON CARRIERROUTELINE.PARTNERTYPE			= LogisticTTNTable.PARTNERTYPE
		AND CARRIERROUTELINE.PARTNERACCOUNT = LogisticTTNTable.CUSTACCOUNTCONSIGNEE
		AND CARRIERROUTELINE.CUSTACCOUNT = LogisticTTNTable.CUSTACCOUNT
		AND logisticJournalTable.JournalId = logisticTTNTable.LogisiticJournalId
	RIGHT JOIN WMSPICKINGROUTE  ON CARRIERROUTELINE.WMSSHIPMENTID = WMSPICKINGROUTE.SHIPMENTID
		AND CARRIERROUTELINE.ORDERID = WMSPICKINGROUTE.PICKINGROUTEID
		AND CARRIERROUTELINE.DATAAREAID = WMSPICKINGROUTE.DATAAREAID
	JOIN WMSORDERTRANS      ON WMSPICKINGROUTE.PICKINGROUTEID = WMSORDERTRANS.ROUTEID
		AND WMSPICKINGROUTE.DATAAREAID = WMSORDERTRANS.DATAAREAID

	WHERE LogisticJournalTable.DATAAREAID = @DATAAREAID
		AND LogisticJournalTable.CREATEDDATETIME > '2022-01-01T00:00:00.000'
	--	AND LogisticJournalTable.JournalId = @JOURNALID
	--  AND CarrierRouteLine.InvoiceId = @InvoiceId
	) as L
ORDER BY 2
