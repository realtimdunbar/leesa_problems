SELECT pc.Name as name
	,COUNT(SalesOrderID) as distinct_count_of_orders
FROM SalesLT.SalesOrderDetail sod
JOIN SalesLT.Product p
	ON sod.ProductID=p.ProductID
JOIN SalesLT.ProductCategory pc
	ON p.ProductCategoryID=pc.ProductCategoryID
WHERE ProductNumber = 'FR-M94B-38'
	OR ProductNumber = 'BK-R50R-60'
	OR ProductNumber = 'BK-R50R-62'
	OR ProductNumber = 'FR-R72Y-38'
	OR ProductNumber = 'SO-R809-M'
	OR ProductNumber = 'SO-R809-L'
	OR p.Color = 'Black'
	OR p.Color = NULL
GROUP BY pc.Name
HAVING COUNT(SalesOrderID) > 5
ORDER BY distinct_count_of_orders DESC;

