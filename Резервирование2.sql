
--Просмотр резервирования товара в разрезе складских аналитик
--если запустить по всем товарам без фильтра, то скрипт сожрет всю оперативу на сервере, поэтому в таком варианте на рабочей базе не выполнять

select DISTINCT
	INVENTSUM.DATAAREAID
	, INVENTSUM.ITEMID
--	,INVENTTABLE.NAMEALIAS
	,INVENTTABLE.TenderInventInternationalName as MNN
--	,InventTable.ProdVendName as Производитель
	,InventTable.VITAL
--	, INVENTSUM.Closed
	, INVENTSUM.InventDimId	-- аналитики
	--, VendInvoiceTrans.PURCHID
	--, VendInvoiceJour.InvoiceId
	--, CONVERT(date,VendInvoiceJour.INVOICEDATE,103) as Дата_разноски_Накладной	
	--, CAST(VendInvoiceTrans.LINEAMOUNT AS DECIMAL(10,2)) as Сумма_по_строке_без_НДС
	--, CONVERT(date,InventTrans.DateFinancial,103) as Финансовая_дата_проводки	
	, INVENTDIM.INVENTLOCATIONID
--	, VendInvoiceTrans.INVENTTRANSID
	, INVENTDIM.DEPARTMENTID
	, INVENTDIM.INVENTBATCHID
	, INVENTDIM.PURCHREQLINEID
--	, InventDim.InventExpireDate
	, CONVERT(date,InventDim.InventExpireDate,103) as Срок_годности
	--, INVENTSUM.Closed		-- если да, то значит товарный остаток закончился, все суммы списаны
--	, INVENTSUM.AvailPhysical	as ФизДоступно
	, CAST(INVENTSUM.AvailPhysical AS NUMERIC(20,0)) as ФизДоступно

--	, INVENTSUM.ReservPhysical as ФизЗарезвировано
	--, INVENTSUM.LastUpdDatePhysical	-- Физ. дата
	--, INVENTSUM.LastUpdDateExpected	--Ожидаемая дата
	--, INVENTSUM.AvailOrdered	-- Доступное общее количество
	--, INVENTSUM.PostedQty		-- Разнесенное кол-во
	--, INVENTSUM.PostedValue	-- Фин. сумма
	--, INVENTSUM.Deducted		-- Отпущено
	--, INVENTSUM.Received		-- Получено
	--, INVENTSUM.ReservOrdered	-- Зарезервировано в заказанных
--	, INVENTSUM.OnOrder		-- Заказано
--	, INVENTSUM.Ordered		-- Заказано
	--, INVENTSUM.Registered	-- Зарегистрировано
	--, INVENTSUM.Picked		-- Скоплектовано
	--, INVENTSUM.PhysicalValue	-- Физ. сумма
	--, INVENTSUM.Arrived		-- Прибыло
	--, INVENTSUM.PhysicalInvent -- Физические запасы
	--, INVENTSUM.ClosedQty		-- Физическое открытое количество
	--, INVENTSUM.PostedValueSecCur_RU	-- Фин. сумма
	--, INVENTSUM.PhysicalValueSecCur_RU -- Физ. сумма
--	,PurchRealPriceTable.RECID
--	,PurchRealPriceTable.DATAAREAID
	,PurchRealPriceTable.PurchRealPrice as РВЦ_прихода
	,CONVERT(date,InventBatch.arrivalDate,103) as Дата_прихода_товара_с_партии
	from INVENTSUM
	LEFT JOIN INVENTDIM			ON INVENTSUM.INVENTDIMID = INVENTDIM.INVENTDIMID
	LEFT JOIN InventBatch		ON INVENTDIM.INVENTBATCHID = InventBatch.INVENTBATCHID
	LEFT JOIN INVENTTRANS		ON INVENTDIM.INVENTDIMID = INVENTTRANS.INVENTDIMID
	JOIN INVENTTABLE			ON INVENTSUM.ITEMID		 = INVENTTABLE.ITEMID
	JOIN PurchRealPriceTable	ON INVENTDIM.INVENTDIMID = PurchRealPriceTable.INVENTDIMID
		AND INVENTTABLE.ITEMID = PurchRealPriceTable.ITEMID
	--LEFT JOIN VendInvoiceTrans	ON INVENTTRANS.INVENTTRANSID = VendInvoiceTrans.INVENTTRANSID
	--	AND INVENTTRANS.ITEMID = VendInvoiceTrans.ITEMID
	--LEFT JOIN VendInvoiceJour	ON VendInvoiceTrans.PURCHID = VendInvoiceJour.PURCHID
WHERE INVENTSUM.DATAAREAID = 'SZ'
	AND INVENTSUM.Closed = 0 
	AND INVENTSUM.ITEMID		IN ('22140')
--	ANd  INVENTDIM.INVENTLOCATIONID = 'МР_СкладПродаж'	
--	AND INVENTSUM.AvailPhysical > 0
--	AND INVENTDIM.InventDimId IN ('06839165_131','06839308_131')
	AND INVENTDIM.INVENTLOCATIONID IN ('СкладПродаж')
--	AND INVENTDIM.DEPARTMENTID = 'Комм'
--	AND InventDim.InventExpireDate < N'2022-12-31T00:00:00.000'
	AND INVENTSUM.AvailPhysical <> 0
ORDER BY 1,2
--09712560_131
--09712560_131




