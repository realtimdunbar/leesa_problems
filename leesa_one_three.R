require(RODBC)
require(ggplot2)

##create a connection to the database
my_connection <- odbcDriverConnect("driver={ODBC Driver 13 for SQL Server};
     server=applicant-testing.database.windows.net;
     Database=AdventureWorks;
     uid=applicant@applicant-testing;
     pwd=jwV/=dYtLefC@BP0")

##run the query on the connection
my_data <- sqlQuery(my_connection, 
    "SELECT pc.Name as name
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
    ORDER BY distinct_count_of_orders DESC;")

##close connection
odbcClose(my_connection)

##plot bar chart
ggplot(my_data, aes(x=reorder(name, -distinct_count_of_orders), y=distinct_count_of_orders)) + geom_bar(stat="identity", width=.5, fill="#009933") + 
  labs(x="Product Name", y="Order Count") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))


