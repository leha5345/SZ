


DECLARE @DATAAREAID nvarchar(4);
  SET @DATAAREAID = 'SZ';

select UserInfo.networkAlias as AD
	,UserInfo.id			--код пользователя
	,UserInfo.NETWORKDOMAIN
	,UserInfo.NAME
--	,UserInfo.ENABLE		--вкл \ выкл

	,UserInfo.SID			-- наличие в AD
	,SysCompanyUserInfo.EmplId as Сотрудник-- связь с сотрудником
	,EmplTable.DATAAREAID
	,EmplTable.CREATEDDATETIME
	,EmplTable.EMPLID
	,EmplTable.PARTYID
	,EmplTable.TradeRepresentative -- галка торговый представитель
	,EmplTable.EmplIdDirector		-- руководитель
	,EmplTable.DepartmentId		-- виртуальный отдел
	,EmplTable.[6]		-- на форме надо проставить ЦФО
	,EmplTable.DIMENSION6_ 
from USERINFO
LEFT JOIN (	select USERID,EMPLID,PARTYID,DATAAREAID 
		FROM SysCompanyUserInfo
--		WHERE DATAAREAID = @DATAAREAID
		) as SysCompanyUserInfo ON USERINFO.ID = SysCompanyUserInfo.USERID
LEFT JOIN (	select DATAAREAID
			,CREATEDDATETIME
			,EMPLID
			,PARTYID
			,TradeRepresentative -- галка торговый представитель
			,EmplIdDirector		-- руководитель
			,DepartmentId		-- виртуальный отдел
			,Dimension[6]		-- на форме надо проставить ЦФО
			,DIMENSION6_ 
		FROM EmplTable
--		WHERE DATAAREAID = @DATAAREAID
		) as EmplTable ON SysCompanyUserInfo.EMPLID = EmplTable.EMPLID
WHERE 
	UserInfo.ENABLE=1
	--AND UserInfo.SID <> ''
	--AND (SysCompanyUserInfo.EmplId IS NULL OR SysCompanyUserInfo.EmplId = '')
	AND EmplTable.DATAAREAID = @DATAAREAID


/*
use [DAX2009_1]
UPDATE EmplTable
--SET TradeRepresentative = 1
WHERE EMPLID = 'МининаЕЛ'
*/





