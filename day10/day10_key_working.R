#-------------
# Regression
#

# For our regression example, we will use the mpg dataset included with the
# tidyverse
library(tidyverse)
mpg$manufacturer <- factor(mpg$manufacturer)
mpg$trans <- factor(mpg$trans)
mpg$drv <- factor(mpg$drv)
mpg$fl <- factor(mpg$fl)
mpg$class <- factor(mpg$class)
glimpse(mpg)

# The first step to any regression machine learning problem is to create the 
# regression model to test; we'll use the '-' notation to remove model from
# our dataset, since this is so variable that it may not be helpful
mpgmod1 <- lm(hwy ~ . - model, data = mpg)

# You can then make predictions for each observation's hwy value from the model
# - this will be just the point on the line of best fit for each row of values
predictions <- predict(mpgmod1)

# To calculate how far off our model was from the real values, we just subtract
error <- predictions - mpg$hwy

# Root Mean Squared Error (RMSE) is the standard for assessing regression model
# performance for predictions.
sqrt(mean(error ^ 2))

# But this was a pretty useless model, since we just predicted the same values 
# for hwy that were used in our model. We have no idea how our model might
# perform on unseen data. This is where training and test sets come in.

# We will want to subset our data into training and test sets to evaluate our
# performance on unseen data. To do this, we just randomly remove some data from
# our modeling, or training, set and we put it aside to use later as a test set.
# for this example, we will save approximately 25% of the data to test on:
mpg <- mutate(mpg, train = sample(c(0,1,1,1), n(), replace = TRUE))
mpg_train <- filter(mpg, train > 0)
mpg_test <- filter(mpg, train == 0)

# We will use the training set to create our linear model
mpgmod2 <- lm(hwy ~ . - model - train, data = mpg_train)

# And then we will use our test set to make predictions from the linear model
predictions <- predict(mpgmod2, mpg_test)

# We then calculate error and RMSE to evaluate model performance
error <- predictions - mpg_test$hwy
sqrt(mean(error^2))

# But now, this is where caret comes in: we can automate the test and training
# set creation, and we can also replicate the process through cross-validation
# to get multiple training and test sets so as to incorporate all data into our
# training and test sets; first, let's just do the whole dataset
install.packages("caret", dependencies = TRUE)
library(caret)

# First, let's clean up our old dataset:
mpg <- select(mpg, -model, -train)

# This is identical to the first model we ran above
mpgmod3 <- train(hwy ~ ., mpg, method = "lm")
predictions <- predict(mpgmod3, mpg)
error <- predictions - mpg$hwy
sqrt(mean(error ^ 2))

# We can define our subgrouping through something called k-fold cross-validation
# using the trainControl() function; here we will use 5 "folds", or equally
# sized splits of the data- these will be combined to create our training & test
# sets. "cv" tells train that we want to do a crossfold, number tells it how 
# many folds
mpg_traincontrol <- trainControl(method = "cv", number = 5)

(mpgmod4 <- train(hwy ~ ., mpg, method = "lm", 
                 trControl = mpg_traincontrol))

# We can then make a prediction on new data using the predict function (we will
# leave out the hwy measure, and pretend that we dont know it, so we predict it)
new_data <- data.frame(manufacturer = factor("ford"), displ = 2.50, year = 2005,
              cyl = 6, trans = factor("auto(av)"), drv = factor("f"), 
              cty= 20, fl = factor("p"), class = factor("compact"))

predict(mpgmod4, new_data)

#------------------
# Classification
#

# For our classification example, we will be predicting whether or not something
# is a hotdog from a variety of traits
hotdog <- read_csv("GitHub/hotdog.txt", 
                   col_names = c("tastiness", "ketchup", "bun",
                                 "ishotdog", "calories"))

hotdog$ishotdog[12] <- 0
hotdog$ishotdog[hotdog$ishotdog == 0] <- "No"
hotdog$ishotdog[hotdog$ishotdog == 1] <- "Yes"
hotdog$ishotdog <- factor(hotdog$ishotdog)

# To predict whether something is one thing or another, we use the logistic
# regression, or a generalized linear model with a binomial error term.
hotmod1 <- glm(ishotdog ~ ., family = "binomial", hotdog)

# We can generate predictions as the raw probabilities with type = "response"
probabilities <- predict(hotmod1, hotdog, type = "response")

# We can now check to see how our model faired at predicting whether something
# was a hotdog or not- for classification models, we evaluate using confusion 
# matrices and the accuracy measures that result from them. Here, we will use
# a simple cutoff of 0.5 by rounding the probabilities to the nearest integer
confusionMatrix(factor(round(probabilities)), hotdog$ishotdog)

# Awesome, those are some pretty good probabilities! Again, we will want to use
# k-fold cross-validation to make sure that we are training and testing on a 
# variety of data from within our dataset to get the most realistic measure of 
# our accuracies; here, we have a new parameter to set here: class probs, which
# will give us the probability of whether something is a hotdog, similar to our
# predict() function using type = "response"
hot_traincontrol <- trainControl(method = "cv", number = 5, classProbs = TRUE)

# Now let's run our model!
(hotmod2 <- train(ishotdog ~ ., hotdog, method = "glm", 
                  trControl = hot_traincontrol))

# We're gonna need a lot more hotdogs...
confusionMatrix(hotmod2)

# but let's try to predict whether something is a hotdog anyway (I already know
# that this one is a hotdog)
isdefahotdog <- data.frame(tastiness = 4, ketchup = 1, bun = 1, calories = 250)
predict(hotmod2, isdefahotdog)

#---------------
# Clustering
#

library(class)

iris <- mutate(iris, train = sample(c(0, 1, 1, 1), n(), replace = TRUE))
iris_trainclass <- filter(iris, train > 0) %>% select(Species)
iris_train <- filter(iris, train > 0) %>% select(-Species, -train)
iris_test <- filter(iris, train == 0) %>% select(-Species, -train)
iris_testclass <- filter(iris, train == 0) %>% select(Species)
iris <- iris %>% select(-train)

predictions <- knn(iris_train, iris_test, cl = factor(unlist(iris_trainclass)))
sum(predictions == unlist(iris_testclass)) / nrow(iris_test)

iris_traincontrol <- trainControl(method = "cv", number = 5)
knn <- train(Species ~ ., iris, method = "knn", trControl = iris_traincontrol,
             preProcess = c("center","scale"), tuneLength = 20)
confusionMatrix(knn)

# FIX ME!
prcomp(iris[1:4, ], iris, scale = TRUE)

knn <- train(Species ~ ., iris, method = "knn", trControl = iris_traincontrol,
             preProcess = c("center","scale", "pca"), tuneLength = 20)
confusionMatrix(knn)
