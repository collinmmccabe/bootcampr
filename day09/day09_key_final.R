################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                  Day 9 - Statistics with Continuous Variables                #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

# We'll be working with the freeny dataset in base R today for the examples:
datasets::freeny
?freeny.x

#--------------#
# Correlations #
#--------------#

# Before we get to Regressions and explanations for relationships between 
# variables, we first need to know where to look. This is best done with a 
# correlation test, to see whether a variable or set of variables are associated
# with another, statistically.  This is calculated with the cor() function in 
# base R, which can be used on a single X & Y variable or many:
cor(freeny$y, freeny$lag.quarterly.revenue)
.997795 ^ 2
summary(lm(y ~ lag.quarterly.revenue, freeny))

# for all variables in the dataset
cor(freeny)

### EXERCISE ###

# Which variables are correlated in the mtcars dataset? What are the strongest
# and the weakest relationships?



which(cor(mtcars) == max(cor(mtcars)[which(cor(mtcars) != 1)]))
colnames(cor(mtcars))[14 %/% 11]; colnames(cor(mtcars))[14 %/% 11 + 1]


which(cor(mtcars) == min(cor(mtcars)[which(cor(mtcars) > 0)]))
cor(mtcars)[6]
colnames(cor(mtcars))[99 %% 11+11]; colnames(cor(mtcars))[99 %/% 11 + 1]

#------------#
# Regression #
#------------#

# Many of the notes in this section and those on assumptions and hyp tests were
# adapted from https://github.com/idrisr/Regression, which is itself an 
# adaptation of Leo Kahane's Introduction to Regression. Check them both out, as
# they are both great resources for understanding regression more!

# Slope of Regression
# b = sum (Xi - Xbar) * (Yi - Ybar) / sum (Xi - Xbar)^2
# a = Ybar - b * Xbar
# Note that a typical straight line has the formula y = a * x + b

X <- freeny$lag.quarterly.revenue
Y <- freeny$y

b <- sum((X - mean(X)) * (Y - mean(Y))) / sum((X-mean(X)) ^ 2)
a <- mean(Y) - b * mean(X)

lmod1 <- lm(y ~ lag.quarterly.revenue, freeny)

lmod1$coefficients[1]; a
lmod1$coefficients[2]; b

library(ggplot2)
ggplot(freeny, aes(x = lag.quarterly.revenue, y = y)) + 
  geom_point() +
  geom_smooth(method = lm, se = FALSE) +
  scale_x_continuous(aes(xmin = 0,xmax = 10)) +
  scale_y_continuous(aes(ymin = 0, ymax = 10)) 

### EXERCISE ###

# What are the slope and intercept of the relationship between mpg and disp in
# the dataset mtcars?



lm(mpg ~ disp, mtcars)

#------------------------#
# Regression Assumptions #
#------------------------#

# 1. The average of the population errors(residuals) is 0.

# 3. The errors associated with one observation is not associated with the
#    errors from any other observations. in other words, we assume to
#    autocorrelation among the error terms. If there is a relationship between
#    the errors, that means we can make the model better by incorporating that
#    relationship
# 4. There is no measurement error in Xi and Yi
# 5. The regression model is theoretically sound for our data. This can be
#    violated by not including all relevant independent variables. Also it can
#    be violated if we assume a linear relationship, when perhaps a curve is
#    appropriate.
# 6. The error term is normally distributed.

# The best way to check your assumptions is to plot the various checks:
plot(lmod1)

# A great resource for understanding these plots can be found on the website for
# the stats department at UVA: http://data.library.virginia.edu/diagnostic-plots
# and http://data.library.virginia.edu/understanding-q-q-plots/

# Another good place to look is StackExchange- that's where I found this gem:
# https://stats.stackexchange.com/questions/58141/interpreting-plot-lm

### EXERCISE ###

# Does the model comparing horsepower to diplacement meet our assumptions for 
# linear models? Why or why not?



plot(lm(hp ~ disp, mtcars))

#--------------------#
# Hypothesis Testing #
#--------------------#

# How can we tell if there is a relationship between X and Y? There are two main
# statistics to check with regressions / linear models. The first is the p-value
# (which we discussed on Friday). Below are the null and alternative hypotheses
# for ordinary least squares linear models.

# H0: b == 0 null hypothesis
# HA: b != 0 alt  hypothesis

# We can find our p-value for our previous test using the summary() function,
# just like for ANOVA's aov() (in fact, ANOVAs are really just specialized 
# linear models with factors instead of continuous variables)
summary(lmod1)

# The real test that is going on behind the scenes here is that we are looking 
# at a distribution of the slopes of the line, where the variation depends on
# the confidence intervals of the line, and these themselves are calculated from
# the variation in the y variable from the predicted line; this is called the
# error or "residual"- more on that in just a second. Here's a vizualization:
ggplot(freeny, aes(x = lag.quarterly.revenue, y = y)) + 
  geom_point() +
  geom_smooth(method = lm) +
  scale_x_continuous(aes(xmin = 0,xmax = 10)) +
  scale_y_continuous(aes(ymin = 0, ymax = 10))

# Similar to the base R summary(), we can also use a tidyverse function, broom()
install.packages("broom")
library(broom)
tidy(lmod1)

# The p-value, however, does not tell the whole story for a linear model, 
# because we don't know how well the data fits the model, only that its slope
# falls within a certain margin of error. To understand how well the real data
# fits out predictions, we need to bring in a measure of the goodness of fit: R²

# R² is a measure that tells us what % of the behavior of Y is explained by X

# Ybar   = average of Yi
# Yhat_i = predicted Y val

# TSS = sum (Yi - Ybar)²      # Total sum of squares
# RSS = sum (Yi - Yhat_i)²    # Residual sum of squares
# ESS = sum (Yhat_i - Ybar)²  # Expected sum of squares

# TSS = ESS + RSS
# R² = ESS/TSS

# calculating R²
Y_hat <- b * X + a
Y_bar <- mean(Y)
TSS <- sum((Y - Y_bar) ^ 2)     # diff between mean(Y) and Y
RSS <- sum((Y - Y_hat) ^ 2)     # diff between Y and prediction
ESS <- sum((Y_hat - Y_bar) ^ 2) # diff between prediction and mean(Y)

R_sq = ESS / TSS
(R_sq - summary(lmod1)$r.squared)

# But this won't work- why?
R_sq == summary(lmod1)$r.squared

# You can also do this with the tidyverse
near(R_sq, summary(lmod1)$r.squared)

### EXERCISE ###

# What are the p-value and R² for the relationship between mpg and wt in mtcars?



summary(lm(mpg ~ wt, mtcars))

#---------------------#
# Multiple Regression #
#---------------------#

# What if you want to know how multiple variables affect a single variable at 
# once? This can be tricky, because if you just run a bunch of single-variable
# linear models, you are not capturing the whole picture. You may have two 
# variables that explain overlapping amounts of data, e.g. displacement and 
# horsepower in the mtcars dataset probably capture a lot of the same 
# information, but there may be some additional info provided by hp that is not
# in disp, and vice versa. Multiple regression allows for you to include 
# multiple (potentially somewhat correlated) variables into the same model, and
# to idependently assess each's overall effect on the relationship. Let's do an
# example with all the x columns in the freeny dataset:
(lmod2 <- lm(y ~ lag.quarterly.revenue + price.index + 
                income.level + market.potential, freeny))

# This all can be accomplished with less writing by using the dot to say "all"
(lmod3 <- lm(y ~ ., freeny))

# It is only appropriate to compare different R² from different models if the
# dependent variable is the same, and the number of independent variables is the
# same. If the number of independent variables is not the same, you must first 
# adjust R² before comparison across models. This is automatically computed in
# the summary.
summary(lmod2)

# Typically, the more variables you include, the tighter your relationship will 
# be, since you capture more and more of the unexplained information with each 
# added variable, but where do you stop? Stepwise regression can help with this:
install.packages("olsrr")
library(olsrr)
ols_step_all_possible(lmod2)

### EXERCISE ###

# Which combination of continuous variables best explains mpg in the mtcars 
# dataset? What is the adjusted R-sq for this model?



carmod <- lm(mpg ~ disp + hp + drat + wt + qsec, mtcars)
carres <- ols_step_all_possible(carmod)
carres[which(carres[, 5] == max(carres[, 5])), ]
