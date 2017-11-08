SELECT ProductID
	, COUNT(ProductID) as count_sales
	, LOG(COUNT(ProductID)) as log_count_sales
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID;