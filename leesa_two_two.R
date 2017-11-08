require(RODBC)
require(ggplot2)
require(jsonlite)

##create a connection to the database
my_connection <- odbcDriverConnect("driver={ODBC Driver 13 for SQL Server};
                    server=applicant-testing.database.windows.net;
                    Database=AdventureWorks;
                    uid=applicant@applicant-testing;
                    pwd=jwV/=dYtLefC@BP0")


##run the query on the connection
my_data <- sqlQuery(my_connection, 
                    "SELECT *
                    FROM predictive.webapi")


##close connection
odbcClose(my_connection)

##url to chr
url <- paste(my_data[,c('url')])

##get data/format/get mean data
df <- fromJSON(url)
df <- df[,grepl("entry_school_score", names(df))]
df <- sapply(df, as.numeric)
df_means <- t(colMeans(df, na.rm = TRUE))

target <- c('october_entry_school_score',
            'november_entry_school_score',
            'december_entry_school_score',
            'january_entry_school_score',
            'february_entry_school_score',
            'march_entry_school_score',
            'april_entry_school_score',
            'may_entry_school_score')

##convert to data frame order for plotting
df_formatted <- data.frame(key=names(df_reordered), value=df_reordered, row.names=NULL)
df_formatted$key <- factor(df_formatted$key, levels=target)

##plot data
ggplot(df_formatted, aes(x=key, y=value)) + geom_bar(stat="identity", width=.5, fill="#009933") + 
  labs(x="Month", y="Average") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
