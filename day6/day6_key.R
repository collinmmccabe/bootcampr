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

#--------#
# Filter #
#--------#

# Filtering can be done with base R, but it is pretty verbose...
flights[(flights$month == 1 & flights$day == 1), ]

# Instead, you can do this in the tidyverse with the dataset as the first 
# argument, and then the rest of the filtering conditions (without df_name$)
# as the rest of the arguments. Using the comma between arguments implies &
filter(flights, month == 1, day == 1)

# If you want to use an or relationship, so not separate your conditions and 
# just include the |
filter(flights, month == 11 | month == 12)
filter(flights, month %in% c(11, 12))

### TRY 5.2.4 EXERCISE 1.4 ###



filter(flights, month >= 7, month <= 9)

filter(flights, between(month, 7, 9))

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



arrange(flights, desc(dep_delay))

arrange(flights, dep_time)

#--------#
# Select #
#--------#

# Selecting is similar to the base R concept of subsetting via index or name
flights[c("year", "month", "day")]

# If you list multiple items, you will select all of them
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

# You can also use special search functions to find all variables that match a 
# given condition
select(flights, starts_with("arr_"))
select(flights, ends_with("delay"))
select(flights, contains("time"))

# If you want to rename a coulmn in base R, you have to list every other column
cbind(flights[1:11], tail_num = flights$tailnum, flights[13:19])

# But in dplyr, rename automates the boring work
rename(flights, tail_num = tailnum)

# If you want to include everything, you need to exhaustively list the columns
# when using base R subsetting
flights[c(19, 15, 1:14, 16:18)]

# But not with dplyr, just use the everything() function
select(flights, time_hour, air_time, everything())

### TRY 5.4.1 EXERCISE 1 ###



select(flights, dep_time, dep_delay, arr_time, arr_delay)

select(flights, starts_with("dep"), arr_time, arr_delay)

select(flights, dep_time, dep_delay, starts_with("arr"))

select(flights, starts_with("dep"), starts_with("arr"))

# Not this, too many other _time variables
select(flights, ends_with("time"), ends_with("delay"))

# Could do this though...
select(flights, ends_with("time"), ends_with("delay"),
       -starts_with("sched"), -starts_with("air"))

# Or some combination of this and earlier statements
select(flights, starts_with("dep"), ends_with("delay"), arr_time)

select(flights, starts_with("arr"), ends_with("delay"), dep_time)

# And the list goes on...

#--------#
# Mutate #
#--------#

# Adding new columns wioth new data in data frames in base R requires $ notation
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

### TRY 5.5.2 EXERCISE 1 ###



mutate(flights,
       dep_time_mins = dep_time %/% 100 * 60 + dep_time %% 100,
       sched_dep_time_mins = 
         sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %>%
  select(dep_time, dep_time_mins, sched_dep_time, sched_dep_time_mins)

#-------#
# Pipes #
#-------#

# Stores an unnecessary intermediate dataset in memory!
dest_groups <- group_by(flights, dest)
no_pipe_popular_dests <- filter(dest_groups, n() > 365)

# Hard to read!
one_liner_popular_dests <- filter(group_by(flights, dest), n() > 365)

# Break up each dplyr "verb" so that each is on it's own line
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)

# These pipes work so well because the entire package was designed with them in
# mind: the first argument of every "verb" is always a dataset (as a tibble)
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

### TRY 5.7.1 EXERCISE 4 ###



flights %>%
  filter(!is.na(arr_delay), arr_delay > 0) %>%  
  group_by(dest) %>%
  mutate(total_delay = sum(arr_delay),
         prop_delay = arr_delay / sum(arr_delay))
