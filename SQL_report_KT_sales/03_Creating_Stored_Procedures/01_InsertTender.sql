USE [W_test]
GO

/****** Object:  StoredProcedure [dbo].[01_InsertTender]    Script Date: 24.05.2023 11:41:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[01_InsertTender]
AS
	TRUNCATE TABLE bTENDERLINE;
	TRUNCATE TABLE bTENDERTABLE;	

	DECLARE @LastrecidTLINE BIGINT = 0
			,@LastrecidTB BIGINT = 0;

	SET NOCOUNT ON;
	SELECT
		@LastrecidTLINE = ISNULL(MAX(RECID), 0)
	FROM bTENDERLINE
	SELECT
		@LastrecidTB = ISNULL(MAX(RECID), 0)
	FROM bTENDERTABLE

----------------------------- вставка строк карточек тендера
/*

	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERLINE]

	SELECT DISTINCT TLINE.*
	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31116] AS T16
	JOIN [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERLINE] AS TLINE ON T16.TenderLineNum = TLINE.LINENUM
		AND TLINE.CREATEDDATETIME > DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1) --N'2021-01-01T00:00:00.000'
		AND TLINE.RECID > @LastrecidTLINE
	--JOIN [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[SALESLINE] s ON TLINE.LINENUM = s.TenderLineNum
	--	AND s.CREATEDDATETIME > N'2022-12-31T00:00:00.000'
*/

	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERLINE]
		(
			Archive,
			ARRIVALPRICE,
			CompanyPosition,
			createdBy,
			createdDateTime,
			dataAreaId,
			ExpireDateInfo,
			InventExpireDate,
			InventInternationalName,
			InventTradeName,
			ItemId,
			ItemAvailablePhysicalQty,
			ItemDosage,
			ItemDosageUnitID,
			ItemFormProduction,
			ItemManufacturer,
			ItemOriginCountry,
			ItemPacking,
			ItemPackingUnitID,
			ItemRecalculatedQty,
			LineItemRefRecId,
			LineNum,
			LineNumInt,
			modifiedBy,
			modifiedDateTime,
			Name,
			PaymTermId,
			PriceListPrice,
			PurchReqComment,
			RecId,
			REALINPUTPRICE,
			RegisterPrice,
			RequestAccepted,
			RequestCustLineNum,
			RequestParticipateQty,
			RFQDeliveryDate,
			RFQDeliveryQty,
			RLSCountry,
			RLSFirm,
			Selected,
			Source,
			TenderTableId,
			UnitID,
			VendAccount,
			VendProposal,
			Vital
		)


	SELECT DISTINCT 
			TLINE.Archive,
			TLINE.ARRIVALPRICE,
			TLINE.CompanyPosition,
			TLINE.createdBy,
			TLINE.createdDateTime,
			TLINE.dataAreaId,
			TLINE.ExpireDateInfo,
			TLINE.InventExpireDate,
			TLINE.InventInternationalName,
			TLINE.InventTradeName,
			TLINE.ItemId,
			TLINE.ItemAvailablePhysicalQty,
			TLINE.ItemDosage,
			TLINE.ItemDosageUnitID,
			TLINE.ItemFormProduction,
			TLINE.ItemManufacturer,
			TLINE.ItemOriginCountry,
			TLINE.ItemPacking,
			TLINE.ItemPackingUnitID,
			TLINE.ItemRecalculatedQty,
			TLINE.LineItemRefRecId,
			TLINE.LineNum,
			TLINE.LineNumInt,
			TLINE.modifiedBy,
			TLINE.modifiedDateTime,
			TLINE.Name,
			TLINE.PaymTermId,
			TLINE.PriceListPrice,
			TLINE.PurchReqComment,
			TLINE.RecId,
			TLINE.REALINPUTPRICE,
			TLINE.RegisterPrice,
			TLINE.RequestAccepted,
			TLINE.RequestCustLineNum,
			TLINE.RequestParticipateQty,
			TLINE.RFQDeliveryDate,
			TLINE.RFQDeliveryQty,
			TLINE.RLSCountry,
			TLINE.RLSFirm,
			TLINE.Selected,
			TLINE.Source,
			TLINE.TenderTableId,
			TLINE.UnitID,
			TLINE.VendAccount,
			TLINE.VendProposal,
			TLINE.Vital
	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31116] AS T16
	JOIN [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERLINE] AS TLINE ON T16.TenderLineNum = TLINE.LINENUM
		AND TLINE.CREATEDDATETIME > DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 01, 1) --N'2021-01-01T00:00:00.000'
		AND TLINE.RECID > @LastrecidTLINE

----------------------------- вставка КТ
/*
	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERTABLE]
	SELECT DISTINCT TB.*
	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERTABLE] AS TB
	JOIN bTENDERLINE ON bTENDERLINE.TENDERTABLEID = TB.TENDERTABLEID
		AND TB.LOTSTATUS IN (35,37,40)
--		AND TB.DEPARTMENTID = 'Госп'
		AND TB.RECID > @LastrecidTB
--	JOIN [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[SALESTABLE] ST ON TB.TENDERTABLEID = ST.TENDERTABLEID
*/

	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERTABLE]
			(
			Additionalinfo,
			AddressCountryRegionId,
			AddressStateId,
			AnnounceDate,
			AntiDumpingPercent,
			AutoReserv,
			Comments,
			CompanySource,
			ContractDate,
			ContractStartPrice,
			ContractStartPricePartner,
			ContractWinAmount,
			createdBy,
			createdDateTime,
			CustAccount,
			CustAccountConsignee,
			CustAccountConsigneeName,
			CustAccountName,
			CustAccountPartner,
			CustAmount,
			CustRequestShelfLife,
			dataAreaId,
			DeliveryDateApproximate,
			DeliveryDateDocumentation,
			DeliveryDateDocumentationStr,
			DepartmentId,
			DIMENSION,
			DIMENSION2_,
			DIMENSION3_,
			DIMENSION4_,
			DIMENSION5_,
			DIMENSION6_,
			DocumentManagementType,
			ExternalPartner,
			FDPEndDate,
			FDPStartDate,
			FinanceSourceId,
			FirstPlaceCompetitorId,
			GovContractID,
			HiddenContract,
			InventLocationIdReceiver,
			InventLocationIdSource,
			JointAuction,
			LatestContractDate,
			LotStatus,
			LotWinAmountWithPreference,
			Margin,
			modifiedBy,
			modifiedDateTime,
			OriginatorId,
			PartnerNeed,
			PaymTermId,
			ProposalDate,
			PublishingSchemeId,
			RContractAccountPartner,
			RecId,
			recVersion,
			RequestDateTimeEnd,
			ResponsibleManagerId,
			SubjectSmallBusiness,
			SZ_CustAccount,
			SZ_CustAccountName,
			SZ_RContractAccount,
			SZ_SalesChannel,
			TenderContractExecutionSitesId,
			TenderExecutionControlShip,
			TenderName,
			TenderPurchaseTypeId,
			TenderRequestCustId,
			TenderTableId,
			TenderTradingCodeInExecSites,
			TenderTypeId,
			TPRContractAccount,
			TPVendAccountId,
			TradeDateTime,
			TradeLink,
			TradePlatformId,
			TradeType,
			TradingCode
			)
	SELECT DISTINCT 
			TB.Additionalinfo,
			TB.AddressCountryRegionId,
			TB.AddressStateId,
			TB.AnnounceDate,
			TB.AntiDumpingPercent,
			TB.AutoReserv,
			TB.Comments,
			TB.CompanySource,
			TB.ContractDate,
			TB.ContractStartPrice,
			TB.ContractStartPricePartner,
			TB.ContractWinAmount,
			TB.createdBy,
			TB.createdDateTime,
			TB.CustAccount,
			TB.CustAccountConsignee,
			TB.CustAccountConsigneeName,
			TB.CustAccountName,
			TB.CustAccountPartner,
			TB.CustAmount,
			TB.CustRequestShelfLife,
			TB.dataAreaId,
			TB.DeliveryDateApproximate,
			TB.DeliveryDateDocumentation,
			TB.DeliveryDateDocumentationStr,
			TB.DepartmentId,
			TB.DIMENSION,
			TB.DIMENSION2_,
			TB.DIMENSION3_,
			TB.DIMENSION4_,
			TB.DIMENSION5_,
			TB.DIMENSION6_,
			TB.DocumentManagementType,
			TB.ExternalPartner,
			TB.FDPEndDate,
			TB.FDPStartDate,
			TB.FinanceSourceId,
			TB.FirstPlaceCompetitorId,
			TB.GovContractID,
			TB.HiddenContract,
			TB.InventLocationIdReceiver,
			TB.InventLocationIdSource,
			TB.JointAuction,
			TB.LatestContractDate,
			TB.LotStatus,
			TB.LotWinAmountWithPreference,
			TB.Margin,
			TB.modifiedBy,
			TB.modifiedDateTime,
			TB.OriginatorId,
			TB.PartnerNeed,
			TB.PaymTermId,
			TB.ProposalDate,
			TB.PublishingSchemeId,
			TB.RContractAccountPartner,
			TB.RecId,
			TB.recVersion,
			TB.RequestDateTimeEnd,
			TB.ResponsibleManagerId,
			TB.SubjectSmallBusiness,
			TB.SZ_CustAccount,
			TB.SZ_CustAccountName,
			TB.SZ_RContractAccount,
			TB.SZ_SalesChannel,
			TB.TenderContractExecutionSitesId,
			TB.TenderExecutionControlShip,
			TB.TenderName,
			TB.TenderPurchaseTypeId,
			TB.TenderRequestCustId,
			TB.TenderTableId,
			TB.TenderTradingCodeInExecSites,
			TB.TenderTypeId,
			TB.TPRContractAccount,
			TB.TPVendAccountId,
			TB.TradeDateTime,
			TB.TradeLink,
			TB.TradePlatformId,
			TB.TradeType,
			TB.TradingCode

	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERTABLE] AS TB
	JOIN bTENDERLINE ON bTENDERLINE.TENDERTABLEID = TB.TENDERTABLEID
		AND TB.LOTSTATUS IN (35,37,40)
		AND TB.RECID > @LastrecidTB
-----------------------------

		INSERT INTO dbo.Logs (ProcedureName, ExecutionDateTime)
		VALUES ('Карточки_тендера', GETDATE());









GO


