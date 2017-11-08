SELECT pc.Name as name
	,COUNT(SalesOrderID) as distinct_count_of_orders
FROM SalesLT.SalesOrderDetail sod
JOIN SalesLT.Product p
	ON sod.ProductID=p.ProductID
JOIN SalesLT.ProductCategory pc
	ON p.ProductCategoryID=pc.ProductCategoryID
WHERE ProductNumber LIKE 'FR-M94B-38'
	OR ProductNumber LIKE 'BK-R50R-60'
	OR ProductNumber LIKE 'BK-R50R-62'
	OR ProductNumber LIKE 'FR-R72Y-38'
	OR ProductNumber LIKE 'SO-R809-M'
	OR ProductNumber LIKE 'SO-R809-L'
	OR p.Color LIKE '%black%'
	OR p.Color LIKE '%null%'
GROUP BY pc.Name
HAVING COUNT(SalesOrderID) > 5
ORDER BY distinct_count_of_orders DESC;