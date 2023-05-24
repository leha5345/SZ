USE [W_test]
GO

/****** Object:  StoredProcedure [dbo].[02_InsertCustContractInvent]    Script Date: 24.05.2023 11:41:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE PROCEDURE [dbo].[02_InsertCustContractInvent]
AS
	TRUNCATE TABLE bRContractTable;
	TRUNCATE TABLE bINVENTTABLE;

	DECLARE @LastrecidINV BIGINT = 0
			,@LastrecidCUSTTABLE BIGINT = 0
			,@LastrecidContract BIGINT = 0;

	SET NOCOUNT ON;
	SELECT
		@LastrecidINV = ISNULL(MAX(RECID), 0)
	FROM bINVENTTABLE
	SELECT
		@LastrecidCUSTTABLE = ISNULL(MAX(RECID), 0)
	FROM bCUSTTABLE
	SELECT
		@LastrecidContract = ISNULL(MAX(RECID), 0)
	FROM bRContractTable

----------------------------- вставка справочника номенклатур
/*
INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTTABLE]

SELECT DISTINCT INV.*
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTTABLE] AS INV
JOIN bTENDERLINE ON bTENDERLINE.ITEMID = INV.ITEMID
	AND INV.ClassGroupId = '001'
	AND INV.RECID > @LastrecidINV
*/

INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bINVENTTABLE]
	(
		ATH,
		CodeA,
		CountryProdVendName,
		createdBy,
		createdDateTime,
		dataAreaId,
		Depth,
		DimGroupId,
		FreightClass,
		ItemGroupId,
		ItemId,
		ItemIdUnion,
		ItemName,
		ItemType,
		MacroGroupProducer,
		modifiedBy,
		modifiedDateTime,
		NameAlias,
		NetWeight,
		OrigCountryRegionId,
		PackNormQty,
		PrimaryVendorId,
		ProdVendName,
		RecId,
		RlsId,
		storagePeriod,
		Strong,
		SZ_Active,
		TenderInventInternationalName,
		TenderInventTradeName,
		UnitVolume
	)

SELECT DISTINCT 
	INV.ATH,
	INV.CodeA,
	INV.CountryProdVendName,
	INV.createdBy,
	INV.createdDateTime,
	INV.dataAreaId,
	INV.Depth,
	INV.DimGroupId,
	INV.FreightClass,
	INV.ItemGroupId,
	INV.ItemId,
	INV.ItemIdUnion,
	INV.ItemName,
	INV.ItemType,
	INV.MacroGroupProducer,
	INV.modifiedBy,
	INV.modifiedDateTime,
	INV.NameAlias,
	INV.NetWeight,
	INV.OrigCountryRegionId,
	INV.PackNormQty,
	INV.PrimaryVendorId,
	INV.ProdVendName,
	INV.RecId,
	INV.RlsId,
	INV.storagePeriod,
	INV.Strong,
	INV.SZ_Active,
	INV.TenderInventInternationalName,
	INV.TenderInventTradeName,
	INV.UnitVolume
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[INVENTTABLE] AS INV
JOIN bTENDERLINE ON bTENDERLINE.ITEMID = INV.ITEMID
	AND INV.ClassGroupId = '001'
	AND INV.RECID > @LastrecidINV
		
------------------------------Клиенты-----------
/*
INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bCUSTTABLE]

SELECT DISTINCT Cust.*
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[CUSTTABLE] AS Cust
JOIN bTenderTable ON bTenderTable.CustAccount = Cust.ACCOUNTNUM
	AND Cust.RECID > @LastrecidCUSTTABLE
*/

INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bCUSTTABLE]
	(
		AccountNum,
		CustGroup,
		createdBy,
		createdDateTime,
		dataAreaId,
		INN_RU,
		KPP_RU,
		modifiedBy,
		modifiedDateTime,
		MP,
		Name,
		NameAlias,
		PartyId,
		PartyType,
		recVersion,
		RecId,
		SZ_IsFilial
	)

SELECT DISTINCT 
	Cust.AccountNum,
	Cust.Name,
	Cust.CustGroup,
	Cust.NameAlias,
	Cust.PartyType,
	Cust.PartyId,
	Cust.INN_RU,
	Cust.KPP_RU,
	Cust.MP,
	Cust.SZ_IsFilial,
	Cust.modifiedDateTime,
	Cust.modifiedBy,
	Cust.createdDateTime,
	Cust.createdBy,
	Cust.dataAreaId,
	Cust.recVersion,
	Cust.RecId
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[CUSTTABLE] AS Cust
JOIN bTenderTable ON bTenderTable.CustAccount = Cust.ACCOUNTNUM
	AND Cust.RECID > @LastrecidCUSTTABLE
------------------------------ Договора
/*
INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bRContractTable]

SELECT Contr.*
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[RContractTable] AS Contr
JOIN bTENDERTABLE ON bTENDERTABLE.TENDERTABLEID = Contr.TenderTableId
	AND Contr.ContractEndDate    > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 07, 1)
	AND Contr.RECID > @LastrecidContract
*/

INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bRContractTable]
	(
		ContractDate,
		ContractEndDate,
		ContractPartnerName,
		ContractPartnerNameAlias,
		ContractPaymCode,
		ContractResponsiblePerson,
		ContractStartDate,
		createdBy,
		createdDateTime,
		dataAreaId,
		DepartmentId,
		DIMENSION,
		DIMENSION2_,
		DIMENSION3_,
		DIMENSION4_,
		DIMENSION5_,
		DIMENSION6_,
		GovContractID,
		modifiedBy,
		modifiedDateTime,
		PrintDescription,
		RContractAccount,
		RContractClassificationId,
		RContractCode,
		RContractFormCust,
		RContractFormVend,
		RContractNumber,
		RContractPartnerCode,
		RContractPartnerType,
		RContractStatus,
		RContractSubject,
		RContractSubjectBrief,
		RContractSubjectId,
		RecId,
		recVersion,
		RegistryEntryNumber,
		StatusCode,
		TenderTableID
)
SELECT 
	Contr.ContractDate,
	Contr.ContractEndDate,
	Contr.ContractPartnerName,
	Contr.ContractPartnerNameAlias,
	Contr.ContractPaymCode,
	Contr.ContractResponsiblePerson,
	Contr.ContractStartDate,
	Contr.createdBy,
	Contr.createdDateTime,
	Contr.dataAreaId,
	Contr.DepartmentId,
	Contr.DIMENSION,
	Contr.DIMENSION2_,
	Contr.DIMENSION3_,
	Contr.DIMENSION4_,
	Contr.DIMENSION5_,
	Contr.DIMENSION6_,
	Contr.GovContractID,
	Contr.modifiedBy,
	Contr.modifiedDateTime,
	Contr.PrintDescription,
	Contr.RContractAccount,
	Contr.RContractClassificationId,
	Contr.RContractCode,
	Contr.RContractFormCust,
	Contr.RContractFormVend,
	Contr.RContractNumber,
	Contr.RContractPartnerCode,
	Contr.RContractPartnerType,
	Contr.RContractStatus,
	Contr.RContractSubject,
	Contr.RContractSubjectBrief,
	Contr.RContractSubjectId,
	Contr.RecId,
	Contr.recVersion,
	Contr.RegistryEntryNumber,
	Contr.StatusCode,
	Contr.TenderTableID
FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[RContractTable] AS Contr
JOIN bTENDERTABLE ON bTENDERTABLE.TENDERTABLEID = Contr.TenderTableId
	AND Contr.ContractEndDate    > = DATEFROMPARTS(YEAR(DATEADD(YEAR, -1, GETDATE())), 07, 1)
	AND Contr.RECID > @LastrecidContract
-------------------------Запись в лог
		INSERT INTO dbo.Logs (ProcedureName, ExecutionDateTime)
		VALUES ('Клиенты_договора', GETDATE());










GO


