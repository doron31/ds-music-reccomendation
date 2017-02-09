ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}



run_query <- function (query_string, db_type)
{
  if (db_type == "sql")
  {
    ipak(c("data.table", "RODBC", "sqldf", "RPresto"))
    # connect to sql db
    connection_string <- "driver=SQL Server;server=apollo.wixpress.com,2254; 
    trusted_connection=true"
    channel <- odbcDriverConnect(connection_string)
    
    # run query and into table
    table <- as.data.table(sqlQuery(channel = channel, query = query_string,
                                    stringsAsFactors = FALSE))
    
    # close connection to db
    odbcClose(channel) 
  } else if (db_type == "presto")
  {
    HOSTNAME<-"http://hermes.aus.wixpress.com"
    channel <- dbConnect(RPresto::Presto(), 
                         HOSTNAME, 
                         port=8181, 
                         user="doronbt", 
                         schema='ab', 
                         catalog='events')
    table <- as.data.table(dbGetQuery(channel, query_string))
    # odbcClose(channel)
  }
  table
}