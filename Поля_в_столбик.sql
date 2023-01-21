
-- Посмотреть наименование и типы полей таблицы вертикально
-- в конструкции WHERE в раздел выделенный красным вставить наименование таблицы
SELECT		TABLE_NAME AS [Имя таблицы],
			COLUMN_NAME AS [Имя столбца],
			DATA_TYPE AS [Тип данных столбца],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='CustInvoiceJour'
order by 2

-- Посмотреть техническую информацию по таблице с помощью процедуры
EXEC sp_help CustInvoiceJour