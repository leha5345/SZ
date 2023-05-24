USE [W_test]
GO

/****** Object:  StoredProcedure [dbo].[0_InsertT17T16]    Script Date: 24.05.2023 11:39:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[0_InsertT17T16] 
AS
	TRUNCATE TABLE bTENDERPREREQUESTPARTICIPA31117;
	TRUNCATE TABLE bTENDERPREREQUESTPARTICIPA31116;

	DECLARE @Lastrecid17 BIGINT = 0
		   ,@Lastrecid16 BIGINT = 0;

	SET NOCOUNT ON;
	SELECT
		@Lastrecid17 = ISNULL(MAX(RECID), 0)
	FROM bTENDERPREREQUESTPARTICIPA31117;
	SELECT
		@Lastrecid16 = ISNULL(MAX(RECID), 0)
	FROM bTENDERPREREQUESTPARTICIPA31116;

	-------------------------------вставка шапки предварительных заявок -----------------------
	--INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERPREREQUESTPARTICIPA31117]

	--	SELECT
	--		*
	--	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31117] AS T
	--	WHERE T.ACTIVEVERSION = 1
	--	AND T.RECID > @Lastrecid17;


	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERPREREQUESTPARTICIPA31117] (
		ActiveVersion,
		CustAccount,
		createdBy,
		createdDateTime,
		dataAreaId,
		modifiedBy,
		modifiedDateTime,
		PreRequestParticipateTableId,
		recVersion,
		RecId,
		Status,
		TenderRequestCustId,
		TenderTableId,
		Version

	)
	SELECT 
		T.ActiveVersion,
		T.CustAccount,
		T.createdBy,
		T.createdDateTime,
		T.dataAreaId,
		T.modifiedBy,
		T.modifiedDateTime,
		T.PreRequestParticipateTableId,
		T.recVersion,
		T.RecId,
		T.Status,
		T.TenderRequestCustId,
		T.TenderTableId,
		T.Version
	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31117] AS T
	WHERE T.ACTIVEVERSION = 1
	AND T.RECID > @Lastrecid17;

	-------------------------------вставка строк предварительных заявок -----------------------
	--INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERPREREQUESTPARTICIPA31116]

	--	SELECT
	--		T16.*
	--	FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31117] AS T17
	--	JOIN [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31116] AS T16
	--		ON T17.VERSION = T16.VERSION
	--			AND T17.PREREQUESTPARTICIPATETABLEID = T16.PREREQUESTPARTICIPATETABLEID
	--			AND T17.ACTIVEVERSION = 1
	--			AND T16.RECID > @Lastrecid16;

	INSERT INTO [SPB-SQL1202].[W_test].[dbo].[bTENDERPREREQUESTPARTICIPA31116] (
		ContractPrice,
		createdBy,
		createdDateTime,
		dataAreaId,
		Fix,
		GovContractPrice,
		modifiedBy,
		modifiedDateTime,
		PartnerPrice,
		PreRequestParticipateTableId,
		recVersion,
		RecId,
		RequestParticipateQty,
		TenderLineNum,
		Version
	)

		SELECT
			T16.ContractPrice,
			T16.createdBy,
			T16.createdDateTime,
			T16.dataAreaId,
			T16.Fix,
			T16.GovContractPrice,
			T16.modifiedBy,
			T16.modifiedDateTime,
			T16.PartnerPrice,
			T16.PreRequestParticipateTableId,
			T16.recVersion,
			T16.RecId,
			T16.RequestParticipateQty,
			T16.TenderLineNum,
			T16.Version
		FROM [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31117] AS T17
		JOIN [SPB-SQLDAXDBE].[DAX2009_1].[dbo].[TENDERPREREQUESTPARTICIPA31116] AS T16
			ON T17.VERSION = T16.VERSION
				AND T17.PREREQUESTPARTICIPATETABLEID = T16.PREREQUESTPARTICIPATETABLEID
				AND T17.ACTIVEVERSION = 1
				AND T16.RECID > @Lastrecid16;


---------------------------------- запись в лог---------------------
		INSERT INTO dbo.Logs (ProcedureName, ExecutionDateTime)
		VALUES ('Предварительные_заявки', GETDATE());



GO


