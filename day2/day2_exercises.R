################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                            Day 2 - Data Structures                           #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# You may have noticed by now that all of my R code falls neatly into a certain
# maximum line length; this obviously isn't by accident. Many programmers like 
# to keep a standard maximum line length to allow you to read code without
# having to scroll back and forth. A common line length is 80 characters, which
# is what I use. Later in the course, I'll show you how to break up long lines
# of code so that both R and humans can understand it.

# So far we have only discussed variables with single values, but we can store
# a lot more than just one value in a variable. Maybe a better term for this,
# rather than a variable, is an "object"- both variables and functions that
# we've discussed so far are objects, and so will be these more complex data
# structures that we will create.

#---------#
# Vectors #
#---------#

# The first and most basic of these complex data structures is a vector: a one-
# dimensional, ordered, homogeneous (all of one class) array of data. In R, 
# these are made using the concatenate function, c()


# Vectors can hold any type of value- for instance, characters/strings


# Vectors take the class of their elements- a single value variable in R is
# actually, technically, a vector of length = 1
#   Sidenote: you can run multiple operations on one line by separating with ";"

# Vectors can only contain one class of values, regardless of how R makes it
# look to you. If you put multiple types of values into a vector, they will all
# be coerced to the most general class of values; the generality of values is as
# follows, with the most general last: NULL, logical, integer, numeric, character


# You can pull out single values of vectors by refering to their index with []
# ...but it's important to note that in R, everything is indexed starting at 1,
# whereas in Python, things are indexed starting at 0:


# By default, values of a vector will just be displayed in sequential order,
# with the index of the first value of each line if a vector must be displayed
# on multiple lines


# However, you can also name the values in your vector using names()


# Now, when referencing elements in the vector using either their index or name


# Math on vectors is element wise


# If a single number is given, then the operation is applied to all elements


# You can also change specific elements of a vector after they have been
# assigned, the same way that you would reassign a variable


# You can also add new values to the end of a vector using the next highest 
# index after the maximum; you can find out the max index with length()


# When you are done with an object in R and you don't expect to use it again,
# it is best practice to delete the object from memory. One of R's weaknesses
# is that everything is stored in memory, and this can make working with "big
# data" tricky (but doable) - you delete, or "remove" objects using rm()


# Another way to do this is using the c() function, although as mentioned
# yesterday, objects in R are typically immutable- a way around this is to
# reassign the value of c() back to the original object name


# When indexing vectors, you can choose to include all but a given index using
# a negative in front of that index


# You can also "slice" vectors, but also different from Python, both indices of
# the slice are inclusive


# However, both a start and an end must be declared for the slice, so no open-
# ended or open-start slices (again, different from Python)


# Instead, open-ended slices are done with tail() and the start index as a 
# negative number, and the same for open-start, using head()


# Many functions take vectors as their arguments


#----------#
# Matrices #
#----------#

# An elaboration on the vector is the matrix, a two-dimensional, homogeneous
# array of data; it is created using the function matrix(). You define the
# number of rows in a matrix using the second arg, nrow


# By default, the matrix() function fills in cells of the matrix from the top to
# the bottom of each column and then moves from left to right for each new
# column. You can change this default behavior using the byrow arg.


# Just like with vectors, you can name the elements in a matrix, although this
# will need to be done separately for the rows and then the columns (or vice
# versa, order doesn't matter here)


# Similar to the append() function for vectors, you can use cbind() and rbind(),
# the functions for adding an additional column or row to a matrix, respectively


# ...but of course, just like with c(), the *bind() functions do not change
# the original matrix objects- to do this, we must reassign the result back to
# the original object's name. While we're at it, we can also add in a name for
# the new row or column by by adding "name = " before the concatenated vector
# (note that then dimension name here is not in quotation marks)


# You can tell the dimensions (# rows, # columns) of a matrix using the dim()
# function on a matrix object


# You can index similar to how you would have for vectors, with the exception
# that you will now need to indicate both a row and a column index, using the 
# matrix[row, column] notation


# You can also select items by row or column name (or even a mix of both name
# and number!)


# If you'd like to select an entire row or column, only fill in that row or
# column index, and then leave a blank either before or after the comma,
# depending on the dimension


# You can slice matrices just like you did vectors


# And if you slice out only one dimension from a matric, you get a ...vector!


# Again, reassigning an element is as simple as assigning a value to a specific
# element coordinate in the matrix


# math - by constants, by matrices, summary stats colSums rowSums, mean
# Matrices can be added, multiplied, divided, etc. with constants- the effect
# will be element-wise operations


# Matrices can also be added or subtracted from each other element-wise


# You can also calculate simple summary statistics on the matrix, too, often
# calculated on rows, columns, or the entire matrix


# Matrix math, linear algebra, and other mathematical approaches for matrices
# are also very well implemented in R; for instance, you can easily transpose
# with the funtion t()


# Generate simple diagonals of dim x by x using diag(x)


# Easily compute matrix multiplication/dot products with %*%


# Calculate the determinate of a (square) matrix with det()


# solve(a, b) solves for x where a %*% x = b, assuming that a and b are matrices
# or vectors


#-------------#
# Data Frames #
#-------------#

# Data frames are essentially matrices where each column may be of a different
# type/class; i.e. they are two-dimensional, heterogeneous arrays. These are
# typically the structures that most R data scientists use for interacting with
# data, as they allow a variety of information to be stored in the same object

# We can create data frames from existing matrices using the coercion
# as.data.frame(), but most data can be imported directly to R as a data frame,
# so this function isn't actually used that much in practice by data scientists


# We can also turn vectors into columns of a data frame using the data.frame()
# function and listing "name = vector" for each column, separated by commas


# Whoops, that won't work, because all columns in a dataframe must be the same
# length- let's try that again...


# But rather than build a dataset from scratch, we'll work with a pre-loaded
# data frame that came with your base R installation: the USArrests dataset - 
# no need to save it as a new object, it's already here


# We can learn more about the columns, or "variables" that compose the USArrests
# data frame by typing str(USArrests), shich is short for "structure"


# So we can see that this data frame is composed of both numeric (decimal, or 
# "float" numbers) and integers- this would not have happened if it were a 
# matrix. If USArrests were a matrix, all values would be coerced to numerics, 
# as they are the more general class


# Aside from this difference, most indexing and appending operations for data
# frames are identical to those for matrices- with a few small differences: 
# The first is the use of the $ to select column names (in addition to named
# and numbered indices)- this returns a vector


# Selecting a column using just the name in brackets without a comma returns a 
# dataframe, which sometimes may be what you want for certain purposes


# But this notation only works for columns, not rows


# We'll be covering data frames in a lot more detail next week, but for now,
# We'll just basically note that they are special matrices...

#-------#
# Lists #
#-------#

# Just like data frames are heterogeneous versions of matrices, lists are 
# heterogeneous versions of vectors. Lists can store a different class of object
# in each element, which can be very powerful and useful for a variety of
# applications; you can make lists in multiple ways- the first is list()


# You can also coerce vectors into lists, which can be helpful if you want to
# store different classes in the object later


# You can access the items in a list using a couple of different notations; one
# of these is the double bracket, "[[index]]" notation


# You may have also noticed when the second list was printed out that the "$" 
# notation also works for list, just like with data frames


# Just like using a single bracket with a data frame column returned another
# data frame, using single brackets with a list index returns a list


# When building a list, you can name the indices, just like you would when 
# building a data frame


# You can change the value of list elements similar to how you would for vectors


# You can add new values to lists using this same notation


# And if you want to remove an item from a list, you assign it the NULL value.
# For this reason, list elements can only be initialized to NULL, but not 
# asigned this value after initialization


# You can append lists using the c() function


# But the real power of lists comes from their ability to store pretty much
# anything as an element:


# Even other lists!


# Of course, this can get very complicated,so you'll need to keep track of the 
# structure of your lists


# And then you can access specific elements by using bracket notation followed
# by the notation of the object in the element


# Sometimes, you need a list to be in a simpler format, this is where unlist()
# comes in hand- it will change the representation of a list into a vector. Be
# careful when doing this, though, because, just as with all vectors, an 
# unlisted list will be coerced to the most general class of element


# One of my favorite applications of lists is that they allow for multiple 
# values to be returned from a function
summary_stats <- function(   ) {
  fn_sum <- 
  fn_mean <- 
  fn_sd <- 
  return(list(sum = fn_sum, mean = fn_mean, sd = fn_sd))
}

summary_stats(c(1, 2, 3, 4, 5))
