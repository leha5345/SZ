USE [W_test]
GO

/****** Object:  View [dbo].[Logs_view]    Script Date: 24.05.2023 11:37:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[Logs_view]
as

SELECT TOP 5 
    ProcedureName AS Процедура,
    MAX(ExecutionDateTime) as Время_обновления
FROM Logs
GROUP BY ProcedureName
ORDER BY 
    CASE ProcedureName 
        WHEN 'Предварительные_заявки' THEN 1 
        WHEN 'Карточки_тендера' THEN 2 
        WHEN 'Клиенты_договора' THEN 3 
        WHEN 'Проводки_строки_заказа_партии_рвц' THEN 4 
        WHEN 'Общее_обновление' THEN 5 
    END

GO


