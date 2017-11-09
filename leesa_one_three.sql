SELECT pc.Name as name
	,COUNT(pc.Name) as distinct_count_of_orders
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc
	ON p.ProductCategoryID=pc.ProductCategoryID
LEFT JOIN SalesLT.SalesOrderDetail sod
	ON p.ProductID=sod.ProductID
WHERE ProductNumber = 'FR-M94B-38'
	OR ProductNumber = 'BK-R50R-60'
	OR ProductNumber = 'BK-R50R-62'
	OR ProductNumber = 'FR-R72Y-38'
	OR ProductNumber = 'SO-R809-M'
	OR ProductNumber = 'SO-R809-L'
	OR p.Color = 'Black'
	OR p.Color = NULL
GROUP BY pc.Name
HAVING COUNT(pc.Name) > 5
ORDER BY distinct_count_of_orders DESC;

