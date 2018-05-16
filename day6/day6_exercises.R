################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                      Day 6 - Data Manipulation with dplyr                    #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# All examples in this session are taken directly from Garrett Grolemund and 
# Hadley Wickham's online book, R for Data Science, specifically, the chapter on
# Data Transformation (http://r4ds.had.co.nz/transform.html). We will be
# referring to this material throughout lecture today.

# First, we will of course load the tidyverse package dplyr, as well as install
# and load the example data, which comes in a separate package, nycflights13
library(dplyr)
install.packages("nycflights13")
library(nycflights13)

View(flights)

#typing ?flights in the console below gets us a help window on the right that tells us how to
#interpret the various headings

#flights was imported as a tibble

#--------#
# Filter #
#--------#

# Filtering can be done with base R, but it is pretty verbose...
flights[(flights$month == 1 & flights$day == 1), ]

#this command pulls ONLY the rows for flights on Jan 1st

#notice that negative numbers are highlighted in red in the console

# Instead, you can do this in the tidyverse with the dataset as the first 
# argument, and then the rest of the filtering conditions (without df_name$)
# as the rest of the arguments. Using the comma between arguments implies &
filter(flights, month == 1, day == 1)

# If you want to use an or relationship, so not separate your conditions and 
# just include the |
filter(flights, month == 11 | month == 12)
filter(flights, month %in% c(11, 12))

# %in% finds the range in the range of something, inputted as a string.

### TRY 5.2.4 EXERCISE 1.4 ###

#1a

filter(flights, arr_delay >= 2)

#1b

filter(flights, dest %in% c(IAH,HOU))

#1d

filter(flights, between(month, 7, 9))

#the between function checks a value for a column (in this case month) in the range of 7 and 9

#recall && ONLY checks the first entry in a data set, in this case a row


# Answers to R4DS exercises were taken from Jeffrey Arnold's solutions website 
# (https://jrnold.github.io/r4ds-exercise-solutions/data-transformation.html)
# and sometimes were adapted or supplemented by me

#---------#
# Arrange #
#---------#

# Arranging is a way to implement the sort() function for a column across an
# entire data frame (tibble); simialr to the sort + expand selection option
# with Excel, if you're familiar with this
sort(flights$arr_delay)

# Arrange sorts by default from smallest to largest
arrange(flights, arr_delay)

# If you list multiple arrange arguments, items will be listed first in 
# ascending order of the first column listed, then within each set of equal 
# values for that column, the data will be sorted by the second column, etc.
arrange(flights, year, month, day)

# You can reverse the order so that items are sorted from largest to smallest by
# using the desc() function in the argument.
arrange(flights, desc(arr_delay))

### TRY 5.3.1 EXERCISE 2 ###
# Sort flights to find the most delayed flights. Find the flights that left earliest.

arrange(flights, desc(dep_delay))

#earliest, i.e. ahead of schedule:
arrange(flights, dep_delay)

#flights leaving earliest in the day.
arrange(flights, dep_time)


#--------#
# Select #
#--------#

# Selecting is similar to the base R concept of subsetting via index or name
flights[c("year", "month", "day")]

# If you list multiple items, you will select all of them
select(flights, year, month, day) # does the same thing as the immediately preceding function
select(flights, year:day) # does the same thing as the immediately preceding function, selects in range
# note, you can't do this kind of thing without the select command like in line 113
select(flights, -(year:day)) #omits that range of columns

# You can also use special search functions to find all variables that match a 
# given condition
select(flights, starts_with("arr_"))
select(flights, ends_with("delay"))
select(flights, contains("time"))

# If you want to rename a column in base R, you have to list every other column
cbind(flights[1:11], tail_num = flights$tailnum, flights[13:19])

#we changed the name of tailnum to tail_num

# But in dplyr, rename automates the boring work
rename(flights, tail_num = tailnum)

# If you want to include everything, you need to exhaustively list the columns
# when using base R subsetting
flights[c(19, 15, 1:14, 16:18)]

# But not with dplyr, just use the everything() function
select(flights, time_hour, air_time, everything())

#recognizes names of columns, everything() is smart enough to recognize everything else - it never duplicates
# what we've done is put time_hour and air_time as our first two colummns

### TRY 5.4.1 EXERCISE 1 ###

select(flights, dep_time, dep_delay,arr_time, arr_delay, everything())

select(flights, starts_with("arr"), starts_with("dep"))

select(flights, ends_with("time"), ends_with("delay"), ends_with("delay"), -starts_with("sched"), -starts_with("air"))


#--------#
# Mutate #
#--------#

# Adding new columns with new data in data frames in base R requires $ notation
cbind(flights, 
      gain = flights$arr_delay - flights$dep_delay,
      speed = flights$distance / flights$air_time * 60)

# But not dplyr, just write names of columns
mutate(flights, 
       gain = arr_delay - dep_delay, 
       speed = distance / air_time * 60
       )

# You can also use generated variables to compute other variables in the same 
# call to mutate()
mutate(flights,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# And if you just want to get back your calculated columns, use transmute()
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# to include another column, just add on the name of that column into this list; for example:

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours,
          arr_time
)


### TRY 5.5.2 EXERCISE 1 ###

mutate(flights, 
       dep_min_since_midnight = dep_time %% 100 + (dep_time%/%100)*60)

transmute(flights, 
       dep_min_since_midnight = dep_time %% 100 + (dep_time-dep_time%%100)*5/3)
# This doesn't work the way we want. The right way is below.

transmute(flights, 
          dep_min_since_midnight = dep_time%%100 + (dep_time%/%100)*60)

# first pipe, introduction denoted by %>%

mutate(flights, 
          dep_min_since_midnight = dep_time%%100 + (dep_time%/%100)*60) %>%
  select(dep_time, dep_min_since_midnight)



#-------#
# Pipes #
#-------#

# Stores an unnecessary intermediate dataset in memory!
dest_groups <- group_by(flights, dest)
no_pipe_popular_dests <- filter(dest_groups, n() > 365)

# Hard to read!
one_liner_popular_dests <- filter(group_by(flights, dest), n() > 365)

#stores dest_groups in memory. Inefficient!

# Break up each dplyr "verb" so that each is on its own line
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)

#group_by has flights fed into it. 

#basically a for loop for every destination. We then filter the destinations appearing in more than 365 rows.
# We will only keep those rows.

# These pipes work so well because the entire package was designed with them in
# mind: the first argument of every "verb" is always a dataset (as a tibble)
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

#filters the rows with a positive arrival delay, adds new column with proportional delays, then prints the table
# with only the selected columns into the console.

### TRY 5.7.1 EXERCISE 4 ###

#For each destination, compute the total minutes of delay. 
#For each flight, compute the proportion of the total delay for its destination.

flights %>%
  filter(!is.na(arr_delay), arr_delay>0) %%
  group_by(dest) %>%
  mutate(total_delay = sum(arr_delay),
         prop_delay = arr_delay/sum(arr_delay))


