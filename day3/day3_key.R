################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                      Day 3 - Conditionals & Control Flow                     #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

#--------------#
# Conditionals #
#--------------#

# Booleans, or as R calls them, "logicals" are some of the simplest but most
# powerful tools that data scientists can use. They're typically applied to 
# binary problems: e.g. if this, do something; if not, do something else. These
# objects can either be assigned at initialization, as we've done so far, or
# they can be calculated by doing some sort of comparison, which is arguably
# much more useful. The comparison operators come in a variety of flavors:
1 < 2  # Less than
1 > 2  # Greater than
1 <= 2  # Less than or equal to
1 >= 2  # Greater than or equal to
1 == 2  # Equal to (remember that a single "=" is an assignment operator)
1 != 2  # Not equal to

# Typically, you'll only want to compare data of similar classes (unless you
# really know what you're doing). The comparison operators will (sometimes)
# work to compare disparate classes
1L == TRUE
0L == FALSE

1.0 == TRUE
2.0 == FALSE

1L == 1.0
"1" == 1

# However, the general idea of "truthy-ness" as implemented in Python doesn't
# really carry over into R (empty strings are not FALSE, strings with something
# in them are not TRUE)
"test" == TRUE

# These comparisons can be combined into more complex conditions using the
# logical operators "not", and", "or", and "xor":

# "not" only evaluates to true if the condition being operated on is false;
# "not" is represented in R using the "!" (in computer speak, this is a "bang")
!(1 > 2)

# "and" only evaluates to true if both of two joined conditions are true; "and"
# is represented in R using the "&", but can vary in it's application as either
# a single "&" or double "&&" - the difference being that the single "&" 
# compares two items element-wise (which can be useful for comparing vectors), 
# while the double "&&" only evaluates the first statement of each condition
# (which is preferable when dealing with single booleans for control flow)
vec1 <- c(1, 2, 3, 4, 5, 6)
vec2 <- c(3, 4, 4, 5, 6, 8)

(vec1 %% 2 == 0) & (vec2 %% 2 == 0)  # for which elements are both values even?

(2 < 3) && (3 >= 3)  # comparison of single value booleans with double "&&"

# Both the single and double "and" can be concatenated indefinitely
(1 < 2) && (2 < 3) && (3 < 4) && (4 < 5)

# "or" evaluates to true if either or both of two joined conditions are true;
# "or" is represented in R using the "|" and "||". Just like with "and", the 
# difference is that the single "|" compares two items element-wise, while the 
# double "||" only evaluates the first statement of each condition

(vec1 %% 2 == 0) | (vec2 %% 2 == 0)  # for which elements are either value even?

(2 < 3) || (3 > 3)  # comparison of single value booleans with double "||"

# The real power of the double logical operator is that it will immediately stop
# calculating a condition once it has enough information to determine one way or
# another, which means that this:
FALSE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE
# ...will evaluate to FALSE faster than this will:
TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || TRUE || FALSE

# Finally, "xor",  or "exclusive or" evaluates to true only if one or the other 
# of two joined conditions are true, but not if both are; it is calculated with
# the function xor()
xor(TRUE, FALSE)
xor(TRUE, TRUE)

# Logicals can come in really handy for slicing and subsetting arrays on a
# certain condition
vec1[vec1 %% 2 == 0]

# The same can be done with matrices, dataframes, lists, etc. But one neat thing
# that you can do for subsetting dataframes is to subset one column based on the
# conditions of another column
mtcars
mtcars$mpg[mtcars$cyl == 8]

# And you can even subset an entire dataframe from a conditional on its columns

mtcars[mtcars$am > 0, ]

# Using sum() in conjunction with conditionals is also a good way to implement a
# conditional counting function in R, since TRUE == 1, summing the vector of
# logicals is the same as counting all the TRUEs
sum(vec1 %% 2 != 0)

#---------------#
# If Statements #
#---------------#

# If statements are one of the best ways in any programming language to execute
# binary tasks: if something is true, do something, if not, do something else...

# Let's start with "if something is true, do something"- in R, this is executed
# with the following syntax:
#   Note: the "if", the parentheses, and the curly braces are necessary for an
#   if statement in R; the space after if is not, but it is best practice...
x <- 2
if (x %% 2 == 0) {
  print("x is even")
}

# You can also evaluate an if statement on a more complicated conditional
#   Note: you should use double conditional operators for if statements, as they
#   will evaluate more efficiently
#     Best practice: wrap your individual conditions in parentheses
y <- 6
if ((y %% 2 == 0) && (y %% 3 == 0)) {
  print("Your number is even and divisible by three")
}

# To make the evaluation of our if statements more fun, we can turn our if
# statements into functions that will take input from you. To do this, we will 
# use the function readline(); however, this returns a string:
(x <- readline("Type a number: "))

# So we'll have to coerce the type to an integer
class(as.integer(readline("Let's try that again: ")))

# Great! I'll give you the skeleton for the function so that you won't have to 
# do an insane amount of typing each time
if_statement <- function() {
  x <- as.integer(readline("Type a number: "))
  
  if (x > 10) {
    print("Your number is greater than ten")
  }
}

if_statement()

# Now let's add in directions for what R should do if the condition evaluates to
# FALSE- this is done with an else statement: it should be on the same line as 
# the closing curly brace of the if statement and will not have a condition of 
# its own, but it will still be followed by a curly brace telling it what to do

ifelse_statement <- function() {
  x <- as.integer(readline("Type a number: "))
  
  if (x > 10) {
    print("Your number is greater than ten")
  } else {
    print("Your number is ten or less")
  }
}

ifelse_statement()

# But what if we want to get more specific with our if else statements? What if
# we want to check another condition if the first one is false, but before we 
# give up and default to our FALSE answer? That's where the else if statement
# comes in. It is essentially a combination of an else statement followed by an
# if statement, but before the curly braces.

ifelseifelse_statement <- function() {
  x <- as.integer(readline("Type a number: "))
  
  if (x > 10) {
    print("Your number is greater than ten")
  } else if (x >= 5) {
    print("Your number is between five and ten")
  } else {
    print("Your number is less than five")
  }
}

ifelseifelse_statement()

# If else statements can be concatenated pretty much indefinitely (just make
# sure that your conditions are logically distinct or mutually exclusive...)

ifelseifelse_long_statement <- function() {
  x <- as.integer(readline("Type a number: "))
  
  if (x >= 10) {
    print("Your number is at least 10")
  } else if (x >= 9) {
    print("Your number is between 9 and 9.99999...")
  } else if (x >= 8) {
    print("Your number is between 8 and 8.99999...")
  } else if (x >= 7) {
    print("Your number is between 7 and 7.99999...")
  } else if (x >= 6) {
    print("Your number is between 6 and 6.99999...")
  } else if (x >= 5) {
    print("Your number is between 5 and 5.99999...")
  } else if (x >= 4) {
    print("Your number is between 4 and 4.99999...")
  } else if (x >= 3) {
    print("Your number is between 3 and 3.99999...")
  } else if (x >= 2) {
    print("Your number is between 2 and 2.99999...")
  } else if (x >= 1) {
    print("Your number is between 1 and 1.99999...")
  } else {
    print("Your number is less than 1")
  }
}

ifelseifelse_long_statement()

# A useful shorthand for if else statements is the one-line function ifelse()
# - Look up the help page to learn about how to structure the statement
?ifelse
ifelse(y >= 6, "at least 6", "less than 6")

#-------#
# Loops #
#-------#

# Loops are a programmatic way to have R do something over and over again. This
# can be very useful if you have more complicated operations that you need to
# do on vectors or sequences of numbers than a typical element-wise operation
# can handle.

# The first loop that we'll discuss is called a while loop; the name comes from
# the fact that we do something while something else is TRUE. So, essentially, 
# these are iterative versions of the if statements that we discussed earlier.

# The first step for working with many types of loops is to define an iterator:
# in our case, we will call it i - let's set it to 1 to start
i <- 1

# Next, we will write the while loop to do something while our iterator meets 
# a certain condition; when working with iterators, you must increment the 
# iterator within the loop. This loop will add 1 to the iterator for each time
# it runs through the loop, then it will start again at the while line
while (i < 10) {
  print("i is less than 10")
  i <- i + 1
}

# Two common mistakes that are made when working with loops are that either:
# You forget to increment your iterator (leading to an infinite loop)
i <- 1
while (i < 10) {
  print("i is less than 10")
}

# Or, your condition will never evaluate to FALSE (also an infinite loop)
i <- 1
while (i < 10) {
  print("i is less than 10")
  i <- i - 1
}

# You can nest if/else statements within loops to further control their behavior
#   Best Practice: empty lines between statements can help with reading long fxn
i <- 1
while (i < 10) {
  print("i is less than 10")
  
  if (i > 5) {
    print("...but greater than 5")
  }
  
  i <- i + 1
}

# You can also use if/else statements to control the flow of your loop (whether
# or not a certain iteration of a loop or the entire loop continue to evaluate).
# You do this with the special statements break (which ends a function), and 
# next (which skips the current iteration and goes to the next one in the loop)
i <- 1
while (i < 10) {
  
  if (i %% 2 == 1) {
    print("i is odd; specifically, it is:")
    i <- i + 1
  } else if (i == 8) {
    print("i is equal to 8, so I'm quitting")
    break
  } else {
    i <- i + 1
    next
  }
  
  print(i)
}

# You can also build the condition in the first line of the while statement into
# the last line of your loop, so that it evaluates at the end instead of the
# beginning of each iteration. Some languages refer to this as a do-while loop, 
# but in R it is called a repeat loop- just a different way to do the same thing
i <- 1
repeat {
  print("i is less than 10")
  i <- i + 1
  
  if (i > 10) {
    break
  } 
}

# One of the more flexible loops in R's repertoire is called the for loop. It
# iterates over all items in a sequence and does something with each item in
# that sequence. After each item is evaluated in the loop, the code 
# automatically proceeds to the next item, and the loop ends when it reaches the
# end of the sequence.
s <- c(1, 3, 5, 7, 9)
for (x in s) {
  print(x)
}

# You can have R generate sequences using a variety of methods- here are a few:

# The colon (:) is the simplest way to generate a sequence, it will produce a 
# vector of all integers (no need to coerce or use the capital L notation) from 
# the number before the colon to the number after it
1:50
class(1:50)

# seq() will generate a sequence of numerics (even if they look like integers)
# from the from argument to the to argument, incremented by the by argument
seq(from = 0, to = 50, by = 5)
class(seq(from = 0, to = 50, by = 5))

# Finally, the rep() argument will repeat a given value times argument times
rep(TRUE, times = 20)

# You can use any of these functions in combination with the c() function to 
# make more complicated vectors
(iterable <- c(0:9, rep(10, times = 10), seq(from = 20, to = 100, by = 10)))

# And your iterator, in the case of the below loop, i, can be anything. You 
# don't need to worry about it conflicting with other items in your environment,
# although it is probably best to name your iterator something unique
for (i in iterable) {
  print(i)
}

# You can also iterate over an object using indices instead of iterating over
# the items automatically
for (i in 1:length(iterable)) {
  print(iterable[i])
}

# You can loop over quite a lot of different structures in R: vectors (as we've 
# already done), matrices (if you just put the matrix name as the iterable, it
# will proceed from [1, 1] all the way to [nrow(matrix), ncol(matrix)], by 
# column), and lists (if you just use a list as the iterable, it will loop over 
# all of the primary indices, the first [[]] numbers)
for (x in matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3, byrow = TRUE)) {
  print(x)
}

my_list <- list(c(1, 2, 3), c("A", "B", "C"), c(TRUE, FALSE, TRUE))
for (item in my_list) {
  print(item)
}

# Looping over data frames requires a bit more creativity. First, you could just
# choose a single column to loop over:
for (it in mtcars$mpg) {
  print(it)
}

# Another way to iterate through dataframes is to use nested for loops for the 
# row dimension and the column dimension (this sort of nested for looping can 
# also be used to navigate matrices and complex lists). You can make this happen
# row by row by putting the rows in the outside for loop:
for (i in 1:nrow(mtcars)) {
  for (j in 1:ncol(mtcars)) {
    print(mtcars[i, j])
  }
}

# ...or column by column by having columns in the outside for loop:
for (j in 1:ncol(mtcars)) {
  for (i in 1:nrow(mtcars)) {
    print(mtcars[i, j])
  }
}

# We can also print the name of each column by adding in an if statement, too
for (j in 1:ncol(mtcars)) {
  for (i in 1:nrow(mtcars)) {
    if (i == 1) {
      print(colnames(mtcars[j]))
    }
    print(mtcars[i, j])
  }
}

#---------------------#
# Functions Revisited #
#---------------------#

# One of the best ways to make your function easy to use but also flexible and 
# customizable is to use default arguments. These are arguments that have names
# and also assigned values in the initialization line of the function. We will
# do a simple example where a function will print out every other item in a
# vector by default, but can be changed to print out every 3rd, 4th, 5th, etc
every_other <- function(v, by = 2) {
  i <- 1
  while (i < length(v)) {
    print(v[i])
    i <- i + by
  }
}

every_other(1:20)
every_other(1:20, by = 3)

# anonymous functions
(function(x) paste(x, "is the meaning of life"))("R")

# A useful shorthand for the for loop structure is the function sapply()
sapply(10:1, function(x) paste(x, "bottles of beer on the wall,", x, "bottles of beer. Take one down, pass it around,", x-1, "bottles of beer on the wall"))
?sapply
