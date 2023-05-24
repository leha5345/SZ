
/*
CREATE LOGIN [TestUser] WITH PASSWORD=N'TestPassword', DEFAULT_DATABASE=[TestDB], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [TestDB]
GO

CREATE USER [TestUser] FOR LOGIN [TestUser] WITH DEFAULT_SCHEMA=[dbo]
GO

Этот запрос создаст нового пользователя TestUser с паролем TestPassword и назначит ему роль db_owner в базе данных TestDB.
*/

USE [DAX2009_1]
GO

CREATE LOGIN [Sv] WITH PASSWORD=N'qwerty123', DEFAULT_DATABASE=[DAX2009_1], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [DAX2009_1]
GO

--Создайте нового пользователя в базе данных DAX2009_RP с помощью оператора CREATE USER и укажите, какому логину он соответствует. Например:
USE DAX2009_1;
CREATE USER [Sv] FOR LOGIN [Sv];

--Назначьте пользователю роль db_datareader с помощью оператора sp_addrolemember. Например:
--EXEC sp_addrolemember 'db_datareader', 'TestUser';
--только на представление: USE DAX2009_RP; GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ab_KT_Fact TO TestUser;
USE DAX2009_1;
GRANT SELECT ON dbo.TENDERPREREQUESTPARTICIPA31117 TO Sv;
GRANT SELECT ON dbo.TENDERPREREQUESTPARTICIPA31116 TO Sv;
GRANT SELECT ON dbo.TENDERLINE						TO Sv;
GRANT SELECT ON dbo.TENDERTABLE						TO Sv;
GRANT SELECT ON dbo.INVENTTABLE						TO Sv;
GRANT SELECT ON dbo.CUSTTABLE						TO Sv;
GRANT SELECT ON dbo.RContractTable					TO Sv;
GRANT SELECT ON dbo.SALESLINE						TO Sv;
GRANT SELECT ON dbo.INVENTTRANS						TO Sv;
GRANT SELECT ON dbo.INVENTBATCH						TO Sv;
GRANT SELECT ON dbo.CUSTINVOICETRANSPURCHREAL31176	TO Sv;
GRANT SELECT ON dbo.INVENTDIM	TO Sv;

-- все SQL пользователи сервера
SELECT name FROM sys.sql_logins WHERE is_disabled = 0 	AND NAme = 'Sv'


--Убедитесь, что пользователь успешно добавлен в базу данных и имеет права доступа к необходимым таблицам. 
--Например, с помощью следующего запроса можно проверить, какие таблицы доступны пользователю:

SELECT * FROM sys.tables WHERE is_ms_shipped = 0 AND OBJECTPROPERTY(object_id, 'IsMSShipped') = 0;





-- пользователи в базе данных
SELECT name, type_desc
FROM sys.database_principals
WHERE type IN ('S', 'U', 'G')


--Посмотреть права

USE [W_test];
GO
SELECT 
    princ.name AS [User],
    princ.type_desc AS [User Type],
    CASE
        WHEN perm.state_desc = 'GRANT_WITH_GRANT_OPTION' THEN 'GRANT, WITH GRANT OPTION'
        ELSE perm.permission_name
    END AS [Permission],
    CASE
        WHEN perm.class = 1 THEN obj.name -- Схемы
        WHEN perm.class = 3 THEN col.name -- Столбцы
        ELSE OBJECT_NAME(perm.major_id)
    END AS [Object]
FROM 
    sys.database_principals princ
LEFT JOIN 
    sys.database_permissions perm ON perm.grantee_principal_id = princ.principal_id
LEFT JOIN
    sys.objects obj ON obj.object_id = perm.major_id AND perm.class = 1
LEFT JOIN
    sys.columns col ON col.column_id = perm.major_id AND perm.class = 3
WHERE 
    princ.type_desc = 'SQL_USER' -- Фильтр по типу учетной записи, например, SQL_USER, WINDOWS_USER, WINDOWS_GROUP и т.д.
    AND princ.name = 'Sv'; 

