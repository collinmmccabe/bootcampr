################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                                Day 1 - Basics                                #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

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


# Looks like that's not a function, let's look at the help page (?) for this


# There's nothing exactly called pwd(), so let's use search-within help (??)


# OK, it's actually called getwd(), so let's try that


# I forgot- I put the welcome script within the folder "Welcome/", setwd() there
#   Sidenote: in RStudio, as you're typing filenames, you can use tab-completion


# If you're not a fan of doing things through the command line/script (soon you
# will be), there are GUI ways to do this, too: choose.dir


# Now we can finally run my welcome script!


# Just like you can use a GUI to choose a folder, you can do the same for files


# Alright, now that we're done with that, let's go back to the parent directory


#------#
# Math #
#------#

# At it's heart, R is just a big calculator...

# Addition


# Subtraction


# Multiplication


# Division


# Exponents


# Modulo (a.k.a. Remainder)


# Integer (Floor) Division


# Order of Operations:
# 1. Exponents (right to left)
# 2. Modulo (left to right)
# 3. Multiplication & Division (left to right)
# 4. Addition & Subtraction (left to right)


# You can alter the order of operations with parentheses


# R also has lots of built-in math functions (more on functions later)


# 8 choose 2


# The log() function computes natural logs by default, but you can also select
# other options for this using the base argument in the function, or you can
# use base-10 log using the function log10()


# pi is a pre-defined constant in R, accessible by just typing pi


# Trigonometric functions use radians by default


#-----------#
# Variables #
#-----------#

# Variables are an easy way to store pretty much anything that you may want to
# use later in your code. Like in Python, you can use the equal sign for this


# You may have noticed by now that I use spaces between pretty much everything.
# This isn't necessary, but it is stylistically preferred. For instance, this
# will do the same thing as the above line

#ButWhenYouHaveNoSpacesBetweenYourOperationsThingsCanGetHardToRead

# However, the preferred notation for variable assignment in R is <-
# This is because, by default, the item on the right is always assigned to
# the item on the left. The arrow allows you to keep track of this better


# You can see what's stored in the variable using print()


# But, unlike in Python, you don't have to actully type print(); this is
# actually what you've been doing all along with the other examples so far


# And, if you'd like to assign and print your variable in the same line


# When you have a variable, you can do anything with it that you could with the
# original value


# And we can assign the results of operations directly to new variables
# (you can name variables anything you want, with some exceptions, including:
# no spaces, no quotation marks, no operators like +-/*^%><=!)


# And you can also re-assign values to variables- for instance, x was previously
# set to 42; let's see what happens when we assign 12 to it...


# Values of variables are calculated at assignment, and are (almost never)
# recalculated on the fly (if a variable was used to assign a value to another
# variable, changing the value of one after assignment will not affect the value
# of the other- they are immutable and not passed by reference for assignment)


# Variables can be of many different types, or classes, in R:
# Null


# Numeric


# Integer (must be stated strictly)


# Logical (True or False, a.k.a. Boolean)


# Character


#-----------#
# Functions #
#-----------#

# If you have certain tasks that you do a lot in R, the best way to save time is
# to automate these tasks by writing functions. This may sound daunting, but it
# really isn't- functions have only three key parts: argument, body, and return

# The way you create a function in R is very similar to how you would create a
# variable. For this function, we are just multiplying a number by two


# You can also make functions that take multiple inputs, or arguments (but you
# don't have to name them "argument" like I did in the first example; you do
# have to use the word "function" when creating a function though, and you
# should also use "return" at the end of the function)


# But it is important to note that named arguments are only accessible within
# the function where they appear


# ...the same goes for variables that are initialized within functions


# This is due to a phenomenon called lexical scoping: variables will only be
# available or changeable in the the context in which they are created (and all
# contexts that are built from that context). This means that a variable that is
# initialized outside of a function (in the "global" scope) will be available
# in both the global and function scope; remember that we initialized z to -2


# ...but if we change the value of a global variable in the function scope, this
# will not carry back over to the more general global scope


# One last thing about functions for today: you can save the return values of
# functions as variables- this will make it so that you don't have to
# recalculate functions each time you want to use the same output


# There's a lot more that you can do with functions, and we'll come back to
# functions throughout the course as we get deeper into R's capabilities!

# It's best practice with R code to always end your script with an empty line
