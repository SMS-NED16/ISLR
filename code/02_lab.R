# MASS is a very large collection of datasets and functions
library(MASS)

# ISLR2 includes datasets associated with the book 
library(ISLR2)


# SIMPLE LINEAR REGRESSION ------------------------------------------------------------------------------------------------
# ISLR2 contains the Boston dataset which contains median house value (medv)
# for 506 census tracts in Boston. We will try to predict this using 12 predictors
head(Boston)

# Data dictionary and more information
?Boston

# Use the `lm` function to fit a simple linear regression model 
# medv is the response, and lstat (lower status of population as percentage) is predictor 
lm.fit <- lm(medv ~ lstat, data = Boston) # Need to specify data otherwise R doesn't know what `medv`/`lstat` are

# Alternatively, could workaround this by using `attach`
# attach(Boston)
# lm.fit <- lm(medv ~ lstat) 

# Examine lm.fit to see p-values, t-statistics, F-statistics, R^2 statistic
summary(lm.fit)

# Use the `names` function find all other info stored in the lm.fit object
names(lm.fit)

# Can use these names to extract components, but better to do with extractor functions 
# lm.fit[['coef']]        # This works, but is not a good practice 
coef(lm.fit)              # This works and is a good practice

# Obtain confidence interval for coefficient estimates 
confint(lm.fit)

# `predict` can be used to produce confidence intervals and predictions intervals for `medv` given `lstat`
cbind(
  'lstat_test' = c(5, 10, 15),
  predict(lm.fit, data.frame(lstat = c(5, 10, 15)), interval = 'confidence')     # These are new values of the predictor
)

# Can do the same thing to get the prediction interval
cbind(
  'lstat_test' = c(5, 10, 15),
  predict(lm.fit, data.frame(lstat = c(5, 10, 15)), interval = 'prediction')     # These are new values of the predictor
)

# Plot the target and response along with their least squares regression line 
# The plot shows evidence of non-linearity in the relationship between `lstat` and `medv`
plot(Boston$lstat, Boston$medv)
abline(lm.fit)

# abline can be used to draw any line, not just the least squares regression line 
abline(lm.fit, lwd = 3)
abline(lm.fit, lwd = 3, col = 'red')

# Lines disappear, data points re-rendered, displayed in Red
plot(Boston$lstat, Boston$medv, col = 'red')

# Change the plotting symbol
plot(Boston$lstat, Boston$medv, pch = 20)
plot(Boston$lstat, Boston$medv, pch = '+')

# Plot that shows the symbol mapped to each pch code
plot(1:20, 1:20, pch = 1:20)

#### Diagnostic Plots ####
# Can display 4 diagnostic plots just by calling the `plot` function on the `lm.fit` object 
plot(lm.fit)  # Hit enter to cycle through plots

# More useful to see all four in the same frame - use par(mfrow)
par(mfrow = c(2, 2)) 
plot(lm.fit)

# Can also compute residuals from a linear regression fit using the `residuals` function 
# `rstudent` returns the studentized residuals which can then be plotted 
plot(predict(lm.fit), residuals(lm.fit))  # Predictions vs studentized residuals
plot(predict(lm.fit), rstudent(lm.fit))   # Both have same distribution, but residuals rescaled

# Based on residuals, there is evidence of non-linearity. 

# Compute Leverage statistics 
plot(hatvalues(lm.fit))

# Identify the index of the largest element of a vector - this is the element with the largest leverage
which.max(hatvalues(lm.fit))


# MULTIPLE LINEAR REGRESSION --------------------------------------------------------------------------------------------
# Using only two variables in the dataset
lm.fit <- lm(medv ~ lstat + age, data = Boston)
summary(lm.fit)

# Using all the variables in the dataset, without manually typing out the variable names 
lm.fit <- lm(medv ~ ., data = Boston)
summary(lm.fit)

# Age and industry are not correlated with the outcome
?summary.lm

# Access individual elements of the summary object by name 
summary(lm.fit)$r.sq      # Regression explains 73.4% of variance in the data 
summary(lm.fit)$sigma     # Residual standard error - how much a given prediction deviates from population regression line

# Variance Inflation Factor - identify correlated factors/factors with collinearity 
# Requires car package - installation failed for my machine, too lazy to debug 
# car::vif(lm.fit)

# Regression using all but one variable - exclude by name in the formula
lm.fit1 <- lm(medv ~ . - age, data = Boston)
summary(lm.fit)

# Could also use the `update` function for this 
lm.fit1 <- update(lm.fit, ~ . - age)    # Refits the linear model using updated formula

# INTERACTION TERMS --------------------------------------------------------------------------------------------------------------
# lstat:black -> ONLY an interaction term between lstat and black 
# lstat * age -> lstat + age + interaction term
summary(lm(medv ~ lstat * age, data = Boston))

# Age is not significant, but interaction term is mildly significant - must include both because of hierarchical nature of modeling 


# NON LINEAR PREDICTOR TRANSFORMATIONS ------------------------------------------------------------------------
# Can create predictors like X^2 - the I() syntax is needed because ^ is a keyword with a different meaning in R 
# Regress medv onto lstat and lstat^2 
lm.fit2 <- lm(medv ~ lstat + I(lstat ^ 2), data = Boston)
summary(lm.fit2)

# Near zero p-value associated with the quadratic term --> improved model. 
# Can use the `anova` function to further quantity the extent to which quadratic fit is superior to linear fit 
lm.fit <- lm(medv ~ lstat, data = Boston) 
lm.fit2 <- lm(medv ~ lstat + I(lstat ^ 2), data = Boston) 
anova(lm.fit, lm.fit2)

# anova function performs a hypothesis test for the null hypothesis that both models fit the data equally well
# The f-statistic is 135.2, which is >>>1, and the probability associated w/statistic is very low 
# This means we can reject null hypothesis and accept alternate: that the two models do not perform equally well
# More specifically, the non-linear model performs better

# Check residuals and other plots for the lstat^2 model 
par(mfrow = c(2, 2))
plot(lm.fit2)    # Residuals are now relatively normally disributed 

# Create an arbitrarily ordered polynomial fit 
lm.fit5 <- lm(medv ~ poly(lstat, 5), data = Boston)
summary(lm.fit5)

# no polynomial term beyond the 5th have significant p values 

# Can also try a log transformation
summary(lm(medv ~ log(rm), data = Boston))

# QUALITATIVE PREDICTIONS --------------------------------------------------------------------------------------------------
# Predict Sales as a function of variables available in Carseats - some of these are qualitative 
head(Carseats)

# ShelveLoc / Urban / US are all qualitative predictors 
# R can generate dummy variables for qualitative variables automatically 
# Includes all features with terms for Income, Advertising, Income * Advertising as well as 
# Price, Age, and Price * Age -> combining quantitative with qualitative variables
lm.fit <- lm(formula = Sales ~ . + Income:Advertising + Price:Age, data = Carseats)

# Variables have been created for ShelveLoc Good/Medium, UrbanYes, and USYes, as well as interaction terms
lm.fit

# `contrasts` returns the coding that R uses for the dummy variables 
contrasts(Carseats$ShelveLoc)


summary(lm.fit)

# ShelveLocGood has a higher coefficient than ShelveLocMedium -> Good has a higher effect on sales 
# relative to a bad location, and Medium has a lower effect on sales relative to a bad location.

# WRITING FUNCTIONS --------------------------------------------------------------------------------------------------------------
# Write a function that loads the required libraries for all future exercises and labs 
LoadLibraries <- function(){
  library(MASS)
  library(ISLR2)
  print("The libraries have been loaded")
}
