################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#           Day 10 - Machine Learning: Classification and Regression           #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# Machine learning sounds scary, but really, it's pretty much the same thing
# that we've been doing for the past couple days. The only difference is that, 
# rather than using our statistical models to test for associations, we will be
# using our models to predict future values from inferred associations. Most 
# machine learning models can also be applied retrospectively to understand
# associations, but it is the predicting values that makes these models great!

# Today we'll be doing "supervised" machine learning. There are typically two 
# approaches to machine learning: supervised and unsupervised; the difference 
# between these approaches is whether or not you tell the machine learning what
# the "right" answers are in your training set- i.e. if you are making a 
# regression model, what are the y-values; if you're making a classification
# model, what are the categories into which things fall? Since supervised 
# learning is by definition the more structured of the two approaches, it seemed
# like the obvious place to start when teaching machine learning.

# Many of the approaches and much of the code for this session are taken from
# and/or adapted from Max Kuhn's website for caret, the most popular and most
# user-friendly package for machine learning in R. Max Kuhn is the author of 
# caret, and just as we went to Hadley Wickham's R4DS website for learning the 
# tidyverse, we will be using the caret website / internet book for learning
# caret and machine learning in R. The website can be found here:
# https://topepo.github.io/caret/index.html - and just as with R4DS, we will
# only be scratching the surface of what is possible with this stuff. If you 
# want to learn more about caret and machine learning in R, look through the 
# website above, and/or buy the somewhat companion-y book to this at:
# http://appliedpredictivemodeling.com/

#----------------------------------#
# Regression (using linear models) #
#----------------------------------#

# To predict values, we must first get a reliable model. The way to test and
# (hopefully) confirm the reliability of your model is through the concepts of
# training and testing. This is just a fancy way of saying: build a model with 
# a defined subset of your existing data (training), and then see how that model
# performs on "unseen" data- the remianing data that wasn't part of the training
# set (testing). We are shooting for a model that performs just about as well on
# unseen data as it does for its original training set, although this is often 
# a pretty unrealistic expectation, at least from the get go.

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
mpgmod2 <- lm(hwy ~ cty, data = mpg)

# You can then make predictions for each observation's hwy value from the model
# - this will be just the point on the line of best fit for each row of values
predictions <- predict(mpgmod1)
predictions2 <- predict(mpgmod2)


# To calculate how far off our model was from the real values, we just subtract
error <- predictions - mpg$hwy
error2 <- predictions2 - mpg$hwy

# Root Mean Squared Error (RMSE) is the standard for assessing regression model
# performance for predictions.
sqrt(mean(error ^ 2))
RMSE_pred <- sqrt(mean(error2 ^ 2))

# We can compare RMSE to a topic that we kinda glazed over yesterday, R^2; 
# Here's that section, just for refreshers:

###############
# DAY09 - R^2 #
###############

X <- mpg$cty
Y <- mpg$hwy
n <- length(Y)
a = lm(Y ~ X)$coefficients[1]
b = lm(Y ~ X)$coefficients[2]

# R^2 is a measure that tells us what % of the behavior of Y is explained by X

# Ybar   = average of Yi
# Yhat_i = predicted Y val

# TSS = sum (Yi - Ybar)^2      # Total sum of squares
# RSS = sum (Yi - Yhat_i)^2    # Residual sum of squares
# ESS = sum (Yhat_i - Ybar)^2  # Expected sum of squares

# TSS = ESS + RSS
# R^2 = ESS / TSS

# calculating R^2
Y_hat <- b * X + a              # model prediction for Y
Y_bar <- mean(Y)                # overall mean of Y across all points
TSS <- sum((Y - Y_bar) ^ 2)     # diff between mean(Y) and Y
RSS <- sum((Y - Y_hat) ^ 2)     # diff between Y and prediction
ESS <- sum((Y_hat - Y_bar) ^ 2) # diff between prediction and mean(Y)

R_sq = ESS / TSS
# --- OR ---
R_sq_v2 = 1 - (RSS / TSS)
(R_sq - summary(mpgmod2)$r.squared)

# But this won't work- why?
R_sq == summary(mpgmod2)$r.squared # Probably because there are computational 
                                   # shortcuts programmed into R to estimate R^2
                                   # rather than having to calculate for large n

# You can also check if answers are approximately equal with the tidyverse...
near(R_sq, summary(mpgmod2)$r.squared)

###############

# For reference, RMSE is just the square-root of RSS divided by the sample-size:
#   sqrt(RSS/n)

RMSE_byhand = sqrt(RSS/n)

near(RMSE_pred, RMSE_byhand)

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
mpg_traincontrol <- trainControl(method = "cv", number = 20)

(mpgmod4 <- train(hwy ~ ., mpg, method = "lm", 
                  trControl = mpg_traincontrol))

# We can then make a prediction on new data using the predict function (we will
# leave out the hwy measure, and pretend that we dont know it, so we predict it)
new_data <- data.frame(manufacturer = factor("ford"), displ = 2.50, year = 2005,
                       cyl = 6, trans = factor("auto(av)"), drv = factor("f"), 
                       cty= 20, fl = factor("p"), class = factor("compact"))

predict(mpgmod4, new_data)

# We can also make linear models that fit the data on polynomial scales - be 
# very careful about this, as this can lead to your model going out of its way 
# to fit a pattern that only actually exists because of the error in your data,
# and due to the actual underlying pattern: this is what overfitting is. Only 
# use polynomial terms when you are absolutely sure that your data fit them...
(mpgmod7 <- train(hwy ~ cty, mpg, method = "lm", 
                  trControl = mpg_traincontrol))

(mpgmod5 <- train(hwy ~ poly(cty, 2), mpg, method = "lm", 
                  trControl = mpg_traincontrol))

(mpgmod6 <- train(hwy ~ poly(cty, 3), mpg, method = "lm", 
                  trControl = mpg_traincontrol))

### EXERCISE ###

# What RMSE do you get for predicting price from all available data in the
# diamonds dataset? How can you get better estimates for RMSE for the data?





#--------------------------------------------#
# Classification (using logistic regression) #
#--------------------------------------------#

# Logistic regressions are best thought of as a linear model with only, two
# possible values for y: 0 or 1; Yes or No; TRUE or FALSE; etc. These categories
# may make the test seem more like a two sample t-test, but in reality, this is
# much more like a multiple regression model (which can take many x variables),
# which just happens to have a categorical or factored y variable.

# For our classification example, we will be predicting whether or not something
# is a hotdog from a variety of traits
hotdog <- read_csv("data/hotdog.csv", 
                   col_names = c("tastiness", "ketchup", "bun",
                                 "ishotdog", "calories"))

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
hotdog <- read_csv("data/hotdog.csv", 
                   col_names = c("tastiness", "ketchup", "bun",
                                 "ishotdog", "calories"))

hotdog$ishotdog[hotdog$ishotdog == 0] <- "No"
hotdog$ishotdog[hotdog$ishotdog == 1] <- "Yes"
hotdog$ishotdog <- factor(hotdog$ishotdog)

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

### EXERCISE ###

# Predict infertility (case) from the infert dataset using logistic regression.
# What is your accuracy? False positive rate? False Negative?





#------------------------#
# Clustering (using kNN) #
#------------------------#

# Clustering is useful when you have a small number of variables, but many 
# categories into which individuals may fall. For this example, I've adapted 
# much of the code from https://rpubs.com/njvijay/16444

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

# You can also artificially reduce the number of variables through 
# dimensionality reduction approaches, like principal components analysis.

# FIX ME!
prcomp(iris[1:4, ], iris, scale = TRUE)

knn <- train(Species ~ ., iris, method = "knn", trControl = iris_traincontrol,
             preProcess = c("center","scale", "pca"), tuneLength = 20)
confusionMatrix(knn)

### EXERCISE ###

# Use kNN clustering to predict what cut a diamond is, based on the rest of the 
# data presented in the diamonds dataset. What is the accuracy?




