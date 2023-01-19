/*
SELECT		TABLE_NAME AS [Имя таблицы],
			COLUMN_NAME AS [Имя столбца],
			DATA_TYPE AS [Тип данных столбца],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='TenderTable'
order by 2
*/


DECLARE @CREATEDDATETIME DATETIME, @DATAAREAID nvarchar(4);
	SET @CREATEDDATETIME = '2021-12-31T00:00:00.000';
	SET @DATAAREAID = 'SZ';

select DISTINCT
	KT.Ответственный_менеджер
	,KT.Код_клиента
	,KT.Имя_клиента
	,KT.Код_КТ
	,KT.Статус
	,KT.Номер_закупа
	,KT.Код_строки_КТ
	,KT.Код_товара
	,KT.Производитель
	,KT.MNN
	,KT.Торговое_наименование
	,CAST(KT.ARRIVALPRICE AS NUMERIC(20,2)) as Цена_прихода
	,CAST(KT.REALINPUTPRICE AS NUMERIC(20,2)) as РВЦ
	,KT.Кол_во_в_предв_заявке
	,CAST(KT.SUM_LINE AS NUMERIC(20,0)) as Продано
	,CAST(KT.Кол_во_в_предв_заявке - KT.SUM_LINE AS NUMERIC(20,0)) as Позаявке_минус_Продано
	,KT.Статус_заказа

--	,InventBatch.SZ_VendAccount as Код_поставщика
--	,VENDTABLE.NAMEALIAS as Имя_поставщика

from (
select DISTINCT TenderTable.ResponsibleManagerId as Ответственный_менеджер
--	TENDERPREREQUESTPARTICIPA31117.PREREQUESTPARTICIPATETABLEID
--	,TENDERPREREQUESTPARTICIPA31117.VERSION
	,CUSTTABLE.ACCOUNTNUM as Код_клиента
	,CUSTTABLE.NAMEALIAS as Имя_клиента
	,TENDERPREREQUESTPARTICIPA31117.TENDERTABLEID as Код_КТ
	,CASE
		WHEN TENDERTABLE.LOTSTATUS = 0 THEN 'Создан'
		WHEN TENDERTABLE.LOTSTATUS = 10 THEN 'Отклонен'
		WHEN TENDERTABLE.LOTSTATUS = 15 THEN 'Подана заявка'
		WHEN TENDERTABLE.LOTSTATUS = 20 THEN 'Проигран'
		WHEN TENDERTABLE.LOTSTATUS = 25 THEN 'Выигран'
		WHEN TENDERTABLE.LOTSTATUS = 26 THEN 'Протокол разногласий'
		WHEN TENDERTABLE.LOTSTATUS = 30 THEN 'Подписан'
		WHEN TENDERTABLE.LOTSTATUS = 35 THEN 'Заключен контракт'
		WHEN TENDERTABLE.LOTSTATUS = 37 THEN 'Исполнение'
		WHEN TENDERTABLE.LOTSTATUS = 40 THEN 'Все отгружено'
		WHEN TENDERTABLE.LOTSTATUS = 45 THEN 'Закрыто'
		WHEN TENDERTABLE.LOTSTATUS = 50 THEN 'Претензия'
	 END as Статус
	,TenderTable.TRADINGCODE as Номер_закупа
	,TENDERPREREQUESTPARTICIPA31116.TenderLineNum as Код_строки_КТ
	,InventTable.ProdVendName as Производитель 
--	,InventBatch.arrivalDate as Дата_прихода	



	,TENDERLINE.ITEMID	as Код_товара
	,InventTable.TenderInventInternationalName as MNN
	,InventTable.TenderInventTradeName as Торговое_наименование
	,TenderLine.ArrivalPrice
	,TenderLine.RealInputPrice
	,CAST(TENDERPREREQUESTPARTICIPA31116.REQUESTPARTICIPATEQTY AS bigint) as Кол_во_в_предв_заявке
--	,CAST(SalesLine.SalesQty AS bigint)  as Кол_во_Продано
	,SUM(SalesLine.SalesQty) OVER (PARTITION BY TENDERPREREQUESTPARTICIPA31117.TENDERTABLEID,TENDERPREREQUESTPARTICIPA31116.TenderLineNum) as SUM_LINE
	,CASE
		WHEN SalesTable.SalesStatusEx = 0 THEN 'Частичный резерв'
		WHEN SalesTable.SalesStatusEx = 1 THEN 'Резерв'
		WHEN SalesTable.SalesStatusEx = 2 THEN 'Сборка'
		WHEN SalesTable.SalesStatusEx = 3 THEN 'Собрано'
		WHEN SalesTable.SalesStatusEx = 4 THEN 'Отгружено'
		--WHEN SalesTable.SalesStatusEx = 0 THEN '0'
		--WHEN SalesTable.SalesStatusEx = 0 THEN '0'
	 END as Статус_заказа

from TENDERPREREQUESTPARTICIPA31117	
JOIN TENDERPREREQUESTPARTICIPA31116 ON TENDERPREREQUESTPARTICIPA31117.VERSION = TENDERPREREQUESTPARTICIPA31116.VERSION
	AND TENDERPREREQUESTPARTICIPA31117.PREREQUESTPARTICIPATETABLEID = TENDERPREREQUESTPARTICIPA31116.PREREQUESTPARTICIPATETABLEID
	AND TENDERPREREQUESTPARTICIPA31117.ActiveVersion = 1
JOIN TENDERLINE ON TENDERPREREQUESTPARTICIPA31116.TenderLineNum = TENDERLINE.LINENUM
	AND TENDERLINE.CREATEDDATETIME > @CREATEDDATETIME
JOIN TENDERTABLE ON TENDERLINE.TENDERTABLEID = TENDERTABLE.TENDERTABLEID
	AND TENDERTABLE.LOTSTATUS = 37 -- Исполнение
	AND TenderTable.DEPARTMENTID = 'Госп'
JOIN INVENTTABLE ON TENDERLINE.ITEMID = INVENTTABLE.ITEMID
JOIN CUSTTABLE ON TenderTable.CustAccount = CUSTTABLE.ACCOUNTNUM

LEFT JOIN SALESLINE		ON TENDERPREREQUESTPARTICIPA31116.TenderLineNum = SALESLINE.TENDERLINENUM
	AND SALESLINE.DATAAREAID = @DATAAREAID
LEFT JOIN SALESTABLE	ON SALESLINE.SALESID = SALESTABLE.SALESID
	AND SALESTABLE.DATAAREAID = SALESLINE.DATAAREAID
	) KT 

--LEFT JOIN  (
--	select DISTINCT
--		InventBatch.ITEMID
--		,InventBatch.INVENTBATCHID
----		,InventBatch.arrivalDate	
--		,InventBatch.SZ_VendAccount
----		,InventBatch.PackNormQty
--	from InventBatch
--	WHERE InventBatch.DATAAREAID = @DATAAREAID
--		AND InventBatch.SZ_VendAccount <>'НачОст'
--		) as InventBatch ON KT.Код_товара = InventBatch.ITEMID
--LEFT JOIN VENDTABLE ON InventBatch.SZ_VendAccount = VENDTABLE.ACCOUNTNUM

--WHERE KT.Код_КТ = '064894_268'
--	AND KT.Код_строки_КТ = '064894_268_0017'



--LEFT JOIN InventTrans	ON SALESLINE.INVENTTRANSID = InventTrans.INVENTTRANSID
--	AND SALESLINE.DATAAREAID	= InventTrans.DATAAREAID
--	AND SALESLINE.SALESID		= InventTrans.TransRefId
--	AND SALESLINE.ITEMID		= InventTrans.ITEMID
--LEFT JOIN WMSORDERTRANS ON InventTrans.INVENTTRANSID = WMSORDERTRANS.INVENTTRANSID
--	AND InventTrans.TransRefId	= WMSOrderTrans.inventTransRefId
--	AND InventTrans.ITEMID		= WMSOrderTrans.ITEMID
--	AND InventTrans.INVENTDIMID = WMSOrderTrans.INVENTDIMID 
--	AND InventTrans.DATAAREAID	= WMSOrderTrans.DATAAREAID

/* -- ---------- остатки -------------------------------------------------------
LEFT JOIN (
			select DISTINCT INVENTSUM.DATAAREAID
	  ,CONVERT(date,InventBatch.arrivalDate,103) as Дата_прихода_товара_с_партии
	  , INVENTSUM.ITEMID
	, INVENTSUM.AvailPhysical	as ФизДоступно
	,INVENTSUM.CLOSED
	,INVENTSUM.CLOSEDQTY
	, INVENTSUM.ReservPhysical as ФизЗарезвировано
	, INVENTSUM.AvailOrdered	as Доступное_общее_количество
	--, INVENTSUM.PostedQty		-- Разнесенное кол-во
	--, INVENTSUM.PostedValue	-- Фин. сумма
	--, INVENTSUM.Deducted		-- Отпущено
	, INVENTSUM.Received		-- Получено
	--, INVENTSUM.ReservOrdered	-- Зарезервировано в заказанных
	--, INVENTSUM.OnOrder		-- Заказано
	--, INVENTSUM.Registered	-- Зарегистрировано
	, INVENTSUM.Picked		-- Скоплектовано
	--, INVENTSUM.PhysicalValue	-- Физ. сумма
	--, INVENTSUM.Arrived		-- Прибыло
	--, INVENTSUM.PhysicalInvent -- Физические запасы
	--, INVENTSUM.ClosedQty		-- Физическое открытое количество
	--, INVENTSUM.PostedValueSecCur_RU	-- Фин. сумма
	--, INVENTSUM.PhysicalValueSecCur_RU -- Физ. сумма

	,InventBatch.SZ_VENDACCOUNT as Поставщик_партии
	,VENDTABLE.NAMEALIAS as Поставщик
	,InventBatch.INVENTBATCHID
			FROM INVENTSUM		
			LEFT JOIN INVENTDIM	ON INVENTSUM.INVENTDIMID = INVENTDIM.INVENTDIMID
				AND INVENTDIM.CREATEDDATETIME > @CREATEDDATETIME
				AND INVENTDIM.DATAAREAID = 'vir'
--				AND INVENTSUM.CLOSED = 0
			LEFT JOIN InventBatch		ON INVENTDIM.INVENTBATCHID = InventBatch.INVENTBATCHID
				AND InventBatch.DATAAREAID	= @DATAAREAID
				AND InventBatch.CREATEDDATETIME > @CREATEDDATETIME
			LEFT JOIN VENDTABLE ON InventBatch.SZ_VENDACCOUNT = VENDTABLE.ACCOUNTNUM
				AND VENDTABLE.DATAAREAID = 'vir'
			) as INVENTSUM		ON SALESLINE.ITEMID = INVENTSUM.ITEMID
				AND INVENTSUM.DATAAREAID = SALESLINE.DATAAREAID
*/





