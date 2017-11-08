WITH bike_sales AS (
	SELECT StateProvince
		, sum(TotalDue) AS bike_group_sales
	FROM SalesLT.SalesOrderHeader soh
	JOIN SalesLT.Address a
		ON soh.BillToAddressID=a.AddressID
	JOIN SalesLT.Customer c
		ON soh.CustomerID=c.CustomerID
	WHERE CountryRegion LIKE 'United States'
		AND CompanyName LIKE '%bike%'
	GROUP BY StateProvince, CountryRegion
)
, non_bike_sales AS (
	SELECT StateProvince
		, sum(TotalDue) as non_bike_group_sales
	FROM SalesLT.SalesOrderHeader soh
	JOIN SalesLT.Address a
		ON soh.BillToAddressID=a.AddressID
	JOIN SalesLT.Customer c
		ON soh.CustomerID=c.CustomerID
	WHERE CountryRegion LIKE 'United States'
		AND CompanyName NOT LIKE '%bike%'
	GROUP BY StateProvince, CountryRegion
)
SELECT COALESCE(nbs.StateProvince, bs.StateProvince) as state
	, ROUND(non_bike_group_sales, 2) as non_bike_group_sales
	, ROUND(bike_group_sales, 2) as bike_group_sales 
FROM non_bike_sales nbs
FULL JOIN bike_sales bs
	ON nbs.StateProvince=bs.StateProvince
ORDER BY bike_group_sales DESC;



