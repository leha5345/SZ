
/*
SELECT		TABLE_NAME AS [��� �������],
			COLUMN_NAME AS [��� �������],
			DATA_TYPE AS [��� ������ �������],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [�������� NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='KafkaMessage'
order by 2
*/

-- �������� �������� ���������� � ������� �� ��� �����
select TOP 30 
	N_IAx1s8xExchangeJournal.RECID
	,N_IAx1s8xExchangeJournal.CONFIGID
	,CASE
		WHEN N_IAx1s8xExchangeJournal.ExpImpType = 1 THEN '������'
		WHEN N_IAx1s8xExchangeJournal.ExpImpType = 2 THEN '�������'
	 END as �����������
	,N_IAx1s8xExchangeJournal.ExchangeStatus
	,CASE
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 0 THEN '��������'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 1 THEN '����������'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 2 THEN '������'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 3 THEN '���������'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 4 THEN '��������'
	 END as ������
	,N_IAx1s8xRulesTable.DESCRIPTION
	,SUBSTRING(N_IAx1s8xExchangeJournal.XML,188,9) AS BIC
from N_IAx1s8xExchangeJournal 
JOIN N_IAx1s8xRulesTable ON N_IAx1s8xExchangeJournal.RULESID = N_IAx1s8xRulesTable.RULESID
	AND N_IAx1s8xExchangeJournal.CONFIGID = N_IAx1s8xRulesTable.CONFIGID
WHERE N_IAx1s8xRulesTable.DESCRIPTION = '������ ������ - �����'
--	AND N_IAx1s8xExchangeJournal.CONFIGID = 'SzAcc30' -- SzAcc30
	AND N_IAx1s8xExchangeJournal.ExchangeStatus = 2 -- ExchangeStatus / ������
ORDER BY 1 DESC


