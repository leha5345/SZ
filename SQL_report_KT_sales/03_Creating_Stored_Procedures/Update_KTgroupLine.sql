USE [W_test]
GO

/****** Object:  StoredProcedure [dbo].[Update_KTgroupLine]    Script Date: 24.05.2023 11:43:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[Update_KTgroupLine]
AS
	EXEC dbo.[0_InsertT17T16]				--Предварительные заявки на участие
	EXEC dbo.[01_InsertTender]				--КТ
	EXEC dbo.[02_InsertCustContractInvent]	--Справочники
	EXEC dbo.[03_InsertSLineEInventTrans]	-- Операции

------------ запись в лог
		INSERT INTO dbo.Logs (ProcedureName, ExecutionDateTime)
		VALUES ('Общее_обновление', GETDATE());


GO


