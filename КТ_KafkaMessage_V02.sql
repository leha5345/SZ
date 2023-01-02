DECLARE @TENDERTABLEID nvarchar(20),@REFTABLEIDSOURCE int, @REGNUMBER nvarchar(19) ;
	SET @REFTABLEIDSOURCE = 30968 --тендеры
	SET @TENDERTABLEID = '066777_268'
	SET @REGNUMBER = (select SUBSTRING(Out.decoded_value,CHARINDEX('RegNumber',Out.decoded_value)+13,19) as REG from (select cast(dbo.fn_Base64ToBinary(VALUEBASE64)  as varchar(max)) as [decoded_value] from KafkaMessage LEFT JOIN TENDERTABLE ON KafkaMessage.REFRECIDSOURSE = TENDERTABLE.RECID AND KafkaMessage.REFTABLEIDSOURCE = @REFTABLEIDSOURCE WHERE KafkaMessage.Direction = 10 AND TENDERTABLE.TENDERTABLEID = @TENDERTABLEID) as Out);

-- Найти по рег номеру контракт
select DATAAREAID,RContractAccount,RegistryEntryNumber,TenderTableId from RContractTable WHERE RegistryEntryNumber = @REGNUMBER
-- Посмотреть есть ли сопоставление для ЕИС контракта
select EISContractPackage.COMPANYSOURCE
	,EISContract.VERSIONNUMBER
	,EISContractPackage.RECID
	,EISContractPackage.PACKAGEID
	,EISContractPackage.REGNUMBER
	,EISContractPackage.TENDERTABLEID
	,EISContract.TENDERTABLEID
	from EISContractPackage 
LEFT JOIN EISContract ON EISContractPackage.PACKAGEID = EISContract.PACKAGEID
WHERE EISContractPackage.REGNUMBER = @REGNUMBER OR EISContract.REGNUMBER = @REGNUMBER
order by 1,2
--Просмотр статус запросов ЕИС контрактов в KafkaMessage
select 
	Out.RECID,
	Out.COMPANYSOURCE as COMPANY,
	Out.CREATEDDATETIME,
	Out.TENDERTABLEID,
	Out.Direction,
	Out.KafkaRecordStatus,
	Out.ExchangeChannel,
--	Out.TRANSACTIONID,
	SUBSTRING(Out.decoded_value,CHARINDEX('RegNumber',Out.decoded_value)+13,19) as REG,
--	Out.decoded_value,
	'//////' as Разделитель,
	Bxx.RECID as BxxRECID,
	Bxx.Direction,
	Bxx.KafkaRecordStatus,
	Bxx.CREATEDDATETIME,
--	Bxx.REFTRANSACTIONID,
	Bxx.decoded_value

from (
select 
  KafkaMessage.RECID,
  TENDERTABLE.TENDERTABLEID,
  TENDERTABLE.RECID as TENDER_RECID,
  KafkaMessage.REFRECIDSOURSE as Kafka_SOURSE,
  CASE 
		WHEN KafkaMessage.Direction = 10 THEN 'Исходящий'
		WHEN KafkaMessage.Direction = 5 THEN 'Входящий'
  END as Direction,
  CASE 
		WHEN KafkaMessage.KafkaRecordStatus = 0 THEN 'Новое' 
		WHEN KafkaMessage.KafkaRecordStatus = 1 THEN 'В процессе'
		WHEN KafkaMessage.KafkaRecordStatus = 2 THEN 'Обработано'
		WHEN KafkaMessage.KafkaRecordStatus = 3 THEN 'Часть'
		WHEN KafkaMessage.KafkaRecordStatus = 100 THEN 'Ошибка'
  END as KafkaRecordStatus,
  CASE 
		WHEN KafkaMessage.ExchangeChannel = 0 THEN 'Центр интеграции' 
		WHEN KafkaMessage.ExchangeChannel = 1 THEN 'МДЛП'
		WHEN KafkaMessage.ExchangeChannel = 2 THEN 'ЕИС'
  END as ExchangeChannel,
  CASE 
		WHEN KafkaMessage.EISType = 0 THEN 'Пусто' 
		WHEN KafkaMessage.EISType = 1 THEN 'Информация о контрагенте'
		WHEN KafkaMessage.EISType = 2 THEN 'Контракт(ы)'
		WHEN KafkaMessage.EISType = 3 THEN 'Список документов по контракту'
		WHEN KafkaMessage.EISType = 4 THEN 'Данные по документу'
		WHEN KafkaMessage.EISType = 100 THEN 'Входящий пакет документов'
		WHEN KafkaMessage.EISType = 101 THEN 'Исходящий пакет документов'
		WHEN KafkaMessage.EISType = 200 THEN 'Error'
  END as EISType,
  KafkaMessage.COMPANYSOURCE,
  KafkaMessage.CREATEDDATETIME,
  KafkaMessage.TRANSACTIONID,
  KafkaMessage.REFTRANSACTIONID,
  cast(dbo.fn_Base64ToBinary(VALUEBASE64)  as varchar(max)) as [decoded_value]
from KafkaMessage
  LEFT JOIN TENDERTABLE
	ON KafkaMessage.REFRECIDSOURSE = TENDERTABLE.RECID
		AND KafkaMessage.REFTABLEIDSOURCE = @REFTABLEIDSOURCE
WHERE 
	KafkaMessage.Direction = 10
	AND TENDERTABLE.TENDERTABLEID = @TENDERTABLEID
) as Out
LEFT JOIN 
	(

select 
	Bx.RECID,
	Bx.Direction,
	Bx.KafkaRecordStatus,
	Bx.CREATEDDATETIME,
	Bx.TRANSACTIONID,
	Bx.REFTRANSACTIONID,
	Bx.decoded_value
	from (
	select 
	  KafkaMessage.RECID,
	  CASE 
			WHEN KafkaMessage.Direction = 10 THEN 'Исходящий'
			WHEN KafkaMessage.Direction = 5 THEN 'Входящий'
	  END as Direction,
	  CASE 
			WHEN KafkaMessage.KafkaRecordStatus = 0 THEN 'Новое' 
			WHEN KafkaMessage.KafkaRecordStatus = 1 THEN 'В процессе'
			WHEN KafkaMessage.KafkaRecordStatus = 2 THEN 'Обработано'
			WHEN KafkaMessage.KafkaRecordStatus = 3 THEN 'Часть'
			WHEN KafkaMessage.KafkaRecordStatus = 100 THEN 'Ошибка'
	  END as KafkaRecordStatus,
	  CASE 
			WHEN KafkaMessage.ExchangeChannel = 0 THEN 'Центр интеграции' 
			WHEN KafkaMessage.ExchangeChannel = 1 THEN 'МДЛП'
			WHEN KafkaMessage.ExchangeChannel = 2 THEN 'ЕИС'
	  END as ExchangeChannel,
	  CASE 
			WHEN KafkaMessage.EISType = 0 THEN 'Пусто' 
			WHEN KafkaMessage.EISType = 1 THEN 'Информация о контрагенте'
			WHEN KafkaMessage.EISType = 2 THEN 'Контракт(ы)'
			WHEN KafkaMessage.EISType = 3 THEN 'Список документов по контракту'
			WHEN KafkaMessage.EISType = 4 THEN 'Данные по документу'
			WHEN KafkaMessage.EISType = 100 THEN 'Входящий пакет документов'
			WHEN KafkaMessage.EISType = 101 THEN 'Исходящий пакет документов'
			WHEN KafkaMessage.EISType = 200 THEN 'Error'
	  END as EISType,
	  KafkaMessage.COMPANYSOURCE,
	  KafkaMessage.CREATEDDATETIME,
	  KafkaMessage.TRANSACTIONID,
	  KafkaMessage.REFTRANSACTIONID,
	  cast(dbo.fn_Base64ToBinary(VALUEBASE64)  as varchar(max)) as [decoded_value]
	from KafkaMessage
	WHERE KafkaMessage.Direction = 5) as Bx
	) Bxx	ON Out.TRANSACTIONID = Bxx.REFTRANSACTIONID

ORDER BY 3 desc

