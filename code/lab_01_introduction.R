# BASIC COMMANDS ----------------------------------------------------------
# Make a vector named `x` with integers 
x <- c(1, 3, 2, 5)
x

# Can also use the `=` operator for assignment, though this is discouraged
(x = c(1, 6, 2))
(y = c(1, 4, 3))

# Check lengths of two vectors and add corresponding elements 
if (length(x) == length(y)) {
  (x + y)
}

# Display all variables in workspace 
ls()

# Remove any variables that we don't want to keep in workspace 
rm(x, y)

# Also possible to remove all objects at once 
rm(list = ls())

# Check documentation for matrix function 
?matrix

# Make a matrix 
(x <- matrix(data = c(1, 2, 3, 4), nrow = 2, ncol = 2))

# Make a matrix but let R infer arguments 
(x <- matrix(c(1, 2, 3, 4), 2, 2))

# Populate matrix values in order of rows 
(x <- matrix(data = c(1, 2, 3, 4), nrow = 2, ncol = 2, byrow = TRUE))

# Square root and power 
sqrt(x)
x^2

# Check correlation between two sets of random normal numbers 
x <- rnorm(50) 
y <- x + rnorm(50, mean = 50, sd = .1) 
cor(x, y)

# Make random numbers reproducible by seeding random number generator 
set.seed(1303) 
rnorm(50)

# Compute mean, variance, and standard deviation of a vector of numbers 
set.seed(3)
y <- rnorm(100) 
mean(y) 
var(y)
sqrt(var(y))  # Standard deviation 
sd(y)         # Same as above

# GRAPHICS ---------------------------------------------------------------
# plot is the main function for generating plots with R
?plot

x <- rnorm(100) 
y <- rnorm(100) 
plot(x, y)          # Scatter plot of x and y

# Plot with labels
plot(x, y, xlab = 'This is the x-axis', ylab = 'This is the y-axis', main = 'Plot of X vs Y')

# Write plot to a PDF object and close the connection 
pdf("~/Desktop/code/islr_v2/lab_01_figure_01.pdf")
plot(x, y, col = 'green' , xlab = 'This is the x-axis', ylab = 'This is the y-axis', main = 'Plot of X vs Y')
dev.off() 

# Different ways to make a sequence of numbers 
(x <- seq(1, 10))
(x <- 1:10)           # Shorthand for above
(x <- seq(-pi, pi, length = 50))  # Doesnt' have to be integers

# contour - used to make a 2D representation of 3D data, each contour has same value of z 
y <- x 
f <- outer(x, y, function(x, y) cos(y) / ( 1 + x^2))
contour(x, y, f)                          # Basic contour plot 
contour(x, y, f, nlevels = 45, add = T)   # Increases contour count - adds extra contours to existing plot instead of generating from scratch 
fa <- (f - t(f)) / 2                      # Subtract transpose of f from f     
contour(x, y, fa, nlevels = 15)           # Cool plot

# `image` function can be used to represent 3D information with color coding 
image(x, y, fa)

# `persp` function makes a truly 3D plot 
persp(x, y, fa)

# `theta` controls pitch angle 
persp(x, y, fa, theta = 30)

# `phi` controls azimuth angle 
persp(x, y, fa, theta = 30, phi = 20)
persp(x, y, fa, theta = 30, phi = 70)
persp(x, y, fa, theta = 30, phi = 40)

# INDEXING DATA -----------------------------------------------------------
(A <- matrix(1:16, 4, 4))

# Get element from 2nd row, 3rd column 
A[2, 3]

# Select multiple rows and columns at the same time 
A[c(1, 3), c(2, 4)]   # Elements from rows 1 and 3, columns 2 and 4
A[1:3, 2:4]           # ALL elements from rows 1:3, ALL elements from columns 2 to 4
A[1:2, ]              # ALL elements from rows 1:2
A[, 1:2]              # ALL elements from columns 1:2

# R treats a single row or column of a matrix as a vector 
A[1, ]
is.vector(A[1,])

# Using a negative sign tells R to keep all rows or columns EXCEPT the ones specified 
A[-c(1, 3), ]         # All rows except 1st and 3rd

# Number of rows and number of columns of a matrix 
dim(A)


# LOADING DATA ------------------------------------------------------------
setwd("~/Desktop/code/islr_v2/")
auto.data.filepath <- paste0("./data/Auto.data")
auto.csv.filepath <- paste0("./data/Auto.csv")
Auto <- read.table(auto.data.filepath)        # Read the data 
View(Auto)                                    # Examine it in a spreadsheet viewer
head(Auto)                                    # Examine first few rows

# Dataset not loaded correctly - column headers imported as rows, and missing values not encoded properly 
Auto <- read.table(auto.data.filepath, header = T, na.strings = "?", stringsAsFactors = T)

# header = T tells R to read first row as the column headers of the dataset 
# na.strings = "?" tells R to replace any occurrences of "?" with NA - missing value indicator 
# stringsAsFactors = T tells R to assume any column with strings should be treated as a categorical 
# variable, and each distinct value of the string within that variable should be treated as as unique 
# level of category of that variable
View(Auto)
dim(Auto)

# Use the read.csv function to read data from a CSV 
Auto <- read.csv(auto.csv.filepath, na.strings = "?", stringsAsFactors = T)
View(Auto)
dim(Auto)
Auto[1:4, ]

# If not a lot of rows with missing data, just drop the rows 
colSums(is.na(Auto))    # Only 5 rows with missing data in `horsepower`
Auto <- na.omit(Auto)
dim(Auto)

# Check variable names 
names(Auto)


# ADDITIONAL GRAPHICAL AND NUMERICAL SUMMARIES ----------------------------
# Make scatterplots of the numerical variables in the dataset 
plot(Auto$cylinders, Auto$mpg)

# If we don't want to reference the dataset every time, can make the dataset available for referencing automatically 
attach(Auto)
plot(cylinders, mpg)      # Don't need to reference columns through the dataframe object now

# Boxplots are generated when the variable passed for the x-axis is qualitative
# Customize the boxplot 
plot(cylinders, mpg)
plot(cylinders, mpg, col = 'red')                   # Data points are now red colored
boxplot(cylinders, mpg, col = 'red', varwidth = T)     
boxplot(cylinders, mpg, col = 'red', varwidth = T, xlab = 'cylinders', ylab = 'MPG')

# `hist` plots a histogram
hist(mpg)
hist(mpg, col = 'red')
hist(mpg, col = 2)                # Same as above
hist(mpg, col = 2, breaks = 15)   # Make 15 bins

# `pairs` makes a scatterplto matrix - a scatterplot for every pair of variables 
pairs(Auto)

# Can also make scatterplots for a subset of the variables 
pairs(
  ~ mpg + displacement + horsepower + weight + acceleration, 
  data = Auto
)

# `identify` function can be used to extract the coordinates or data point info about a 
# a particular data point from a plot
plot(horsepower, mpg)
identify(horsepower, mpg, name)    # `name` will be printed for the data point w/ `horspower`, `mpg` we will select 

# `summary` produces a numerical summary of each variable in the dataset 
summary(Auto)   

# can also produce a `summary` of a single variable 
summary(mpg)