
USE [DAX2009_1]
GO
SELECT WMSPickingRoute.transRefId
	,FixingDateTimeSalesTtransfers.MINDATESHIPMENT -- Дата накладной + 3
	,DATEADD(hour, +3,WMSPickingRoute.DlvDate) AS  DlvDate
	,DATEADD(hour, +3,WMSPickingRoute.DlvDateMP) AS  DlvDateMP
	--,WMSPickingRoute.DlvDate
	--,WMSPickingRoute.DlvDateMP
	,'///////////'
	,FixingDateTimeSalesTtransfers.CURRENTDATETIME -- Дата создания + 3
	,DATEADD(hour, +3,WMSPickingRoute.CREATEDDATETIME) AS  CREATEDDATETIME
--	,WMSPickingRoute.CREATEDDATETIME
FROM WMSPickingRoute
LEFT JOIN FIXINGDATETIMESALESTTRANSFERS ON WMSPickingRoute.transRefId = FIXINGDATETIMESALESTTRANSFERS.SALESID
WHERE WMSPickingRoute.transRefId = '00603706_069' 
