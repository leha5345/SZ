

DECLARE @EDIDOCTYPE INT, @DATAAREAID NVARCHAR(4), @EDICUSTVENDTYPE INT, @EDIPlatformApi INT, @EDIMEMBERID NVARCHAR(30);
	SET	@DATAAREAID = 'SZ';
	SET @EDIMEMBERID = '';
	SET @EDICUSTVENDTYPE = 20; -- 20 Поставщик
	SET @EDIPlatformApi = 1; --1 СБИС
	SET @EDIDOCTYPE = 10; -- 10 входящий, правление потока
	
WITH VendParmCTE
	AS
	(
SELECT EDICustVendParm.DATAAREAID
	,CASE
		WHEN EDICustVendParm.EDICUSTVENDTYPE = 20 THEN 'Поставщик'
		WHEN EDICustVendParm.EDICUSTVENDTYPE = 10 THEN 'Клиент'
	END AS 'Тип контрагента'
	,CASE
		WHEN EDICustVendParm.EDIPlatformApi = 0 THEN ''
		WHEN EDICustVendParm.EDIPlatformApi = 1 THEN 'СБИС'
		WHEN EDICustVendParm.EDIPlatformApi = 2 THEN 'МДЛП'
	END AS 'Платформа'
	,EDICustVendParm.CUSTVENDAC AS ACOUNTNUM
	,EDICustVendParm.EDIMEMBERID AS id	
FROM EDICustVendParm
WHERE EDICustVendParm.EDICUSTVENDTYPE = @EDICUSTVENDTYPE
	AND EDICustVendParm.EDIPlatformApi = @EDIPlatformApi
	AND EDICustVendParm.EDIMEMBERID <> @EDIMEMBERID
	AND EDICustVendParm.DATAAREAID = @DATAAREAID
-- EDIPackage.EDIPACKAGEID IN ('EC65AA5E-780E-4DE5-A980-CC30C7EDA577','5B62417E-2D86-4389-8B42-BDC16FB1A3FC','1E13CECC-649A-4819-87E2-40DE346D3A0A')
	),

EDIPackageCTE
	AS
	(
SELECT EDIPackage.DATAAREAID
	,CASE
		WHEN EDIPackage.EDIDOCTYPE = 10 THEN 'Входящий'
		WHEN EDIPackage.EDIDOCTYPE = 20 THEN 'Исходящий'
	END AS 'Направление'	
	,EDIPackage.EDIPACKAGEID
	,EDIPackage.CUSTVENDAC
	,EDIPackage.TRANSREFID
	,EDIPackage.DOCUMENTNUM
	,CONVERT(NVARCHAR,EDIPackage.DOCUMENTDATE,104) AS DOCUMENTDATE
	,CASE
		WHEN EDIPackage.STATUS = 10 THEN 'Создано'
		WHEN EDIPackage.STATUS = 20 THEN 'Обработка'
		WHEN EDIPackage.STATUS = 30 THEN 'Обработано'
		WHEN EDIPackage.STATUS = 32 THEN 'Ошибка'
		WHEN EDIPackage.STATUS = 34 THEN 'Утверждено'
		WHEN EDIPackage.STATUS = 35 THEN 'Отклонено'
		WHEN EDIPackage.STATUS = 36 THEN 'Запрошено аннулир'
		WHEN EDIPackage.STATUS = 37 THEN 'Аннулировано'
		WHEN EDIPackage.STATUS = 38 THEN 'Удален'
	END AS Статус
	,'--->Детализ.шапки' AS Разделитель
	,M.INVOICENUM
	,M.FACTURENUM
	,M.Total_DOC
	,M.Invoice_SUM
	,M.SF_SUM
	,M.Protocol_SUM
	,M.Letter_SUM
	,M.Zero_SUM
	,M.Diferent_SUM	 
FROM EDIPackage
LEFT JOIN 
	(
	SELECT DISTINCT
		EDIPurchSalesMessageTable.DATAAREAID
		--,CASE
		--	WHEN EDIPurchSalesMessageTable.EDIPlatformApi = 0 THEN ''
		--	WHEN EDIPurchSalesMessageTable.EDIPlatformApi = 1 THEN 'СБИС'
		--	WHEN EDIPurchSalesMessageTable.EDIPlatformApi = 2 THEN 'МДЛП'
		--END AS EDIPlatformApi	
		,CASE
			WHEN EDIPurchSalesMessageTable.EDIDocType = 10 THEN 'Входящий'
			WHEN EDIPurchSalesMessageTable.EDIDocType = 20 THEN 'Исходящий'
		END AS 'Направление'
		,EDIPurchSalesMessageTable.PACKAGEID	
--		,ROW_NUMBER() OVER (PARTITION BY EDIPurchSalesMessageTable.EDIDocType, EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.PACKAGEID ORDER BY EDIPurchSalesMessageTable.EDIDocumentTypes) AS RowNumber
		,COUNT(EDIPurchSalesMessageTable.EDIDocumentTypes) OVER (PARTITION BY EDIPurchSalesMessageTable.EDIDocType, EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.PACKAGEID ORDER BY EDIPurchSalesMessageTable.PACKAGEID) AS Total_DOC
		--,CASE 
  --  		WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 5 THEN 'СФ'
  --  		WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 10 THEN 'Накладная'
		--	WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 85 THEN 'Письмо'
		--	WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 86 THEN 'Протокол'
		--	WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 0 THEN ''
		--END AS DOC
		--,EDIPurchSalesMessageTable.EDIDocumentTypes
		,SUM(CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 5 THEN 1 ELSE 0 END) OVER (PARTITION BY EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.EDIDocType,EDIPurchSalesMessageTable.PACKAGEID) AS SF_SUM
		,SUM(CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 10 THEN 1 ELSE 0 END) OVER (PARTITION BY EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.EDIDocType,EDIPurchSalesMessageTable.PACKAGEID) AS Invoice_SUM
		,SUM(CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 85 THEN 1 ELSE 0 END) OVER (PARTITION BY EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.EDIDocType,EDIPurchSalesMessageTable.PACKAGEID) AS Letter_SUM
		,SUM(CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 86 THEN 1 ELSE 0 END) OVER (PARTITION BY EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.EDIDocType,EDIPurchSalesMessageTable.PACKAGEID) AS Protocol_SUM
		,SUM(CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 0 THEN -1 ELSE 0 END) OVER (PARTITION BY EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.EDIDocType) AS Zero_SUM
		,SUM(CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes NOT IN (5, 10, 85, 86, 0) THEN 1 ELSE 0 END) OVER (PARTITION BY EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.EDIDocType) AS Diferent_SUM
		--,CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 5 THEN 1 ELSE 0 END AS SF	
		--,CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 10 THEN 1 ELSE 0 END AS Invoice
		--,CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 85 THEN 1 ELSE 0 END AS Letter
		--,CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 86 THEN 1 ELSE 0 END AS Protocol
		--,CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes = 0 THEN -1 ELSE 0 END AS Zero
		--,CASE WHEN EDIPurchSalesMessageTable.EDIDocumentTypes NOT IN (5, 10, 85, 86, 0) THEN 1 ELSE 0 END AS Diferent  
--		,EDIPurchSalesMessageTable.INVOICENUM
--		,EDIPurchSalesMessageTable.FACTURENUM
		,MAX(EDIPurchSalesMessageTable.INVOICENUM) OVER (PARTITION BY EDIPurchSalesMessageTable.EDIDocType, EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.PACKAGEID ORDER BY EDIPurchSalesMessageTable.PACKAGEID) AS INVOICENUM
		,MAX(EDIPurchSalesMessageTable.FACTURENUM) OVER (PARTITION BY EDIPurchSalesMessageTable.EDIDocType, EDIPurchSalesMessageTable.DATAAREAID,EDIPurchSalesMessageTable.PACKAGEID ORDER BY EDIPurchSalesMessageTable.PACKAGEID) AS FACTURENUM
		--,EDIPurchSalesMessageTable.STATUS
		--,CASE
  --   		WHEN EDIPurchSalesMessageTable.Status_SBIS = 0 THEN 'Создано'
  --   		WHEN EDIPurchSalesMessageTable.Status_SBIS = 3 THEN 'Есть док'
		--	WHEN EDIPurchSalesMessageTable.Status_SBIS = 8 THEN 'Выполнение завершено с проблемами'
		--	WHEN EDIPurchSalesMessageTable.Status_SBIS = 15 THEN 'Удален контрагентом'
		--	WHEN EDIPurchSalesMessageTable.Status_SBIS = 16 THEN 'Аннулирован по соглашению'
		--	WHEN EDIPurchSalesMessageTable.Status_SBIS = 21 THEN 'Утверждено'
		-- END AS Status_SBIS
	FROM EDIPurchSalesMessageTable
	WHERE EDIPurchSalesMessageTable.DATAAREAID = @DATAAREAID
		AND EDIPurchSalesMessageTable.EDIDocType = @EDIDOCTYPE -- входящ
	) AS M
		ON EDIPackage.EDIPACKAGEID = M.PACKAGEID
		AND EDIPackage.DATAAREAID = M.DATAAREAID
WHERE EDIPackage.DATAAREAID = @DATAAREAID
	AND EDIPackage.EDIDOCTYPE = @EDIDOCTYPE
-- EDIPackage.EDIPACKAGEID IN ('EC65AA5E-780E-4DE5-A980-CC30C7EDA577','5B62417E-2D86-4389-8B42-BDC16FB1A3FC','1E13CECC-649A-4819-87E2-40DE346D3A0A')
	),
VendInvoiceJourCTE
	AS
	(
	SELECT VendInvoiceJour.DATAAREAID
		,VendInvoiceJour.InvoiceAccount
		,VendInvoiceJour.InvoiceId
--		,VendInvoiceJour.InvoiceDate
		,CONVERT(NVARCHAR, VendInvoiceJour.InvoiceDate, 104) AS InvoiceDate
		,RContractTable.RContractCode
		,RContractTable.RContractSubjectId
--		,RContractTable.RContractSubject
		,RContractTable.RContractSubjectBrief
	FROM VendInvoiceJour
	JOIN RContractTable
		ON VendInvoiceJour.InvoiceAccount = RContractTable.RContractPartnerCode
			AND VendInvoiceJour.RContractAccount = RContractTable.RContractAccount
			AND VendInvoiceJour.DATAAREAID = RContractTable.DATAAREAID
	--JOIN VENDTABLE
	--	ON RContractTable.RContractPartnerCode = VENDTABLE.ACCOUNTNUM
	WHERE VendInvoiceJour.DATAAREAID = @DATAAREAID
	)
SELECT DISTINCT '-->>Параметры' AS EDI
	,VendParmCTE.DATAAREAID
	,VendParmCTE.Платформа
	,VendParmCTE.[Тип контрагента]
	,VendParmCTE.ACOUNTNUM
	,VendParmCTE.id
	,'-->>VendInvoice' AS Накладная
	,VendInvoiceJourCTE.INVOICEACCOUNT
	,VendInvoiceJourCTE.RCONTRACTCODE
	,VendInvoiceJourCTE.RCONTRACTSUBJECTID
	,VendInvoiceJourCTE.RCONTRACTSUBJECTBRIEF
	,'-->>шапка' AS Разделитель
	,EDIPackageCTE.CustVendAC AS 'Код Поставщика'
	,EDIPackageCTE.DATAAREAID
	,EDIPackageCTE.Направление
--	,EDIPackageCTE.TRANSREFID
	,EDIPackageCTE.DOCUMENTNUM
	,EDIPackageCTE.DOCUMENTDATE
	,EDIPackageCTE.Статус
	,EDIPackageCTE.Разделитель
	,EDIPackageCTE.INVOICENUM
	,EDIPackageCTE.FACTURENUM
	,EDIPackageCTE.Total_DOC
	,EDIPackageCTE.Invoice_SUM
	,EDIPackageCTE.SF_SUM
	,EDIPackageCTE.Protocol_SUM
	,EDIPackageCTE.Letter_SUM
	,EDIPackageCTE.Zero_SUM
	,EDIPackageCTE.Diferent_SUM
FROM VendParmCTE
RIGHT JOIN EDIPackageCTE
	ON VendParmCTE.ACOUNTNUM = EDIPackageCTE.CUSTVENDAC
		AND VendParmCTE.DATAAREAID = EDIPackageCTE.DATAAREAID
RIGHT JOIN VendInvoiceJourCTE
	ON VendInvoiceJourCTE.INVOICEID = EDIPackageCTE.DOCUMENTNUM
		AND VendInvoiceJourCTE.InvoiceDate = EDIPackageCTE.DOCUMENTDATE
		AND VendInvoiceJourCTE.DATAAREAID = EDIPackageCTE.DATAAREAID
WHERE --VendParmCTE.DATAAREAID IS NOT NULL
--	AND 
	EDIPackageCTE.SF_SUM = 1
	AND EDIPackageCTE.Статус = 'Утверждено'
	AND VendInvoiceJourCTE.INVOICEACCOUNT IN ('П000983','П005577','П006889')
--	AND	EDIPackageCTE.DOCUMENTNUM IN ('ЦБ-4244','00012539')
ORDER BY 8 -- сортировка по дате документа 17
--SELECT * FROM EDIPackage WHERE DocumentNum = '8506738085'

--SELECT * FROM SQLDICTIONARY WHERE TABLEID = 50351
--SELECT * FROM MDLPMESSAGETABLE WHERE RECID = 5639182887
