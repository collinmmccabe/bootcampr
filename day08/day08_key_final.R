################################################################################
#                                                                              #
#                      Erdos Institute Code Bootcamp for R                     #
#                                 ------------                                 #
#                 Day 8 - Statistics with Categorical Variables                #
#                                 ------------                                 #
#                 Collin McCabe | collinmichaelmccabe@gmail.com                #
#                                                                              #
################################################################################

#-----------------#
# Chi-square Test #
#-----------------#

observed_coin1 <- c("heads" = 31, "tails" = 29)

chisq.test(observed_coin1)



observed_coin2 <- c("heads" = 20, "tails" = 40)

coin2 <- chisq.test(observed_coin2)

coin2$expected

library(tidyverse)
as_tibble(cbind(outcome = as.integer(c(coin2$observed, coin2$expected)), 
      o_e = c("O", "O", "E", "E"),
      h_t = rep(c("H", "T"), 2))) %>%
  ggplot(aes(x = h_t, y = outcome, fill = o_e)) +
  geom_bar(stat = "identity", position = "dodge") 



# What's a p-value?

set.seed(102040)

results <- NULL

for (i in 1:200) {
  test_sample <- sample(c(0, 1), 100, replace = TRUE)
  (test_obs <- c("heads" = sum(test_sample), 
                 "tails" = length(test_sample) - sum(test_sample)))
  results[i] <- ifelse(chisq.test(test_obs)$p.value < 0.05, 1, 0)
}

total_sig <- sum(results)
total_sig / 200

### EXERCISE 1 ###

# Would you expect thee counts of dice rolls by chance?

observed_dice <- c("one" = 5, "two" = 5, "three" = 5, 
                   "four" = 5, "five" = 5, "six" = 35)



dice_result <- chisq.test(observed_dice)
dice_result$observed
dice_result$expected

### EXERCISE 2 ###

# Do you have an equal number of manual and automatic transmissions in mtcars?
# How about an equal number of each type of cylinder?




res <- mtcars %>%
  select(am) %>%
  group_by(am) %>%
  summarize(n = n()) %>%
  select(n) %>%
  chisq.test()

res$expected

mtcars %>%
  select(cyl) %>%
  group_by(cyl) %>%
  summarize(n = n()) %>%
  select(n) %>%
  chisq.test()




#---------#
# t-tests #
#---------#

### One sample: compare a distribution to an expected mean ###

set.seed(42)
rnorm(200) %>%
  t.test(mu = 0)

### EXERCISE ###

# The morley dataset records many replicates of the measure of the speed of 
# light (all values are in km/sec minus 299000)- check to see if the mean is 
# different from 850



t.test(morley$Speed, mu = 850)

# Add 299000 back to all of the measurements- does this change your result? Why?



t.test(morley$Speed + 299000, mu = 299850)

### What about comparing two distributions? Two sample t-test: ###

# Do 4 cylinder cars have different highway mpg than 8 cylinder ones?
four <- mpg$hwy[mpg$cyl == 4]
eight <- mpg$hwy[mpg$cyl == 8]

t.test(four, eight)

t.test(four, eight, alternative = "greater")

t.test(four, eight, alternative = "less")

mpg %>%
  filter(cyl %in% c(4, 8)) %>%
  t.test(hwy ~ cyl, .)

mpg %>%
  filter(cyl %in% c(4, 8)) %>%
  ggplot(aes(hwy, colour = factor(cyl))) +
  geom_density()

### EXERCISE ###

# Compare petal length in the iris dataset between Species setosa and virginica

hist(iris$Petal.Length[iris$Species == "virginica"])

iris %>%
  filter(Species %in% c("setosa", "virginica")) %>%
  t.test(Petal.Length ~ Species, .)



# Do the same for Species virginica and versicolor





### What about if you want to compare between specific sets? Paired t-test: ###

# Example dataset and solution taken from cookbook for R: 
# http://www.cookbook-r.com/Statistical_analysis/t-test/
sleep %>%
  arrange(group, ID) %>%
  t.test(extra ~ group, ., paired = TRUE)

# Basis for plot taken from a StackOverflow answer: https://stackoverflow.com/questions/31102162/r-paired-dot-plot-and-box-plot-on-same-graph-is-there-a-template-in-ggplot2
sleep %>%
  arrange(group, ID) %>%
  ggplot(aes(y = extra)) +
  geom_point(aes(x = rep(c(1, 2), each = 10)), size = 5) +
  geom_line(aes(x = rep(c(1, 2), each = 10), group = ID)) +
  scale_x_discrete(limits=c("1", "2")) +
  labs(x = "Drug Group", y = "Additional Hours of Sleep", 
       title = "Paired t-test comparing effects of two drugs on sleep time") +
  theme_classic()

### EXERCISE ###

# Compare the weights of 17 patients before and after treatment for anorexia

install.packages("PairedData"); library(PairedData)
data(Anorexia); View(Anorexia)





#-------#
# ANOVA #
#-------#
  
# What if you want to compare the distributions of more than two variables?
  
result_anova <- mpg %>%
  filter(cyl != 5) %>%
  aov(hwy ~ factor(cyl), .)

summary(result_anova)

mpg %>%
  filter(cyl != 5) %>%
  group_by(cyl) %>%
  summarize(mean_hwy = mean(hwy), sd_hwy = sd(hwy), n = n()) %>%
  ggplot(mapping = aes(x = factor(cyl), y = mean_hwy, fill = factor(cyl))) +
  geom_bar(stat = "identity", color = "black", show.legend = FALSE) +
  geom_errorbar(aes(ymin = mean_hwy - (sd_hwy / sqrt(n)), 
                    ymax = mean_hwy + (sd_hwy / sqrt(n)),
                width = 0.5)) +
  labs(x = "Cylinders", y = "Mean Highway MPG", title = "hwy ~ cyl ANOVA") +
  theme_minimal()

TukeyHSD(result_anova)

### EXERCISE ###

# Compare the petal lengths of all three species in the iris dataset!



result_anova2 <- iris %>%
  aov(Petal.Length ~ factor(Species), .)

summary(result_anova2)

TukeyHSD(result_anova2)
