################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#          Day 4 - Importing Data from Files, Databases, and the Web           #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# R is very flexible when it comes to importing data, which means that you don't
# just have to generate your own data within your R session, but you can bring 
# in a wide variety of data to do whatever you'd like with.

# For this session and the three that follow it, we'll be relying heavily on the
# "tidyverse" for many of our functions. The tidyverse has become the modern
# standard for data science with R, much like numpy or pandas have for Python. 
# The tidyverse simplifies, optimizes, and standardizes many of the functions 
# that are also available in base R, so where possible, I'll also be 
# demonstrating how to do things without tidyverse packages, if for no other
# reason than to show you just how much better life is in the tidyverse.

# The tidyverse is a collection of interrelated packages developed largely by
# one R guru: Hadley Wickham. I've linked to the online version of his popular
# book, R for Data Science, in the syllabus and in the README for the repo. If 
# you have the time, you should definitely check it out!

# So, as I mentioned, the tidyverse is a collection of packages in R. A package
# is, itself, really nothing more than a collection of bundled functions and
# objects that serve to solve some problem in R. The way you bring a package 
# into your R session is as follows:
library(tidyverse)

# ...but of course, that won't work yet, since we haven't downloaded the
# tidyverse. Let's do that using install.packages()
install.packages("tidyverse")

# ...and now we can finally "import" the packages:
library("tidyverse")

# An easier way to handle this install-first-load-second thing is to try to 
# install a package first, and if that gives you an error, then install and try
# to load the package again. I like to automate this with the following function
easypack <- function(package) {
  tryCatch(library(package, character.only = TRUE),
           error = function(e) {
             install.packages(package);
             library(package, character.only = TRUE)})
}

#------------#
# Flat Files #
#------------#

# We'll start today with reading in flat files- these are files that store all
# of their data in a "flat" file structure, with all data stored in one place,
# without any relational structures, and typically, without stored metadata. In
# the tidyverse, the specific package for reading flat files is readr, but it is
# already loaded from when we called library() on the entire tidyverse. Doing 
# this (importing just a single package) can save time and space if you know 
# you'll just need a specific function.
easypack("readr")
library("readr")
# The simplest way to read a flat file into R is to just read the whole file 
# into one long string. Sometimes this is a great idea- for instance, maybe you
# want to import a long text file for natural language processing or genomics.  
# In base R, you do this with readChar()
readChar("data/prideandprejudice.txt") # readChar() requires you to state length
readChar("data/prideandprejudice.txt", nchars = 1e4) # ...so you have to guess
readChar("data/prideandprejudice.txt", nchars = 1e5) # ...over and over
readChar("data/prideandprejudice.txt", nchars = 1e6) # ...until you guess right

# Another way to get the length of the text file programmatically is to 
# calculate the filesize from file.info()
fileName <- "data/prideandprejudice.txt"
readChar(fileName, file.info(fileName)$size)

# But you'll be happy to know that in the tidyverse, this is all done quite 
# easily with the function read_file()
read_file("data/prideandprejudice.txt")

# But what if we want to read in the text file one line at a time? For this, 
# using base R, we can use readLines
# but not able to sense some of the unicodes
readLines("data/prideandprejudice.txt")

# That went a lot smoother than readChar() did, but one glaring issue is the
# fact that readLines() has trouble making sense of some more exotic characters
# Luckily, the functions in readr don't have any trouble with this; for reading 
# in a file line by line, use the tidyverse function read_lines()
#   Sidenote: remember that just running the read function will not import any
#   data permanently into R as an object. To do this, you must assign the return
#   of your read function to an object.
(pride <- read_lines("data/prideandprejudice.txt"))

# We can also use some simple conditional subsetting to remove all the empty 
# lines in the file that was read in.
pride[pride != ""]
pride_noemptylines <- pride[pride != ""]
# The next type of file you may want to read in is a flat table, often stored
# as some sort of delimitted file. Delimitting is just a fancy term for saying 
# "using a standard placemarker for separating entries." The two most common
# types of delimitted files in the data world are tab-delimitted and comma-
# delimitted files. Let's start with tab-delimitted (data fields separated by a
# \t or tab) files. Using base R, you import these files with read.table()
read.table("data/usbls_edhcemployment_short.txt")

# For these larger files,you might not want to see all the data every time you 
# call the data object. For this, we can use the same head() function that we 
# used before for vectors and use it for data frames
head(read.table("data/usbls_edhcemployment_short.txt"))

# It looks like our column names didn't get read in correctly. We can fix 
# that with the argument header = TRUE
head(read.table("data/usbls_edhcemployment_short.txt", header = TRUE))

# read.table() works well if you're working with well formatted datasets, but 
# often, either due to formatting issues from upgrading legacy file systems,
# computer error, or just plain laziness, you don't get a clean dataset. Watch 
# what happens when we try to get read.table() to import a file where some rows 
# don't contain the expected number of entries...
head(read.table("data/usbls_edhcemployment.txt", header = TRUE))

# Of course, the tidyverse handles tab-delimitted files with ease, using 
# read_tsv() for tab separated values
read_tsv("data/usbls_edhcemployment.txt")

# Note that we did get a warning because of our number of rows not matching up
# with our number of entries in each row, but instead of throwing an error,
# readr assumed that the value for these elements was NA - R's way of noting
# that you have a missing or unknown value.
#   Sidenote: you don't have to use the head() function with the readr functions
#   because they display the head by default. More on this in a bit...

# We can also read in comma-separated value files, or csv's, using the base R
# function read.csv()
head(read.csv("data/car.csv"))

# Well shoot, the last base R function, read.table() didn't import our headers
# by default when they were there, but now we're having the opposite issue with
# read.csv(). By default, read.csv() expects column names, and so we need to
# explicitly state that we don't have any column names in this file, and that
# our first line contains data
head(read.csv("data/car.csv", header = FALSE))

# Unfortunately, the tidyverse version of this function has this issue, too. So
# it's typically a good idea to always explicitly tell your import function 
# whether or not there are header titles in the file. With the tidyverse import
# functions (all of them), this is done with the argument col_names instead of
# header.
read_csv("data/car.csv")
read_csv("data/car.csv", col_names = FALSE)

# But one nice thing about this col_names argument is that it can also take a
# vector of names, which will rename the columns in the dataset. There is a text
# file in the data folder that contains the names of the columns:
read_lines("data/car-names.txt")

read_csv("data/car.csv", col_names = c("buying", "maint", "doors", "persons", 
                                       "lug_boot", "safety"))

# If you try to do this with the base R function, it doesn't work, which is 
# another added bonus of using the tidyverse function in this case.
head(read.csv("data/car.csv", header = c("buying", "maint", "doors", "persons", 
                                         "lug_boot", "safety")))

# On the off chance that you have a flat file that is not using either commas or
# tabs for delimitting, you can use the read.delim() function in base R or the 
# read_delim() in the tidyverse. In base R, delimitters are defined using the 
# argument sep, and in the tidyverse, you use delim.
read.delim("data/days.txt", sep = " ")

(days <- read_delim("data/days.txt", delim = " "))

# By now, you may have noticed that the functions from the tidyverse are using
# slightly different displays for the data than a typical dataframe. This is 
# because the tidyverse uses a specialized data frame format called the tibble
# (also part of the tidyverse, specifically contained in the package called 
# tibble). A tibble is a class, just like a dataframe, and now is as good
# a time as any to break the news to you: objects in R can have more than one 
# class, because classes can be built from other classes. What this means is 
# that a tibble has the class "tbl" to denote that it is a tibble, and it has
# the class "data.frame" because tibbles are built from data frames. What this
# means is that you can do anything with a tibble that you'd normally do with a 
# data frame, but there is also some added functionality. We'll talk a lot more
# about tibbles tomorrow!
class(days)

#---------------------#
# Complex Local Files #
#---------------------#

# Flat files are great, but the majority of people who use them are other tech
# savvy folks who expect to have to one day read their data into R. But what if
# you're collaborating with or getting data from someone who only uses Excel or
# some other type of specialized data analysis software? Then you'll have to get
# more creative with your imports. It's worth noting here that Excel will let
# you save .xls or .xlsx files as .csv files, so there are other ways around 
# this issue- having R take care of it for you can be easier, though, as you can
# automate your workflow for large batches.

# First, we'll discuss how importing Excel data was done before the tidyverse.
# Importing Excel files has never been part of the base R experience, so there
# have been a variety of packages over the years that have tried to fill this 
# gap. The most popular one was probably gdata, which used Perl script to read 
# Excel files into a format that R could read, and then it read these files into
# R. This will work natively on Macs, but won't on PCs (unless you use Perl).
easypack("gdata")

# The function for reading in Excel data is of the same formula as for base R 
# read functions (read.*()). For Excel files, this equates to read.xls()
read.xls("data/fbicrime.xls")

# However, since development of this package has died down recently, the more 
# up-to-date .xlsx format is not supported by gdata
read.xls("data/crimebyyear_multisheet.xlsx")

# Another noteworthy package that you can use to import Excel files is the more
# recent xlsx. This package uses Java instead of Perl, and R should be able to
# download all the dependencies internally as additional R packages. This means
# it should work on all OS's, but it'll be clunky...
easypack("xlsx")

# Here, the read function is just as you'd expect: read.xlsx()
read.xlsx("data/crimebyyear_multisheet.xlsx") # need to provide a sheet number
read.xlsx("data/crimebyyear_multisheet.xlsx", 1)

# Which brings us to the much easier and more user friendly tidyverse package,
# readxl. This package does not load automatically with the rest of the 
# tidyverse packages since it isn't used quite as often- this means you'll have
# to load it separately.
easypack("readxl")
library("readxl")
# The core function used for importing both .xls and .xlsx files is read_excel()
read_excel("data/fbicrime.xls")

# It looks like there was some data in the first few lines of the Excel file
# before we could get to the real data table. We can have readxl ignore these
# lines with the skip argument.
read_excel("data/fbicrime.xls", skip = 3)

# If working with a multi-sheet Excel document, you can also choose the sheet
# number to import with the sheet argument.
read_excel("data/crimebyyear_multisheet.xlsx", skip = 3)
read_excel("data/crimebyyear_multisheet.xlsx", skip = 3, sheet = 2)

# Of course, Excel isn't the only proprietary data file system out there- there
# are a ton! As a data scientist, one of the more common issues that you're 
# likely to encounter is that a colleague uses SAS for all of their data. SAS is
# a popular enterprise data anaylsis software that many companies use, but it 
# costs money. One way around this in the past was to use the R package foreign 
# for importing the data in a way that R could read.
easypack("foreign")

# The function for reading in data from a SAS format to an R readable format is
# read.ssd(). However, this only works if you have SAS installed on your system.
# I'm guessing you don't, so this is probably out of the question for you...
read.ssd(libname = "data", sectionnames = "gats_india.sas7bdat")

# Enter the tidyverse solution to all your SAS problems, a package called haven.
# Luckily haven uses standalone code to interpret and read SAS data, so this 
# means you'll be able to read the data without needing to install SAS- yay!
library(haven)

# The haven function for importing SAS files is, aptly named, read_sas()
read_sas("data/gats_india.sas7bdat")

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
easypack("RMySQL")
install("RMySQL")
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

db_host <- readline(prompt="Enter host address: ")
db_name <- readline(prompt="Enter database name: ")
db_user <- readline(prompt=paste("Enter username for ", 
                                 db_name, 
                                 ": "))

# This next bit of code looks funky, but it serves a purpose: it gets a password
# from user input, connects to the database specified by other inputs, and wipes
# the password from memory in one continuous string of commands, so that we do
# not forget to remove the password from our system's memory. This is a very
# hacky way to do this, and if you ant to do this in your own code, consider
# using the (mush more refined) R package getPass instead.
db_pass <- readline(prompt=paste("Enter password for ", 
                                 db_user, 
                                 " in ", 
                                 db_name, 
                                 ": ")); 
con <- dbConnect(MySQL(),
                                                          user = db_user,
                                                          password = db_pass,
                                                          host = db_host,
                                                          dbname = db_name
                                                         ); rm(db_pass)



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
# joining related tables, but this all requires more knowledge of SQL. Since
# this is an R course, not a SQL one, we'll keep the discussion fairly basic.

#-------------------#
# Data from the Web #
#-------------------#

# There is so much data on the web that is freely available in some form or
# another. Sometimes, this data is downloadable as a csv or Excel file, but
# often, you'll need to use another approach. A lot of data is provided through
# what are called RESTful APIs- these use a special method for sending data from
# one web address to another. The standard language used by most modern APIs is
# called JSON, which uses JavaScript-like structures to store and send data.
# Many packages in R have been developed to handle JSON, but the most popular
# and versatile is called jsonlite. Although this package isn't officially part
# of the tidyverse, it is referred to as "tidyverse-adjacent" because many of 
# its functions and formats play nicely with the tidyverse.
easypack("jsonlite")
library("jsonlite")
# Some web APIs are completely free and publicly accessible. My favorite among 
# these is the GitHub API, which posts JSON versions of all publicly accessible
# repositories at https://api.github.com/repos - to read more about the GitHub 
# API format, check out https://developer.github.com/v3

# The way to read a JSON file into R is as simple as the function fromJSON() and
# then a string leading to the location of the JSON file. Often, JSON addresses
# will include weird statements and question marks to signal the parameters for
# an API to fetch and return data for. I used the GitHub API here specifially
# because it doesn't do this, so it should be a little less confusing.
(bootcampR_commits <- 
    fromJSON("https://api.github.com/repos/collinmmccabe/bootcampR/commits"))

# We can inspect the structure of the converted JSON object with str()
str(bootcampR_commits)

# And once we have a better sense of what data is available in the returned 
# object, we can use basic data frame lookup notation to get the values we want
# to compare in more detail.
data.frame(bootcampR_commits$commit$author$name, 
      bootcampR_commits$commit$author$email,
      bootcampR_commits$commit$author$date,
      bootcampR_commits$commit$message,
      bootcampR_commits$commit$tree$sha)

# However, most of the time, if a website is providing any sort of data through
# its API, it'll require you to register an account to access the data. The 
# API that we'll be talking about for this example is the Twitter API.
#   Sidenote: If you use someone else's R code, make sure to credit them 
#   somewhere in your comments, especially if your code is publicly accessible,
#   e.g. on GitHub. For this example, much of the code was taken from an Rpubs 
#   user thisisnic at https://rpubs.com/thisisnic/twitter_in_r

# The Twitter API uses a common type of authentication called Oauth. The R 
# package that provides the necessary R functions for authenticating via Oauth
# is httr.
easypack("httr")

# For authentication, we will need 4 things: our consumer key and secret, and 
# our token and token secret.
#   Sidenote: again, don't save sensitive information like passwords and tokens
#   in your R code. There are ways to input your sensitive information securely
#   into R, and if you're interested, check out the Rpubs link above for an 
#   example of how to do this. For now, since this is a Twitter profile that I
#   made just for this course, I'm not too worried about someone stealing my
#   password, but we will still use the hacky solution from before to cover
#   our tracks as much as possible by deleting passwords and objects storing
#   them from our workspace.
# We start by making an Oauth application with our consumer key and secret:
cK <- readline(prompt="Enter your Twitter API consKey: ")
cS <- readline(prompt="Enter your Twitter API consSecret: "); Oauthapp <- 
          oauth_app("twitter", 
                    key=cK, 
                    secret=cS); rm(cK, cS)

# Next, we "sign" the Oauth app with our token and token secret
tk <- readline(prompt="Enter your Twitter API token: ")
tkS <- readline(prompt="Enter your Twitter API tokenSecret: "); signedOauth <-
           sign_oauth1.0(Oauthapp, 
                         token=tk, 
                         token_secret=tkS); rm(tk, tkS, Oauthapp)

# And then we compose the REST command GET to retrieve our data from the Twitter
# API using out signed Oauth application
timeline <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json", 
                signedOauth); rm(signedOauth)

# And we use the httr function content to send this request to Twitter and get a
# JSON file back
json1 <- content(timeline)

# We can then use the jsonlite functions that we just learned in the last 
# example to convert this all into a nice data frame.
(json2 <- fromJSON(toJSON(json1)))

# Finally, a lot of data on the internet doesn't have an accompanying API. This
# data is just sitting there on webpages, with no obvious way to access it.
# it's at this point that we may want to resort to web-scraping: reading over 
# thehtml of a given webpage and looking for specific tags that we can pull out
# and convert to R objects. The tidyverse has a great package for doing just 
# this- it's called rvest, a play on words for the fact that it haRVESTs html 
# web data
easypack("rvest")

# One of the most popular sites to use for web scraping examples is IMDB, due to
# the fact that it is regularly formatted and has much of its data in table-ish
# format. The rvest vignette shows how to do web scraping with the Lego Movie, 
# but we're going to switch to the recent live action remake of Hercules 
# starring Dwayne 'The Rock' Johnson, because DTRJ > anything else. For this, we
# will use the rvest function read_html() with the IMDB address for Hercules.
hercules <- read_html("https://www.imdb.com/title/tt1267297/")

# We will then scrape everything in the id tag titleCast, class tag itemprop,
# and general tag span with html_nodes(), then we will translate to an R data
# object with html_text().
# SelectorGadget
nodes <- html_nodes(hercules, "#titleCast .itemprop span")
cast <- html_text(nodes)

# We'll do the same with roles, too.
nodes2 <-  html_nodes(hercules, "#titleCast .character a")
role <- html_text(nodes2)

# Then we can print this all out to make things look nice
cbind(actor = cast[c(1:8, 10:12)], role = role)

# Now we really have only scratched the surface of data variety that is out 
# there. If you have a special data type that we haven't discussed, start first 
# by using a ?? help search within R to see what exists. If that fails, next try
# a general web search (e.g. Google), or probably more helpful, search within
# StackOverflow's R community (https://stackoverflow.com/questions/tagged/r) for
# an answer to your question.
lst <- c(3,5)
lst[2]
# Exercise from project euler.net 
# Ex.1 sums of multiples of 3 and 5
sums <- function(max_num,multiplelst){
  sumtmp = 0
     for(i in 1:max_num-1){
       division = FALSE
       for (multiple in multiplelst){
         if(i %% multiple==0) {
           division = TRUE 
         }
         }
       if(division) {
         sumtmp = sumtmp + i 
         #print(i)
       } 
     }
  sumtmp
}
sums(1000,c(3,5))

# Ex.2 Even sums of fibonacci sequence
fibonacci_evensums <- function(max_num, startlst){
  sumtmp = 0
  fiboseqtmp = startlst
  for(i in fiboseqtmp){
    if(i %% 2==0){
      sumtmp = sumtmp + i
    }
  }
  fiboseqnext = fiboseqtmp[1]+fiboseqtmp[2]
  while (fiboseqnext < max_num){
    if(fiboseqnext %% 2==0){
      sumtmp = sumtmp + fiboseqnext
    }
    #print(fiboseqnext)
    fiboseqtmp=c(fiboseqtmp[2],fiboseqnext)
    fiboseqnext = fiboseqtmp[1]+fiboseqtmp[2]
  }
  sumtmp
}
fibonacci_evensums(4000000,c(1,2))

# Ex.3 Largest prime factor
largestprimefactor <- function(num){
  num_tmp = num
  factorlist <- list()
  for(i in 2: as.integer(sqrt(num)+1)){
    if(num_tmp <= i & num_tmp != 1){
      factorlist <- c(factorlist,num_tmp)
      break
    }
    else if(num_tmp %% i ==0){
      while(num_tmp %% i ==0){
      num_tmp = num_tmp/i
      }
      factorlist <- c(factorlist,i)
    }
  }
  if(length(factorlist)  == 0) {
    factorlist <- c(factorlist,num_tmp)
  }
  #num_tmp
  factorlist
}
largestprimefactor(13195)
largestprimefactor(600851475143)
largestprimefactor(6857)
largestprimefactor(20)
largestprimefactor(9)

##############################
# test code for Ex. 4
test_lst <- as.numeric(strsplit(as.character(6857),"")[[1]])
test_lst[1]
test_lst[4-1+1]
str(c(test_lst))
str(c(test_lst)[1])
isPalindrome <- function(lst){
  len <- length(lst)
  #print(len)
  ispalindrome <-TRUE
  for (ind in 1:(len%/%2)){
    if (lst[ind] != lst[len-ind+1]){
      ispalindrome <- FALSE
      break
    }
  }
  ispalindrome
}
isPalindrome(test_lst)
# end of test code for Ex. 4
##############################

# Ex. 4 Largest palindrome product
largestpalindromefromprod <- function(num1_max,num2_max){
  findnum <- 0
  prod_tmp_largest <- 11
  i_lst <- list()
  j_lst <- list()
  prod_tmplst <- list()
  for(i in rev(max(c(60,num1_max%/%10)):num1_max)){
    for(j in rev(i:num2_max)){
      prod_tmp <- i*j
      # check the product to be palindrome or not
      prod_tmp_digits <- as.numeric(strsplit(as.character(prod_tmp),"")[[1]])
      isPalindrome <- function(lst){
        len <- length(lst)
        ispalindrome <-TRUE
        for (ind in 1:(len%/%2)){
          if (lst[ind] != lst[len-ind+1]){
            ispalindrome <- FALSE
            break
          }
        }
        ispalindrome
      }
      if(isPalindrome(prod_tmp_digits)){
        i_lst <- c(i_lst,i)
        j_lst <- c(j_lst,j)
        #print(c(i,j))
        #print("Find the largest palindrome from a product of two numbers: ")
        #print(prod_tmp)
        if(prod_tmp > prod_tmp_largest){
          prod_tmp_largest <- prod_tmp
          largest_pair <- c(i,j,prod_tmp)
        }
        prod_tmplst <- c(prod_tmplst,prod_tmp)
        findnum <- findnum + 1
        #break
      }
      
    }
  }
  #prod_tmplst
  largest_pair
}

res <- largestpalindromefromprod(999,999)
res
largestpalindromefromprod(999,999)
largestpalindromefromprod(99,99)
!FALSE
# Ex. 5 Smallest multiple
powercontain <- function(bignumber,smallnumber){
  if (smallnumber > as.integer(sqrt(bignumber))+1){
    num_power <- 1 
  }
  else {
    num_power <- 1
    powers_tmp <- smallnumber
    while(powers_tmp < bignumber){
      num_power <- num_power + 1
      powers_tmp <- powers_tmp * smallnumber
    }
    num_power <- num_power -1
  }
  num_power
}
powercontain(20,5)
smallest_multiple <- function(start,end){
  factorlist <- list()
  prod <- 1
  for ( i in start:end){
    primefact_tmp = largestprimefactor(i)
    print(i)
    print(primefact_tmp)
    for (value in primefact_tmp){
      if(!(value %in% factorlist)){
        prod <- prod*value^powercontain(end,value)
        factorlist <- c(factorlist,value)
      }
    }
  } 
  prod
}
smallest_multiple(2,20)

# Ex. 6 sum square difference
sumsqdiff <- function(start,end){
  sumsq <- 0
  sqsum <- 0
  for (i in start:end){
    sumsq <- sumsq + i
    sqsum <- sqsum + i^2
  }
  sumsq <- sumsq ^2
  sumsq - sqsum
}
sumsqdiff(1,10)
sumsqdiff(1,100)

# Ex 7. 10001st prime
nthprime <- function(nth){
  
}
