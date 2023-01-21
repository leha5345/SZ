---Cоздание моментального снимка базы DAX2009_RP
/*
CREATE DATABASE DAX2009_RP_001 ON
( NAME = DAX2009_RP , FILENAME = 'C:\SQL\0\DAX2009_RP_001.ss' ) -- Указывать на SQL сервере займет 457Гб свободного места (правда непонятно как создается так как при создании было всего 80Гб)

AS SNAPSHOT OF DAX2009_RP;
GO
--Удаление снимка БД 
USE master
GO
IF DB_ID (N'DAX2009_RP_001') IS NOT NULL
	DROP DATABASE DAX2009_RP_001;
GO



-- Создание базы
CREATE DATABASE W_test;
GO

--Удаление базы
USE master
GO
IF DB_ID (N'W_test_001') IS NOT NULL
	DROP DATABASE W_test_001;
GO

EXEC sp_help CUSTTABLE



---9 Создание синонима
use [W_test]
GO
CREATE SYNONYM TenderTable FOR DAX2009_RP.dbo.TenderTable;

use [W_test];
select * from TenderTable;
*/