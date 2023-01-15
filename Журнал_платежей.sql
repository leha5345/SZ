/*

SELECT		TABLE_NAME AS [Имя таблицы],
			COLUMN_NAME AS [Имя столбца],
			DATA_TYPE AS [Тип данных столбца],
			CHARACTER_MAXIMUM_LENGTH,
			IS_NULLABLE AS [Значения NULL]
   FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='LedgerJournalTrans'
order by 2
*/



select 
	LedgerJournalTrans.JOURNALNUM
	,LedgerJournalTrans.TransDate
	,LedgerJournalTrans.AccountNum	--	AccountNum 57.01
	,LedgerJournalTrans.PostingProfile
	,LedgerJournalTrans.DocumentDate
	,LedgerJournalTrans.DocumentNum
	,CASE 
		WHEN LedgerJournalTrans.ACCOUNTTYPE = '0' THEN 'Главная книга' 
		WHEN LedgerJournalTrans.ACCOUNTTYPE = '1' THEN 'Клиент'
		WHEN LedgerJournalTrans.ACCOUNTTYPE = '2' THEN 'Поставщик'
		WHEN LedgerJournalTrans.ACCOUNTTYPE = '6' THEN 'Банк'
	 END as Тип_номенклатуры
	,LedgerJournalTrans.RCONTRACTACCOUNTDEBIT
	,LedgerJournalTrans.RCONTRACTCOMPANYCREDIT
	,LedgerJournalTrans.AmountCurDebit
	,LedgerJournalTrans.AmountCurCredit
--	,LedgerJournalTrans.BankCentralBankPurposeText
	,LedgerJournalTrans.TXT
from LedgerJournalTrans
JOIN RContractTable		ON LedgerJournalTrans.RCONTRACTACCOUNTDEBIT	= RContractTable.RContractAccount
	AND LedgerJournalTrans.DATAAREAID = RContractTable.DATAAREAID
WHERE LedgerJournalTrans.DATAAREAID = 'SZ'
--	AND LedgerJournalTrans.ACCOUNTTYPE = '0' 
	AND LedgerJournalTrans.TRANSDATE BETWEEN '2022-12-01T00:00:00.000' AND '2022-12-31T00:00:00.000'
--	AND LedgerJournalTrans.RECID = 5638627356
