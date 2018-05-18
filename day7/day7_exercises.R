################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#               Day 7 - Summary Statistics and Data Vizualization              #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# We are going to wrap up our tour of dplyr with the summarize and group_by
# functions. The reason I've saved those for today is that they transition 
# really nicely into out other topic of data visualization. These last bits of
# dplyr goodness are at found in the same chapter of R4DS that we used yesterday
# (http://r4ds.had.co.nz/transform.html#grouped-summaries-with-summarise)
library(tidyverse)
library(dplyr)

#----------#
# Group by #
#----------#

# Today, we'll just go over the default help page in R for group_by below:

by_cyl <- mtcars %>% group_by(cyl)

# grouping doesn't change how the data looks (apart from listing
# how it's grouped):
glimpse(by_cyl)

# It changes how it acts with the other dplyr verbs:
by_cyl %>% summarise(
  disp = mean(disp),
  hp = mean(hp)
)
by_cyl %>% filter(disp == max(disp))

# Each call to summarise() removes a layer of grouping
by_vs_am <- mtcars %>% group_by(vs, am)
by_vs <- by_vs_am %>% summarise(n = n())
by_vs
by_vs %>% summarise(n = sum(n))

# To removing grouping, use ungroup
by_vs %>%
  ungroup() %>%
  summarise(n = sum(n))

# You can group by expressions: this is just short-hand for
# a mutate/rename followed by a simple group_by
mtcars %>% group_by(vsam = vs + am)

# By default, group_by overrides existing grouping
by_cyl %>%
  group_by(vs, am) %>%
  group_vars()

# Use add = TRUE to instead append
by_cyl %>%
  group_by(vs, am, add = TRUE) %>%
  group_vars()

#-----------------------#
# Summarise / Summarize #
#-----------------------#

# Also just the text of the default help page for summarise/summarize below

# A summary applied to ungrouped tbl returns a single row
mtcars %>%
  summarise(mean = mean(disp), n = n())

# Usually, you'll want to group first
mtcars %>%
  group_by(cyl) %>%
  summarise(mean = mean(disp), n = n())

# Each summary call removes one grouping level (since that group
# is now just a single row)
mtcars %>%
  group_by(cyl, vs) %>%
  summarise(cyl_n = n()) %>%
  group_vars()

# Note that with data frames, newly created summaries immediately
# overwrite existing variables
mtcars %>%
  group_by(cyl) %>%
  summarise(disp = mean(disp), sd = sd(disp))

# Have to switch to...
mtcars %>%
  group_by(cyl) %>%
  summarise(sd = sd(disp), disp = mean(disp))


### 5.6.7 EXERCISE 5 ###
library(nycflights13)
View(flights)

#Which carrier has the worst delays?
flights %>%
  filter(!is.na(dep_delay)) %>% 
  group_by(carrier) %>%
  summarise(dep_delay = mean(dep_delay)) %>%
  arrange(desc(dep_delay))

flights %>%
  filter(!is.na(dep_delay), dep_delay > 0) %>% 
  group_by(carrier) %>%
  summarise(dep_delay = mean(dep_delay)) %>%
  arrange(desc(dep_delay))

#Worst by origin...
flights %>%
  filter(!is.na(dep_delay), dep_delay > 0) %>% 
  group_by(origin) %>%
  summarise(dep_delay = mean(dep_delay)) %>%
  arrange(desc(dep_delay))

#-----------------------#
# Plotting with ggplot2 #
#-----------------------#

# When it comes to making graphs with the tidyverse, there is no better resource
# than the 'Cookbook for R' by Winston Cheng (there is also a similar cookbook
# made exlusively for graphics, that one is maybe even better). There are many
# great tutorials for using the tidyverse for making ggplot2 (the tidyverse
# plotting package) plots at the corresponding website, located at
# (http://www.cookbook-r.com/Graphs/) - We'll work through some of these 
# examples in class today
library(ggplot2)

diamonds %>%
  ggplot(mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

#Can also do...
diamonds %>%
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

diamonds %>%
  filter(price < 11000) %>%
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot() +
  coord_flip()

diamonds %>%
  filter(price < 11000) %>%
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot() +
  coord_flip(

CO2 %>%
  filter(conc == 1000) %>%
  group_by(Treatment, Type) %>%
  summarize(mean = mean(uptake), sd = sd(uptake)) %>%
  ggplot(mapping = aes(x = Treatment, y = mean, fill = Type)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), position = position_dodge())

# other additional aes args: color, size, shape, alpha
CO2 %>%
  filter(conc == 1000) %>%
  group_by(Treatment, Type) %>%
  summarize(mean_CO2 = mean(uptake), sd = sd(uptake)) %>%
  ggplot(mapping = aes(x = Treatment, y = mean_CO2, fill = Type)) +
  geom_bar(stat = "identity")

CO2 %>%
  filter(conc == 1000) %>%
  group_by(Treatment, Type) %>%
  summarize(mean_CO2 = mean(uptake), sd = sd(uptake)) %>%
  ggplot(mapping = aes(x = Treatment, y = mean_CO2, fill = Type)) +
  geom_bar(stat = "identity", position = position_dodge())

### EXERCISE 3.7.1 #2 ###






### 3.3.1 EXERCISE 4 ###


diamonds %>%
  ggplot(aes(x = carat, y = price, color = color), size = .01) +
  geom_point()

### EXERCISE 3.2.4 #4 ###

datasets::attitude %>% 
  ggplot(aes(x = raises, y = rating)) + 
  geom_point() + 
  geom_smooth()

datasets::attitude %>% 
  ggplot(aes(x = raises, y = rating)) + 
  geom_point() + 
  geom_smooth(method = "lm")

### 3.6.1. EXERCISE 3 ###

ChickWeight %>%
  ggplot(mapping = aes(x = Time, y = weight, color = Diet)) +
    geom_smooth()

ChickWeight %>%
  filter(Diet == 1) %>%
  ggplot(mapping = aes(x = Time, y = weight, color = Chick)) +
  geom_line()

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

### Exercise 3.5.1 #3 ###


install.packages("maps")
library(maps)
ggplot(map_data("state", region = "ohio"), aes(long, lat, group = group)) +
  geom_polygon(fill = "gray", colour = "red") +
  coord_quickmap()

# Of course, as ggplot2 is a part of the tidyverse, R4DS contains a lot of spot-
# on advice on how to do everything in ggplot2, as well as explaining the how
# and why of everything going on there. The specific link to the ggplo2 chapter:
# (http://r4ds.had.co.nz/data-visualisation.html)

# Another great resource for ggplot2 is STHDA - their ggplot2 tutorials are at:
# (http://www.sthda.com/english/wiki/ggplot2-essentials)
