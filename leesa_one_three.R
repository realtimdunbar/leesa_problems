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
    ORDER BY distinct_count_of_orders DESC;")

##close connection
odbcClose(my_connection)

##plot bar chart
ggplot(my_data, aes(x=reorder(name, -distinct_count_of_orders), y=distinct_count_of_orders)) + geom_bar(stat="identity", width=.5, fill="#009933") + 
  labs(x="Product Name", y="Order Count") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))


