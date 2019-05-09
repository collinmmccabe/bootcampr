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
vec <- c(2, 5, 4, 7, 9, 24, 62)

# Vectors can hold any type of value- for instance, characters/strings
char_vec <- c("first", "second", "third", "fourth", "fifth", "sixth", "seventh")
class(vec); class(char_vec) 
logical_vec <- c(TRUE,FALSE,TRUE,TRUE,FALSE)
# Vectors take the class of their elements- a single value variable in R is
# actually, technically, a vector of length = 1
#   Sidenote: you can run multiple operations on one line by separating with ";"

# Vectors can only contain one class of values, regardless of how R makes it
# look to you. If you put multiple types of values into a vector, they will all
# be coerced to the most general class of values; the generality of values is as
# follows, with the most general last: NULL, logical, integer, numeric, character
class(c(NULL, NULL, NULL))
class(c(FALSE, TRUE, NULL, FALSE))
class(c(FALSE, TRUE, as.integer(2), FALSE))
class(c(FALSE, 1, as.integer(2), FALSE))
class(c("a", 1, as.integer(2), FALSE))

# You can pull out single values of vectors by refering to their index with []
# ...but it's important to note that in R, everything is indexed starting at 1,
# whereas in Python, things are indexed starting at 0:
vec[1]
vec[0]
as.numeric(NULL)
# By default, values of a vector will just be displayed in sequential order,
# with the index of the first value of each line if a vector must be displayed
# on multiple lines
vec

# However, you can also name the values in your vector using names()
names(vec) <- char_vec
vec

# Now, when referencing elements in the vector using either their index or name
vec[3]
vec["third"]
vec[6]
vec["eighth"]

# Math on vectors is element wise
other_vec <- c(5, 4, 6, 20, 41, 12, 9)
vec + other_vec
vec * other_vec

# If a single number is given, then the operation is applied to all elements
vec + 12
vec * 5

# You can also change specific elements of a vector after they have been
# assigned, the same way that you would reassign a variable
vec[4] <- 20
vec["fifth"] = 17
vec

# You can also add new values to the end of a vector using the next highest 
# index after the maximum; you can find out the max index with length()
l <- length(vec)
vec[l+1] <- 43
vec

# When you are done with an object in R and you don't expect to use it again,
# it is best practice to delete the object from memory. One of R's weaknesses
# is that everything is stored in memory, and this can make working with "big
# data" tricky (but doable) - you delete, or "remove" objects using rm()
rm(l)

# Another way to do this is using the c() function, although as mentioned
# yesterday, objects in R are typically immutable- a way around this is to
# reassign the value of c() back to the original object name
c(vec, 23)
vec
vec <- c(vec, 23)
vec
c(vec, other_vec)
# When indexing vectors, you can choose to include all but a given index using
# a negative in front of that index
vec[-2]

# You can also "slice" vectors, but also different from Python, both indices of
# the slice are inclusive
vec[2:3]
other_vec[1:5]
# However, both a start and an end must be declared for the slice, so no open-
# ended or open-start slices (again, different from Python)
vec[2:]
vec[:4]

# Instead, open-ended slices are done with tail() and the start index as a 
# negative number, and the same for open-start, using head()
tail(vec, -2)
tail(vec, -3)
head(vec, -4)
head(vec,-2)
tail(vec, -6)
tail(vec, 3)
head(vec, 3)
head(vec, -6)

?tail
tail(vec)
# Many functions take vectors as their arguments
mean(vec)
sum(vec)
sd(vec)

#----------#
# Matrices #
#----------#

# An elaboration on the vector is the matrix, a two-dimensional, homogeneous
# array of data; it is created using the function matrix(). You define the
# number of rows in a matrix using the second arg, nrow
(mat <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 2))
class(mat)

(mat2 <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 3))
# By default, the matrix() function fills in cells of the matrix from the top to
# the bottom of each column and then moves from left to right for each new
# column. You can change this default behavior using the byrow arg.
(other_mat <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 2, byrow = TRUE))
(other_mat2 <- matrix(c(1, 2, 3, 4, 5, 6, 7, 8), nrow = 3, ncol = 4, byrow = TRUE))

# Just like with vectors, you can name the elements in a matrix, although this
# will need to be done separately for the rows and then the columns (or vice
# versa, order doesn't matter here)
rownames(mat) <- c("odd", "even")
colnames(mat) <- c("lower", "low", "high", "higher")
mat

# Similar to the append() function for vectors, you can use cbind() and rbind(),
# the functions for adding an additional column or row to a matrix, respectively
cbind(mat, c(9, 10))
rbind(mat, c(9, 10, 11, 12))
(mat)
# ...but of course, just like with c(), the *bind() functions do not change
# the original matrix objects- to do this, we must reassign the result back to
# the original object's name. While we're at it, we can also add in a name for
# the new row or column by by adding "name = " before the concatenated vector
# (note that then dimension name here is not in quotation marks)
(other_mat <- cbind(other_mat, c(5, 9)))
(mat <- cbind(mat, highest = c(9, 10)))

# You can tell the dimensions (# rows, # columns) of a matrix using the dim()
# function on a matrix object
dim(mat)

# You can index similar to how you would have for vectors, with the exception
# that you will now need to indicate both a row and a column index, using the 
# matrix[row, column] notation
mat[2, 3]

# You can also select items by row or column name (or even a mix of both name
# and number!)
mat["even", "high"]
mat["even", 2]

# If you'd like to select an entire row or column, only fill in that row or
# column index, and then leave a blank either before or after the comma,
# depending on the dimension
mat[1, ]  # an entire row
mat[, "low"]  # an entire column

mat[9]
# You can slice matrices just like you did vectors
mat[1:2, 1:2]

# And if you slice out only one dimension from a matric, you get a ...vector!
class(mat[1, ])

# Again, reassigning an element is as simple as assigning a value to a specific
# element coordinate in the matrix
mat[1, 2] <- 13
mat

# math - by constants, by matrices, summary stats colSums rowSums, mean
# Matrices can be added, multiplied, divided, etc. with constants- the effect
# will be element-wise operations
mat + 5
mat * 2

# Matrices can also be added or subtracted from each other element-wise
mat - other_mat

# You can also calculate simple summary statistics on the matrix, too, often
# calculated on rows, columns, or the entire matrix
rowSums(mat); rowMeans(mat)
colSums(mat); colMeans(mat)
sum(mat); mean(mat)

# Matrix math, linear algebra, and other mathematical approaches for matrices
# are also very well implemented in R; for instance, you can easily transpose
# with the funtion t()
(t_other_mat <- t(other_mat))

# Generate simple diagonals of dim x by x using diag(x)
diag(5)

diag(10)
# Easily compute matrix multiplication/dot products with %*%
mat %*% t_other_mat
det(mat %*% t_other_mat)
det(matrix(c(115,110,255,230),nrow=2))
# Calculate the determinate of a (square) matrix with det()
det(matrix(c(1, 2, 3, 4, 9, 6, 7, 8, 9), nrow = 3))

# solve(a, b) solves for x where a %*% x = b, assuming that a and b are matrices
# or vectors
solve(matrix(c(1, 2, 3, 4, 9, 6, 7, 8, 9), nrow = 3), 
      matrix(c(7, 2, 1, 3, 9, 6, 3, 5, 9), nrow = 3))

solve(matrix(c(rep(0,9)), nrow = 3), 
      matrix(c(7, 2, 1, 3, 9, 6, 3, 5, 9), nrow = 3))
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
class(as.data.frame(mat))

# We can also turn vectors into columns of a data frame using the data.frame()
# function and listing "name = vector" for each column, separated by commas
data.frame(first_col = vec, second_col = other_vec, third_col = char_vec)
vec
other_vec
names(other_vec) <- c("A","B","C","D","E","F","G")
# Whoops, that won't work, because all columns in a dataframe must be the same
# length- let's try that again...
data.frame(first_col = vec[1:7], first_col = other_vec, third_col = char_vec)
data.frame(first_col = other_vec, first_col = vec[1:7], third_col = char_vec)
data.frame(first_col = char_vec, first_col = vec[1:7], third_col = other_vec)
# But rather than build a dataset from scratch, we'll work with a pre-loaded
# data frame that came with your base R installation: the USArrests dataset - 
# no need to save it as a new object, it's already here
USArrests
class(USArrests)
?USArrests

# We can learn more about the columns, or "variables" that compose the USArrests
# data frame by typing str(USArrests), which is short for "structure"
str(USArrests)

# So we can see that this data frame is composed of both numeric (decimal, or 
# "float" numbers) and integers- this would not have happened if it were a 
# matrix. If USArrests were a matrix, all values would be coerced to numerics, 
# as they are the more general class
str(as.matrix(USArrests))

# Aside from this difference, most indexing and appending operations for data
# frames are identical to those for matrices- with a few small differences: 
# The first is the use of the $ to select column names (in addition to named
# and numbered indices)- this returns a vector
USArrests[, "Assault"]
USArrests[, 2]
USArrests["Idaho",]

(assaults_vec <- USArrests$Assault)
class(assaults_vec)

# Selecting a column using just the name in brackets without a comma returns a 
# dataframe, which sometimes may be what you want for certain purposes
class(USArrests["Rape"])
USArrests["ohio"]
assaults_df <- USArrests["Assault"]
class(assaults_df)

# But this notation only works for columns, not rows
USArrests["Ohio"]

# We'll be covering data frames in a lot more detail next week, but for now,
# We'll just basically note that they are special matrices...

#-------#
# Lists #
#-------#

# Just like data frames are heterogeneous versions of matrices, lists are 
# heterogeneous versions of vectors. Lists can store a different class of object
# in each element, which can be very powerful and useful for a variety of
# applications; you can make lists in multiple ways- the first is list()
my_list <- c(20.0, as.integer(3), TRUE, "hello", NULL)
class(my_list)
my_list <- list(20.0, as.integer(3), TRUE, "hello", NULL)
class(my_list)
str(my_list)

my_list
# You can also coerce vectors into lists, which can be helpful if you want to
# store different classes in the object later
(new_list <- as.list(vec))
class(new_list)

# You can access the items in a list using a couple of different notations; one
# of these is the double bracket, "[[index]]" notation
new_list[[8]]

# You may have also noticed when the second list was printed out that the "$" 
# notation also works for list, just like with data frames
new_list$first

# Just like using a single bracket with a data frame column returned another
# data frame, using single brackets with a list index returns a list
new_list[9]
str(new_list)
# When building a list, you can name the indices, just like you would when 
# building a data frame
(named_list <- list(mine = 2, yours = NULL))

# You can change the value of list elements similar to how you would for vectors
named_list[["mine"]] <- 4
named_list

# You can add new values to lists using this same notation
named_list[["hers"]] <- 3
named_list

# And if you want to remove an item from a list, you assign it the NULL value.
# For this reason, list elements can only be initialized to NULL, but not 
# asigned this value after initialization
named_list[["yours"]] <- NULL
named_list

# You can append lists using the c() function
(named_list <- c(named_list, his = 3))

# But the real power of lists comes from their ability to store pretty much
# anything as an element:
(vec_list <- list(number = 1, vector = vec)) # Vectors
(mat_list <- list(boolean = TRUE, matrix = mat)) # Matrices
(df_list <- list(character = "abc", df = USArrests)) # Data frames
# Even other lists!

(list_list <- list(list1 <- vec_list, list2 = mat_list, list3 = df_list))

# Of course, this can get very complicated,so you'll need to keep track of the 
# structure of your lists
str(list_list)

# And then you can access specific elements by using bracket notation followed
# by the notation of the object in the element
list_list[[1]][[2]][1] # the first element of the vector in the first list
list_list$list3$df$Murder # the Murder column of data frame in the third list
list_list[[3]]$df$Murder[3] # combination of "$" and "[[]]"

# Sometimes, you need a list to be in a simpler format, this is where unlist()
# comes in hand- it will change the representation of a list into a vector. Be
# careful when doing this, though, because, just as with all vectors, an 
# unlisted list will be coerced to the most general class of element
(unlisted_list <- unlist(list_list$list2))
class(unlisted_list)

# One of my favorite applications of lists is that they allow for multiple 
# values to be returned from a function
summary_stats <- function(vec) {
  fn_sum <- sum(vec)
  fn_mean <- mean(vec)
  fn_sd <- sd(vec)
  return(list(sum = fn_sum, mean = fn_mean, sd = fn_sd))
}

summary_stats(c(1, 2, 3, 4, 5))
