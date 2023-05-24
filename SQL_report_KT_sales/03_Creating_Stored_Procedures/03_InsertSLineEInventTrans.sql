USE [W_test]
GO

/****** Object:  StoredProcedure [dbo].[03_InsertSLineEInventTrans]    Script Date: 24.05.2023 11:42:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[03_InsertSLineEInventTrans]
AS
	TRUNCATE TABLE bSALESLINE;
	TRUNCATE TABLE bINVENTTRANS;
--	TRUNCATE TABLE bINVENTDIM;
--	TRUNCATE TABLE bINVENTBATCH;
--	TRUNCATE TABLE bCUSTINVOICETRANSPURCHREAL31176

	DECLARE @LastrecidSALESLINE BIGINT = 0
			,@LastrecidTrans BIGINT = 0
			,@LastrecidI BIGINT = 0
			,@LastrecidBATCH BIGINT = 0
--			,@LastrecidBReal BIGINT = 0;
	
	SET NOCOUNT ON;
	SELECT @LastrecidSALESLINE	= ISNULL(MAX(RECID), 0) FROM bSALESLINE
	SELECT @LastrecidTrans		= ISNULL(MAX(RECID), 0) FROM bINVENTTRANS
	SELECT @LastrecidI			= ISNULL(MAX(RECID), 0)	FROM bINVENTDIM
	SELECT @LastrecidBATCH		= ISNULL(MAX(RECID), 0)	FROM bINVENTDIM
--	SELECT @LastrecidBReal		= ISNULL(MAX(RECID), 0)	FROM bCUSTINVOICETRANSPURCHREAL31176
------------------------------ строки заказа
/*
INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bSALESLINE]

SELECT DISTINCT SALESLN.*
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[SALESLINE] AS SALESLN
JOIN bTENDERLINE ON bTENDERLINE.LINENUM = SALESLN.TENDERLINENUM
	AND SALESLN.ITEMID = bTENDERLINE.ITEMID
	AND SALESLN.CREATEDDATETIME > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
--	AND SALESLN.DATAAREAID = 'sz'
	AND SALESLN.RECID > @LastrecidSALESLINE
*/

INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bSALESLINE]
	(
		createdBy,
		createdDateTime,
		dataAreaId,
		InventDimId,
		InventTransId,
		ItemId,
		LineAmount,
		LineNum,
		modifiedBy,
		modifiedDateTime,
		Name,
		recVersion,
		RecId,
		SalesId,
		SalesPrice,
		SalesQty,
		SalesStatus,
		SalesType,
		SalesUnit,
		SZ_SalesPriceTransfer,
		TenderLineNum
	)

SELECT DISTINCT 
	SALESLN.createdBy,
	SALESLN.createdDateTime,
	SALESLN.dataAreaId,
	SALESLN.InventDimId,
	SALESLN.InventTransId,
	SALESLN.ItemId,
	SALESLN.LineAmount,
	SALESLN.LineNum,
	SALESLN.modifiedBy,
	SALESLN.modifiedDateTime,
	SALESLN.Name,
	SALESLN.recVersion,
	SALESLN.RecId,
	SALESLN.SalesId,
	SALESLN.SalesPrice,
	SALESLN.SalesQty,
	SALESLN.SalesStatus,
	SALESLN.SalesType,
	SALESLN.SalesUnit,
	SALESLN.SZ_SalesPriceTransfer,
	SALESLN.TenderLineNum
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[SALESLINE] AS SALESLN
JOIN bTENDERLINE ON bTENDERLINE.LINENUM = SALESLN.TENDERLINENUM
	AND SALESLN.ITEMID = bTENDERLINE.ITEMID
	AND SALESLN.CREATEDDATETIME > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
--	AND SALESLN.DATAAREAID IN ('mof','mr','nv','nwf','OFA','SC','sz')
	AND SALESLN.DATAAREAID IN ('SZ')
	AND SALESLN.RECID > @LastrecidSALESLINE


------------------------------ проводки
/*
INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTTRANS]
SELECT DISTINCT TR.*
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTTRANS] AS TR
JOIN bSALESLINE ON bSALESLINE.INVENTTRANSID = TR.INVENTTRANSID
	AND TR.DATAAREAID	= bSALESLINE.DATAAREAID
	AND TR.TransRefId	= bSALESLINE.SALESID
	AND TR.ITEMID		= bSALESLINE.ITEMID
	AND TR.TransType	= 0
	AND TR.CREATEDDATETIME > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
	AND TR.RECID > @LastrecidTrans
*/
INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTTRANS]
	(
		CREATEDBY,
		CREATEDDATETIME,
		DATAAREAID,
		DATESTATUS,
		INVENTDIMID,
		INVENTTRANSID,
		INVOICEID,
		ITEMID,
		MODIFIEDBY,
		MODIFIEDDATETIME,
		QTY,
		RECID,
		RECVERSION,
		STATUSISSUE,
		STATUSRECEIPT,
		STORNO_RU,
		TRANSREFID,
		TRANSTYPE,
		VOUCHER
	)
SELECT DISTINCT 
	TR.CREATEDBY,
	TR.CREATEDDATETIME,
	TR.DATAAREAID,
	TR.DATESTATUS,
	TR.INVENTDIMID,
	TR.INVENTTRANSID,
	TR.INVOICEID,
	TR.ITEMID,
	TR.MODIFIEDBY,
	TR.MODIFIEDDATETIME,
	TR.QTY,
	TR.RECID,
	TR.RECVERSION,
	TR.STATUSISSUE,
	TR.STATUSRECEIPT,
	TR.STORNO_RU,
	TR.TRANSREFID,
	TR.TRANSTYPE,
	TR.VOUCHER
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTTRANS] AS TR
JOIN bSALESLINE ON bSALESLINE.INVENTTRANSID = TR.INVENTTRANSID
	AND TR.DATAAREAID	= bSALESLINE.DATAAREAID
	AND TR.TransRefId	= bSALESLINE.SALESID
	AND TR.ITEMID		= bSALESLINE.ITEMID
	AND TR.TransType	= 0
	AND TR.CREATEDDATETIME > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
	AND TR.RECID > @LastrecidTrans


------------------------------ складские аналитики
	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTDIM]
		SELECT DISTINCT
			i.*
		FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTDIM] i 
		JOIN bINVENTTRANS ITR ON i.INVENTDIMID = ITR.INVENTDIMID
			AND ITR.CREATEDDATETIME > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
			AND i.DATAAREAID = 'vir'
			AND i.RECID > @LastrecidI

-------------------------------- партии
/*
	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTBATCH] 
		SELECT 
			b.*
		FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTBATCH] b
		WHERE b.DATAAREAID IN ('sz')
			AND b.arrivalDate > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
			AND b.SZ_VendAccount <> ''
			AND b.RECID > @LastrecidBATCH
*/

	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTBATCH]
		(
		arrivalDate,
		BarCodeString,
		createdBy,
		createdDateTime,
		dataAreaId,
		expDate,
		inventBatchId,
		itemId,
		modifiedBy,
		modifiedDateTime,
		PackNormQty,
		prodDate,
		Producer,
		RecId,
		recVersion,
		SZ_VendAccount
		)
	 
		SELECT
			b.arrivalDate,
			b.BarCodeString,
			b.createdBy,
			b.createdDateTime,
			b.dataAreaId,
			b.expDate,
			b.inventBatchId,
			b.itemId,
			b.modifiedBy,
			b.modifiedDateTime,
			b.PackNormQty,
			b.prodDate,
			b.Producer,
			b.RecId,
			b.recVersion,
			b.SZ_VendAccount
		FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTBATCH] b
		WHERE b.DATAAREAID IN ('sz')
			AND b.arrivalDate > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1)
			AND b.SZ_VendAccount <> ''
			AND b.RECID > @LastrecidBATCH


------------------------------- РВЦ прихода
/*
	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bCUSTINVOICETRANSPURCHREAL31176] 
		SELECT DISTINCT
			bReal.*
		FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[CUSTINVOICETRANSPURCHREAL31176] bReal
		JOIN bInventTrans ON bInventTrans.TransRefId = bReal.TransRefId
			AND bInventTrans.INVENTDIMID		= bReal.INVENTDIMID
			AND bInventTrans.ITEMID			= bReal.ITEMID
			AND bInventTrans.INVENTTRANSID	= bReal.INVENTTRANSID
			AND bInventTrans.DATAAREAID		= bReal.DATAAREAID
			AND bInventTrans.TransType		= bReal.TransType		
*/
------------------------------- запись в лог
		INSERT INTO dbo.Logs (ProcedureName, ExecutionDateTime)
		VALUES ('Проводки_строки_заказа_партии_рвц', GETDATE());














GO


