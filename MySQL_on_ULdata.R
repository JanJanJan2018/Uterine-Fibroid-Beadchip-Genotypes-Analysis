
# This script to use MySQL within RStudio from: 
#https://programminghistorian.org/en/lessons/getting-started-with-mysql-using-r

# this is modified to import csv data on ULs from Rstudio into the MySQL Workbench

library(RMariaDB)

UL_data <- read.csv('UL_nonUL_beadchip_stats.csv', sep=',',header=TRUE, na.strings=c('',' ','NA'))
colnames(UL_data) <- c("SEQUENCE",
                       "SYMBOL",
                       "GENE_COUNT",
                       "UL_MEAN",
                       "UL_MEDIAN",
                       "UL_MAX",
                       "UL_MIN",
                       "UL_SE",
                       "nonUL_MEAN",
                       "nonUL_MEDIAN",
                       "nonUL_MAX",
                       "nonUL_MIN",
                       "nonUL_SE",
                       "FOLDCHANGE_MEAN_UL_to_nonUL")

#enter in the console, not this script
# rootpw = ''
user='root'


storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user=user, 
                       password=rootpw, 
                       dbname='newspaper_search_results', 
                       host='localhost')
dbListTables(storiesDb)

#query the MySQL Workbench db

# Create the query statement to create the UL database if it doesn't already exist.
query1 <- "CREATE DATABASE UL_data;"

# Optional. Prints out the query in case you need to troubleshoot it.
print(query1)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query1)

# Clear the result.
dbClearResult(rsInsert)

dbDisconnect(storiesDb)

##########################################

# rename our connection from storiesDb to ULsDb
ULsDb <- dbConnect(RMariaDB::MariaDB(), 
                       user=user, 
                       password=rootpw, 
                       dbname='UL_data', 
                       host='localhost')
dbListTables(ULsDb)

# Clear the result.
dbClearResult(rsInsert)

query2 <- "USE ul_data;"

#Optional. Prints out the query in case you need to troubleshoot it.
print(query2)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(ULsDb, query2)


# Clear the result.
dbClearResult(rsInsert)

#this createsa duplicate table, a ul_data1 identical to this was created in My_SQL Workbench
#in same db: ul_data.

query3 <- "CREATE TABLE ul_data.ul_data1 (
SEQUENCE CHAR(99),
SYMBOL CHAR(15),
GENE_COUNT INT,
UL_MEAN FLOAT,
UL_MEDIAN FLOAT,
UL_MAX FLOAT,
UL_MIN FLOAT,
UL_SE FLOAT,
nonUL_MEAN FLOAT,
nonUL_MEDIAN FLOAT,
nonUL_MAX FLOAT,
nonUL_MIN FLOAT,
nonUL_SE FLOAT,
FOLDCHANGE_MEAN_UL_to_nonUL FLOAT,
);"

print(query3)

rsInsert <- dbSendQuery(ULsDb, query3)

dbClearResult(rsInsert)

query4 <- "CREATE TABLE ul_data.ul_data2 (
SEQUENCE CHAR(99),
SYMBOL CHAR(15),
GENE_COUNT INT,
UL_MEAN FLOAT,
UL_MEDIAN FLOAT,
UL_MAX FLOAT,
UL_MIN FLOAT,
UL_SE FLOAT,
nonUL_MEAN FLOAT,
nonUL_MEDIAN FLOAT,
nonUL_MAX FLOAT,
nonUL_MIN FLOAT,
nonUL_SE FLOAT,
FOLDCHANGE_MEAN_UL_to_nonUL FLOAT
);"

print(query4)

rsInsert <- dbSendQuery(ULsDb, query4)

dbClearResult(rsInsert)

query5 <- "CREATE TABLE ul_data.ul_data3 (
SEQUENCE CHAR(99),
SYMBOL CHAR(15),
GENE_COUNT INT,
UL_MEAN FLOAT,
UL_MEDIAN FLOAT,
UL_MAX FLOAT,
UL_MIN FLOAT,
UL_SE FLOAT,
nonUL_MEAN FLOAT,
nonUL_MEDIAN FLOAT,
nonUL_MAX FLOAT,
nonUL_MIN FLOAT,
nonUL_SE FLOAT,
FOLDCHANGE_MEAN_UL_to_nonUL FLOAT
);"

print(query5)

rsInsert <- dbSendQuery(ULsDb, query5)

dbClearResult(rsInsert)

query6 <- "CREATE TABLE ul_data.ul_data4 (
SEQUENCE CHAR(99),
SYMBOL CHAR(25),
GENE_COUNT INT,
UL_MEAN FLOAT,
UL_MEDIAN FLOAT,
UL_MAX FLOAT,
UL_MIN FLOAT,
UL_SE FLOAT,
nonUL_MEAN FLOAT,
nonUL_MEDIAN FLOAT,
nonUL_MAX FLOAT,
nonUL_MIN FLOAT,
nonUL_SE FLOAT,
FOLDCHANGE_MEAN_UL_to_nonUL FLOAT
);"

print(query6)

rsInsert <- dbSendQuery(ULsDb, query6)

#write the csv data from the UL_data file into the ul_data4 SQL table
dbWriteTable(ULsDb, value = UL_data, row.names = FALSE, name = "ul_data4", append = TRUE )

# Disconnect to clean up the connection to the database.
dbDisconnect(ULsDb)

##########################################
ULsDb <- dbConnect(RMariaDB::MariaDB(), 
                   user=user, 
                   password=rootpw, 
                   dbname='UL_data', 
                   host='localhost')
dbListTables(ULsDb)
# [1] "ul_data1" "ul_data2" "ul_data3" "ul_data4"

# Clear the result.
dbClearResult(rsInsert)

query7 <- "USE ul_data;"
rsInsert <- dbSendQuery(ULsDb, query7)

# lets delete the first 3 tables, and keep only the ul_data4 table in the UL_data db
# via our MySQL connection ULsDb.
query8 <- "DROP TABLE ul_data.ul_data1;"
rsInsert <- dbSendQuery(ULsDb, query8)

dbClearResult(rsInsert)
dbListTables(ULsDb)
# [1] "ul_data2" "ul_data3" "ul_data4"

query9 <- "DROP TABLE ul_data.ul_data2;"
query10 <- "DROP TABLE ul_data.ul_data3;"

rsInsert <- dbSendQuery(ULsDb, query9)
dbClearResult(rsInsert)

rsInsert <- dbSendQuery(ULsDb, query10)
dbClearResult(rsInsert)

dbListTables(ULsDb)
# [1] "ul_data4"

####################################################

