################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                         Day 4 1/2 - Databases & SQL                          #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

#-----------#
# Databases #
#-----------#

# Databases can be some of the most powerful ways to large amounts of data while
# still making them easily accessible and subsettable, or queryable. Querying a 
# database is typically as simple as writing a single line of script defining
# what data you want and where to get it from; this is done through the use of
# structured query language, or SQL. Although queries can be quite simple, they 
# can easily get much more complicated if you have data stored in different 
# tables. This is often the case with relational databases, where you store data
# in a variety of related tables so as to reduce the reundancy of data that may 
# be found in many entries. The specific flavor of relational database that 
# we'll be talking about today is MySQL, but there are many different types of 
# relational databases (which use mostly the same structured query languge).

# The main package that R uses for interfacing with databases both over the
# internet and over internal networks is DBI, short for database interface. 
# However, by loading the specific RMySQL DBI backend, DBI will also be loaded
# for use in our R session. Most of the work that RMySQL does will be behind the
# scenes, with the DBI functions doing the majority of the heavy lifting.
#   Note, DBI and RMySQL are not part of the tidyverse, although the tidyverse
#   does have functions that work well with remote databases. We will discuss
#   these functions in our session on data manipulation.
install.packages("RMySQL")
library("RMySQL")

# The DBI function that you will use a lot when connecting to any database is
# dbConnect(). The first argument will be a call to the function of the DBI 
# backend, so in our case, MySQL(). The second argument will be the username 
# used to access the database, and third will be this user's password. Next will
# be the internet location where the database is hosted; in our case, I've put
# a database up in the Amazon Web Services cloud for us to use for the course.
# Last, but not least is the name of the specific database you'd like to connect
# to; this is because hosts may host more than one database. Finally, make sure 
# to save the output of this function as an object so that you don't have to
# type out all of this every time you're running a DBI function.
#   Best practice: don't save your passwords in R script. I'm doing this to make
#   running examples easier, but there are many ways around saving your password
#   in with your R script.

# This next bit of code looks funky, but it serves a purpose: it gets a password
# from user input, connects to the database specified by other inputs, and wipes
# the password from memory in one continuous string of commands, so that we do
# not forget to remove the password from our system's memory. This is a very
# hacky way to do this, and if you ant to do this in your own code, consider
# using the (mush more refined) R package getPass instead.
con <- dbConnect(MySQL(),
                 host = rstudioapi::askForPassword("Host address"),
                 dbname = rstudioapi::askForPassword("Database name"),
                 user = rstudioapi::askForPassword("Database user"),
                 password = rstudioapi::askForPassword("Database password")
)

# To retrieve data from your database, use the function dbGetQuery() with the 
# fist argument as the result of your dbConnect() function and the secons as a 
# string of SQL script. The following will retrieve all data from the table
# mtcars; the * is SQL wildcard for "everything".
dbGetQuery(con, "SELECT * FROM mtcars")

# If you want to just retrieve specific columns from the table, put these in
# after the SELECT statement, separated by commas.
dbGetQuery(con, "SELECT mpg, cyl FROM mtcars")

# And finally, you can also use DBI to upload data to the database using
# functions starting with dbWrite...
dbWriteTable(conn = con, name = 'mtcars', value = mtcars)

# There is a lot more that you can do with SQL, especially when it comes to 
# joining related tables, but this all requires more knowledge of SQL. Here 
# are the SQL queries that we learned to write in class:

#-------------#
# SQL Queries #
#-------------#

# If starting from scratch with a new SQL instance, you'll need to first make
# a database:

CREATE DATABASE db_name;

# Then you will need to tell SQL to use this database for all further queries:

USE db_name;

# Once you have your database made, you'll also need to make a table (or many).
# Remember when making a table that you will need to specify each column name,
# data type, and special properties, like DEFAULT, NOT NULL, or UNIQUE:

CREATE TABLE tbl_1_name (
    column_1_name INT(6) AUTO_INCREMENT;
    column_2_name TINYINT(1) DEFAULT 0;
    column_3_name CHAR(15) UNIQUE,
    column_4_name VARCHAR(31) NOT NULL
);

# Once you have a database, you will need to put data into it. This is done with
# an INSERT INTO query, which will make a new row of data:

INSERT INTO tbl_1_name (column_1_name,
                        column_2_name,
                        column_3_name,
                        column_4_name) VALUES (1, 1, "ABCDEFGHIJKLMNO", "yes");

# If you need to change data in the database, you use an UPDATE query:

UPDATE tbl_1_name SET column_4_name="no" WHERE column_3_name="ABCDEFGHIJKLMNO";

# And if you really don't want to keep a row of data around, you can use a 
# DELETE query, but make sure to provide a condition for this query or else you
# will delete ALL ROWS OF DATA IN YOUR TABLE!

DELETE FROM tbl_1_name WHERE column_3_name="ABCDEFGHIJKLMNO";

