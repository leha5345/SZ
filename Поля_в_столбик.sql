

select t.name as tablename, c.name as fieldname
from sys.columns c
join sys.tables t on t.object_id=c.object_id
where t.name='CustInvoiceJour'
ORDER BY 2

SELECT		TABLE_NAME AS [��� �������],
			COLUMN_NAME AS [��� �������],
			DATA_TYPE AS [��� ������ �������],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [�������� NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='SALESTABLE'
order by 2