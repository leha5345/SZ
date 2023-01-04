
--�������� �������������� ������ � ������� ��������� ��������
--���� ��������� �� ���� ������� ��� �������, �� ������ ������ ��� ��������� �� �������, ������� � ����� �������� �� ������� ���� �� ���������

select DISTINCT
	INVENTSUM.DATAAREAID
	, INVENTSUM.ITEMID
--	,INVENTTABLE.NAMEALIAS
	,INVENTTABLE.TenderInventInternationalName as MNN
--	,InventTable.ProdVendName as �������������
	,InventTable.VITAL
--	, INVENTSUM.Closed
	, INVENTSUM.InventDimId	-- ���������
	--, VendInvoiceTrans.PURCHID
	--, VendInvoiceJour.InvoiceId
	--, CONVERT(date,VendInvoiceJour.INVOICEDATE,103) as ����_��������_���������	
	--, CAST(VendInvoiceTrans.LINEAMOUNT AS DECIMAL(10,2)) as �����_��_������_���_���
	--, CONVERT(date,InventTrans.DateFinancial,103) as ����������_����_��������	
	, INVENTDIM.INVENTLOCATIONID
--	, VendInvoiceTrans.INVENTTRANSID
	, INVENTDIM.DEPARTMENTID
	, INVENTDIM.INVENTBATCHID
	, INVENTDIM.PURCHREQLINEID
--	, InventDim.InventExpireDate
	, CONVERT(date,InventDim.InventExpireDate,103) as ����_��������
	--, INVENTSUM.Closed		-- ���� ��, �� ������ �������� ������� ����������, ��� ����� �������
--	, INVENTSUM.AvailPhysical	as �����������
	, CAST(INVENTSUM.AvailPhysical AS NUMERIC(20,0)) as �����������

--	, INVENTSUM.ReservPhysical as ����������������
	--, INVENTSUM.LastUpdDatePhysical	-- ���. ����
	--, INVENTSUM.LastUpdDateExpected	--��������� ����
	--, INVENTSUM.AvailOrdered	-- ��������� ����� ����������
	--, INVENTSUM.PostedQty		-- ����������� ���-��
	--, INVENTSUM.PostedValue	-- ���. �����
	--, INVENTSUM.Deducted		-- ��������
	--, INVENTSUM.Received		-- ��������
	--, INVENTSUM.ReservOrdered	-- ��������������� � ����������
--	, INVENTSUM.OnOrder		-- ��������
--	, INVENTSUM.Ordered		-- ��������
	--, INVENTSUM.Registered	-- ����������������
	--, INVENTSUM.Picked		-- �������������
	--, INVENTSUM.PhysicalValue	-- ���. �����
	--, INVENTSUM.Arrived		-- �������
	--, INVENTSUM.PhysicalInvent -- ���������� ������
	--, INVENTSUM.ClosedQty		-- ���������� �������� ����������
	--, INVENTSUM.PostedValueSecCur_RU	-- ���. �����
	--, INVENTSUM.PhysicalValueSecCur_RU -- ���. �����
--	,PurchRealPriceTable.RECID
--	,PurchRealPriceTable.DATAAREAID
	,PurchRealPriceTable.PurchRealPrice as ���_�������
	,CONVERT(date,InventBatch.arrivalDate,103) as ����_�������_������_�_������
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
--	ANd  INVENTDIM.INVENTLOCATIONID = '��_�����������'	
--	AND INVENTSUM.AvailPhysical > 0
--	AND INVENTDIM.InventDimId IN ('06839165_131','06839308_131')
	AND INVENTDIM.INVENTLOCATIONID IN ('�����������')
--	AND INVENTDIM.DEPARTMENTID = '����'
--	AND InventDim.InventExpireDate < N'2022-12-31T00:00:00.000'
	AND INVENTSUM.AvailPhysical <> 0
ORDER BY 1,2
--09712560_131
--09712560_131




