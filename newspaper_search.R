
# This script to use MySQL within RStudio from: 
#https://programminghistorian.org/en/lessons/getting-started-with-mysql-using-r

#install.packages('RMariaDB')

library(RMariaDB)

#enter in the console, not this script
#localuserpassword <- <yourpassword_to_MySQL_db>

#Other option is to use a credential file as txt that will store the login
#saved as 'newspaper_search_results.cnf'


# [newspaper_search_results]
# user=newspaper_search_results_user
# password='userPW M---1---5$'
# host=127.0.0.1
# port=3306
# database=newspaper_search_results

#save the above commented into a text file and then use below
#rmariadb.settingsfile <- "newspaper_search_results.cnf.txt"


storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user='newspaper_search_results_user', 
                       password=localuserpassword, 
                       dbname='newspaper_search_results', 
                       host='localhost')
dbListTables(storiesDb)

#query the MySQL Workbench db

# Create the query statement.
query<-"INSERT INTO tbl_newspaper_search_results (
story_title,
story_date_published,
story_url,
search_term_used)
VALUES('THE LOST LUSITANIA22334455.',
'1945-05-21',
LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),
'German+Submarine');"

# Optional. Prints out the query in case you need to troubleshoot it.
print(query)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# Clear the result.
dbClearResult(rsInsert)

dbDisconnect(storiesDb)

##########################################

# Change the insert statement to use variables

storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user='newspaper_search_results_user', 
                       password=localuserpassword, 
                       dbname='newspaper_search_results', 
                       host='localhost')
dbListTables(storiesDb)




# Assign variables.
entryTitle <- "THE LOST LUSITANIA."
entryPublished <- "21 MAY 1916"
#convert the string value to a date to store it into the database
entryPublishedDate <- as.Date(entryPublished, "%d %B %Y")
entryUrl <- "http://newspapers.library.wales/view/4121281/4121288/94/"
searchTermsSimple <- "German+Submarine"

# Create the query statement
query<-paste(
  "INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used)
  VALUES('",entryTitle,"',
  '",entryPublishedDate,"',
  LEFT(RTRIM('",entryUrl,"'),99),
  '",searchTermsSimple,"')",
  sep = ''
)

#Optional. Prints out the query in case you need to troubleshoot it.
print(query)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# Clear the result.
dbClearResult(rsInsert)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)

##########################################

# See how MySQL handles errors with a change in the entry title name from above
# to THE LOST LUSITANIA RUDDER

storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user='newspaper_search_results_user', 
                       password=localuserpassword, 
                       dbname='newspaper_search_results', 
                       host='localhost')
dbListTables(storiesDb)




# Assign variables.
entryTitle <- "THE LOST LUSITANIA's RUDDER."
entryPublished <- "21 MAY 1916"
#convert the string value to a date to store it into the database
entryPublishedDate <- as.Date(entryPublished, "%d %B %Y")
entryUrl <- "http://newspapers.library.wales/view/4121281/4121288/94/"
searchTermsSimple <- "German+Submarine"

# Create the query statement
query<-paste(
  "INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used)
  VALUES('",entryTitle,"',
  '",entryPublishedDate,"',
  LEFT(RTRIM('",entryUrl,"'),99),
  '",searchTermsSimple,"')",
  sep = ''
)

#Optional. Prints out the query in case you need to troubleshoot it.
print(query)

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)
# Error: You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 's RUDDER.',
# '1916-05-21',
# LEFT(RTRIM('http://newspapers.library.wales/view/4' at line 6 [1064]

# Clear the result.
dbClearResult(rsInsert)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)



# Single apostrophes are part of SQL syntax and they indicate a text value. If they are in the wrong place, it causes an error. We have to handle cases where we have data with apostrophes. SQL accepts two apostrophes in an insert statement to represent an apostrophe in data ('').
# 
# We'll handle apostrophes by using a gsub function to replace a single apostrophe with a double one, as per below.

entryTitle <- "THE LOST LUSITANIA'S RUDDER."
# change a single apostrophe into a double apostrophe
entryTitle <- gsub("'", "''", entryTitle)

storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user='newspaper_search_results_user', 
                       password=localuserpassword, 
                       dbname='newspaper_search_results', 
                       host='localhost')

# now rerun the query
query<-paste(
  "INSERT INTO tbl_newspaper_search_results (
  story_title,
  story_date_published,
  story_url,
  search_term_used)
  VALUES('",entryTitle,"',
  '",entryPublishedDate,"',
  LEFT(RTRIM('",entryUrl,"'),99),
  '",searchTermsSimple,"')",
  sep = ''
)

print(query)
# [1] "INSERT INTO tbl_newspaper_search_results (\n  story_title,\n  story_date_published,\n  story_url,\n  search_term_used)\n  VALUES('THE LOST LUSITANIA''S RUDDER.',\n  '1916-05-21',\n  LEFT(RTRIM('http://newspapers.library.wales/view/4121281/4121288/94/'),99),\n  'German+Submarine')"

# Execute the query on the storiesDb that we connected to above.
rsInsert <- dbSendQuery(storiesDb, query)

# in MySQL when running 
# SELECT * FROM newspaper_search_results.tbl_newspaper_search_results WHERE story_title = "THE LOST LUSITANIA'S RUDDER.";

# id, story_title, story_date_published, story_url, search_term_used
# '2', 'THE LOST LUSITANIA\'S RUDDER.', '1916-05-21 00:00:00', 'http://newspapers.library.wales/view/4121281/4121288/94/', 'German+Submarine'

# Clear the result.
dbClearResult(rsInsert)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)

###################################################################################

#Storing a comma separated value .csv file into a MySQL database

#reconnect to MySQL db
storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user='newspaper_search_results_user', 
                       password=localuserpassword, 
                       dbname='newspaper_search_results', 
                       host='localhost')
dbListTables(storiesDb)


sampleGardenData <- read.csv(file="sample-data-allotment-garden.csv", header=TRUE, sep=",")

dbWriteTable(storiesDb, value = sampleGardenData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE )
# Error: Data too long for column 'story_title' at row 1 [1406]


# The story_title column in the database table can store values up to 99 characters long.
# This statement trims any story_titles that are any longer to 99 characters.
sampleGardenData$story_title <- substr(sampleGardenData$story_title,0,99)

# This statement formats story_date_published to represent a DATETIME.
sampleGardenData$story_date_published <- paste(sampleGardenData$story_date_published," 00:00:00",sep="")

dbWriteTable(storiesDb, value = sampleGardenData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE )

# read in the sample data from a newspaper search of German+Submarine
sampleSubmarineData <- read.csv(file="sample-data-submarine.csv", header=TRUE, sep=",")

sampleSubmarineData$story_title <- substr(sampleSubmarineData$story_title,0,99)
sampleSubmarineData$story_date_published <- paste(sampleSubmarineData$story_date_published," 00:00:00",sep="")

dbWriteTable(storiesDb, value = sampleSubmarineData, row.names = FALSE, name = "tbl_newspaper_search_results", append = TRUE )

#disconnect to clean up the connection to the database
dbDisconnect(storiesDb)


#######################################################

#Selecting data from a table with SQL using R

#reconnect to MySQL db

# library(RMariaDB)
# rmariadb.settingsfile<-"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\newspaper_search_results.cnf"
# 
# rmariadb.db<-"newspaper_search_results"
# storiesDb<-dbConnect(RMariaDB::MariaDB(),default.file=rmariadb.settingsfile,group=rmariadb.db)
# 
storiesDb <- dbConnect(RMariaDB::MariaDB(), 
                       user='newspaper_search_results_user', 
                       password=localuserpassword, 
                       dbname='newspaper_search_results', 
                       host='localhost')

dbListTables(storiesDb)


searchTermUsed="German+Submarine"

# Query a count of the number of stories matching searchTermUsed that were published each month.
#this groups by year and month published, ordering by year and month, where the month and year 
#are concatenated into a name called 'count'

# This first part of query provides a count of the number of stories published that share the same month and year publishing date. CONCAT stands for concatenate which creates a single text value from two or more separate text values, in this case the month and the year.

query<-paste("SELECT ( COUNT(CONCAT(MONTH(story_date_published), ' ',YEAR(story_date_published)))) as 'count'
    FROM tbl_newspaper_search_results
    WHERE search_term_used='",searchTermUsed,"'
    GROUP BY YEAR(story_date_published),MONTH(story_date_published)
    ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")

print(query)

rs = dbSendQuery(storiesDb,query)

dbRows<-dbFetch(rs)#52 obs of 1 var called 'count'
head(dbRows)
# count
# 1    15
# 2    17
# 3    37
# 4    40
# 5    15
# 6    19

countOfStories<-c(as.integer(dbRows$count))
# [1]  15  17  37  40  15  19  81  91 112  94  90  80  60  46  24  25  22  19  32  26  46  24  20  36
# [25]  33  13  23  40  28  20  56  35  27  33  24  20  19  16  25   9   9  10   6  17   7  28  17  22
# [49]  11   6   6   7

# Put the results of the query into a time series.
qts1 = ts(countOfStories, frequency = 12, start = c(1914, 8))

print(qts1)
# Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
# 1914                              15  17  37  40  15
# 1915  19  81  91 112  94  90  80  60  46  24  25  22
# 1916  19  32  26  46  24  20  36  33  13  23  40  28
# 1917  20  56  35  27  33  24  20  19  16  25   9   9
# 1918  10   6  17   7  28  17  22  11   6   6   7

# Plot the qts1 time series data with a line width of 3 in the color red.
plot(qts1,
     lwd=3,
     col = "red",
     xlab="Month of the war",
     ylab="Number of newspaper stories",
     xlim=c(1914,1919),
     ylim=c(0,150),
     main=paste("Number of stories in Welsh newspapers matching the search terms listed below.",sep=""),
     sub="Search term legend: Red = German+Submarine. Green = Allotment And Garden.")

#new query in R for gardens data set
searchTermUsed="AllotmentAndGarden"

# Query a count of the number of stories matching searchTermUsed that were published each month.
query<-paste("SELECT (  COUNT(CONCAT(MONTH(story_date_published),' ',YEAR(story_date_published)))) as 'count'   FROM tbl_newspaper_search_results   WHERE search_term_used='",searchTermUsed,"'   GROUP BY YEAR(story_date_published),MONTH(story_date_published)   ORDER BY YEAR(story_date_published),MONTH(story_date_published);",sep="")
print(query)
rs = dbSendQuery(storiesDb,query)
dbRows<-dbFetch(rs)

countOfStories<-c(as.integer(dbRows$count))

# Put the results of the query into a time series.
qts2 = ts(countOfStories, frequency = 12, start = c(1914, 8))

print(qts2)
# Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
# 1914                               5   6   2   5   1
# 1915   2   3   7   3   2   6  10   2   2   3   7   1
# 1916   4   6   1   3   1   8   1   6  11   1   1  14
# 1917  44  48  51  31  44  58  39  44  41  35  32  24
# 1918  51  45 105  74  76  53  53  75  31  39  25    
# 
# Add this line with the qts2 time series data to the the existing plot.
lines(qts2, lwd=3,col="darkgreen")

# Clear the result
dbClearResult(rs)

# Disconnect to clean up the connection to the database.
dbDisconnect(storiesDb)


