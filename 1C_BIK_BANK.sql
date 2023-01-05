
/*
SELECT		TABLE_NAME AS [Имя таблицы],
			COLUMN_NAME AS [Имя столбца],
			DATA_TYPE AS [Тип данных столбца],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='KafkaMessage'
order by 2
*/

-- Просмотр журналов интеграции с ошибкой по БИК банка
select TOP 30 
	N_IAx1s8xExchangeJournal.RECID
	,N_IAx1s8xExchangeJournal.CONFIGID
	,CASE
		WHEN N_IAx1s8xExchangeJournal.ExpImpType = 1 THEN 'Импорт'
		WHEN N_IAx1s8xExchangeJournal.ExpImpType = 2 THEN 'Экспорт'
	 END as Направление
	,N_IAx1s8xExchangeJournal.ExchangeStatus
	,CASE
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 0 THEN 'Ожидание'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 1 THEN 'Выполнение'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 2 THEN 'Ошибка'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 3 THEN 'Завершено'
		WHEN N_IAx1s8xExchangeJournal.ExchangeStatus = 4 THEN 'Отменено'
	 END as Статус
	,N_IAx1s8xRulesTable.DESCRIPTION
	,SUBSTRING(N_IAx1s8xExchangeJournal.XML,188,9) AS BIC
from N_IAx1s8xExchangeJournal 
JOIN N_IAx1s8xRulesTable ON N_IAx1s8xExchangeJournal.RULESID = N_IAx1s8xRulesTable.RULESID
	AND N_IAx1s8xExchangeJournal.CONFIGID = N_IAx1s8xRulesTable.CONFIGID
WHERE N_IAx1s8xRulesTable.DESCRIPTION = 'Импорт банков - Банки'
--	AND N_IAx1s8xExchangeJournal.CONFIGID = 'SzAcc30' -- SzAcc30
	AND N_IAx1s8xExchangeJournal.ExchangeStatus = 2 -- ExchangeStatus / Статус
ORDER BY 1 DESC


