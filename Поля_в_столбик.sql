

select t.name as tablename, c.name as fieldname
from sys.columns c
join sys.tables t on t.object_id=c.object_id
where t.name='CustInvoiceJour'
ORDER BY 2

SELECT		TABLE_NAME AS [Имя таблицы],
			COLUMN_NAME AS [Имя столбца],
			DATA_TYPE AS [Тип данных столбца],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='SALESTABLE'
order by 2