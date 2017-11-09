SELECT SalesOrderID
	, SUM(OrderQty) as total_order_quantity
	, LOG(SUM(OrderQty)) as log_total_order_quantity
FROM SalesLT.SalesOrderDetail
GROUP BY SalesOrderID;