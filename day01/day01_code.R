################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                                Day 1 - Basics                                #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# A git refresher from last class:

# After I've made changes to course material, you need to first check and see
# what has changed on my master branch; you can do this with:
system('git checkout master')
system('git fetch origin')

# Then, we can actually download these changes with:
system('git pull')

# But all of the changes that I will make will be going directly into the master
# branch, which is kindaq off limits to all of you (for safety purposes).
# To incorporate my changes, let's first make sure that you're in your branch:
system('git checkout student/<your-github-username>')

# And then we'll merge master into your current branch
system('git merge master')

# Et voila, you have the newest version of the course materials :)
# ...once you email me your GitHub username, I will add you as a collaborator,
# and then you'll be allowed to 'push' your own changes on your 'local' branch 
# up to a 'remote' version of your branch on my repo (kinda like saving it to
# the cloud); NB: '-u' tells git to make an upstream branch
system('git push -u origin student/<your-github-username>')

#------------------------------------------------------------------------------#

# The MOST IMPORTANT thing about writing code is to comment it with descriptions
# of what each portion of code does, not only for your own sanity when
# revisiting code, but also to allow others who may use your code to make sense
# of it. R will ignore lines that start with a pound sign/"hashtag" as comments

"Otherwise, R will run each line in order within your file"

# You can write code and run it directly from within R or RStudio (Ctrl+Enter),
# or you can run code from R scripts by using the function source()
source("welcome.R")

# But this won't work until we are in the same directory (folder) as the file...
# First, let's find out where we are. If you're familiar with any *-nix OS,
# you'll probably know how to print your current working directory: pwd
#   Sidenote: in R, you need to follow most functions with parentheses,
#   although sometimes you won't need to put anything in these parentheses
pwd()

# Looks like that's not a function, let's look at the help page (?) for this
?pwd

# There's nothing exactly called pwd(), so let's use search-within help (??)
# The following doesn't work in windows, use Help window to search
??wd

# OK, it's actually called getwd(), so let's try that
getwd()

# I forgot- I put the welcome script within the folder "Welcome/", setwd() there
#   Sidenote: in RStudio, as you're typing filenames, you can use tab-completion
setwd("F:/Gitfolder/bootcampr/day01/welcome/")
getwd()

# If you're not a fan of doing things through the command line/script (soon you
# will be), there are GUI ways to do this, too: choose.dir
setwd(choose.dir())

# Now we can finally run my welcome script!
source("welcome.R")

# Just like you can use a GUI to choose a folder, you can do the same for files
source(choose.files())

# Alright, now that we're done with that, let's go back to the parent directory
setwd("../")

#------#
# Math #
#------#

# At it's heart, R is just a big calculator...

# Addition
1 + 2

# Subtraction
2 - 1

# Multiplication
2 * 3

# Division
4 / 2

# Exponents
3 ^ 2

# Modulo (a.k.a. Remainder)
5 %% 2

# Integer (Floor) Division
5 %/% 2

# Order of Operations:
# 1. Exponents (right to left)
# 2. Modulo (left to right)
# 3. Multiplication & Division (left to right)
# 4. Addition & Subtraction (left to right)
8 + 16 * 2 / 4 ^ 2 %% 3

# You can alter the order of operations with parentheses
((8 + 16) * 2 / 4) ^ (2 %% 3)

# R also has lots of built-in math functions (more on functions later)
abs(-3)
sqrt(64)
factorial(4)

# 8 choose 2
choose(8, 2)

# The log() function computes natural logs by default, but you can also select
# other options for this using the base argument in the function, or you can
# use base-10 log using the function log10()
log(30)
log(64, base = 8)
log10(100)

# pi is a pre-defined constant in R, accessible by just typing pi
pi

# Trigonometric functions use radians by default
sin(pi / 2)
cos(pi)
tan(pi / 4)

#-----------#
# Variables #
#-----------#

# Variables are an easy way to store pretty much anything that you may want to
# use later in your code. Like in Python, you can use the equal sign for this
x = 42

# You may have noticed by now that I use spaces between pretty much everything.
# This isn't necessary, but it is stylistically preferred. For instance, this
# will do the same thing as the above line
x=42
#ButWhenYouHaveNoSpacesBetweenYourOperationsThingsCanGetHardToRead

# However, the preferred notation for variable assignment in R is <-
# This is because, by default, the item on the right is always assigned to
# the item on the left. The arrow allows you to keep track of this better
y <- 10

# You can see what's stored in the variable using print()
print(y)

# But, unlike in Python, you don't have to actully type print(); this is
# actually what you've been doing all along with the other examples so far
y

# And, if you'd like to assign and print your variable in the same line
(z <- -2)

# When you have a variable, you can do anything with it that you could with the
# original value
z + 10
x + y

# And we can assign the results of operations directly to new variables
# (you can name variables anything you want, with some exceptions, including:
# no spaces, no quotation marks, no operators like +-/*^%><=!)
My_Variable <- 10 + y

# And you can also re-assign values to variables- for instance, x was previously
# set to 42; let's see what happens when we assign 12 to it...
x
x <- 12
x

# Values of variables are calculated at assignment, and are (almost never)
# recalculated on the fly (if a variable was used to assign a value to another
# variable, changing the value of one after assignment will not affect the value
# of the other- they are immutable and not passed by reference for assignment)
(NewVar <- x + y)
y <- 24
NewVar

# Variables can be of many different types, or classes, in R:
# Null
i <- NULL
class(i)

# Numeric
j <- 2
class(j)

# Integer (must be stated strictly)
k <- as.integer(4)
class(k)

# Logical (True or False, a.k.a. Boolean)
l <- TRUE
class(l)

# Character
m <- "a"
class(m)
m <- dog
class(m)
#-----------#
# Functions #
#-----------#

# If you have certain tasks that you do a lot in R, the best way to save time is
# to automate these tasks by writing functions. This may sound daunting, but it
# really isn't- functions have only three key parts: argument, body, and return

# The way you create a function in R is very similar to how you would create a
# variable. For this function, we are just multiplying a number by two
multiply_by_two <- function(argument) {
  x <- argument * 2
  return(x)
}

multiply_by_two(3)

# You can also make functions that take multiple inputs, or arguments (but you
# don't have to name them "argument" like I did in the first example; you do
# have to use the word "function" when creating a function though, and you
# should also use "return" at the end of the function)
multiply <- function(a, b) {
  return(a * b)
}

multiply(3, 4)

# But it is important to note that named arguments are only accessible within
# the function where they appear
a
b

# ...the same goes for variables that are initialized within functions
my_function <- function(c) {
  d <- c ^ c
  return(d)
}

my_function(3)

d

# This is due to a phenomenon called lexical scoping: variables will only be
# available or changeable in the the context in which they are created (and all
# contexts that are built from that context). This means that a variable that is
# initialized outside of a function (in the "global" scope) will be available
# in both the global and function scope; remember that we initialized z to -2
my_other_function <- function(arg) {
  return(arg * z)
}

my_other_function(4)

# ...but if we change the value of a global variable in the function scope, this
# will not carry back over to the more general global scope
my_other_other_function <- function(f) {
  z <- f ^ 3
  return(z)
}

my_other_other_function(2)

z

# One last thing about functions for today: you can save the return values of
# functions as variables- this will make it so that you don't have to
# recalculate functions each time you want to use the same output
h <- choose(20, 2)
h

# There's a lot more that you can do with functions, and we'll come back to
# functions throughout the course as we get deeper into R's capabilities!

# It's best practice with R code to always end your script with an empty line
