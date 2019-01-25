# code associated with exerpts of the data carpentry lessons
#http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-R.html
#http://www.datacarpentry.org/R-ecology-lesson/02-starting-with-data.html

# R can do math!
3+5           #Prints 8 to the console
12/7          #prints 1.714286 to the console

# The assignment operator (<-): storing values in variables

weight_kg <- 55    # doesn't print anything
(weight_kg <- 53)  # but putting parentheses around the call prints the value of `weight_kg`
weight_kg          # and so does typing the name of the object

# Example: unit conversions
weight_kg*2.2               #Output the weight in pounds to the console
weight_kg<-57.5             #Values of variables can be changed
weight_lb<-weight_kg*2.2    #Results of calculations can be assigned to new variables

## Exercise: operators
#### What are the values of each variable after each statement in the following?

mass <- 47.5            # mass?
age  <- 122             # age?
mass <- mass * 2.0      # mass?
age  <- age - 20        # age?
mass_index <- mass/age  # mass_index?

# Functions and their arguments 
## Functions have:
#   - Names
#   - Arguments - what they need to "know" to run that function; aka input; isn't modified
#   - Output - the result of whatever the function does; default is output to the console, 
#              can be assigned to variables; 

a<-9                 #assigns the value 9 to the variable a
b<-sqrt(a)           # sqrt is the function; value of a is the argument; output is assigned to b

round(3.14159)       #Round is the function, 3.14159 is the argument, output (3) goes to the console

args(round)          #lists the argument of the round function to the console

?round               #loads the documentation for the round function

round(3.14159, digits =2) #Rounds the output to 2 digits

# Determining data types

#Assign a number value to an object
x<-32
class(x) #numeric

#Assign text value to an object
y<-"hi"
class(y) #character

#Assign logical value to an object
z<- TRUE
class(z) #logical

#look for differences with type of
typeof(x) #double
typeof(y) #character
typeof(z) #logical

# Vectors
#   Vectors allow you to assign multiple values to one variable

weight_g<-c(50,60,65,82) #vector of numbers
animals<-c("mouse", "rat", "dog") #vector of strings


# Inspecting vectors

#how many values are in the vector?
length(weight_g)
length(animals)

#What type of values are in the vector?
class(weight_g)
class(animals)

# class, length, values
str(weight_g)
str(animals)

#adding to a vector
weight_g <- c(weight_g, 90) # add to the end of the vector
weight_g <- c(30, weight_g) # add to the beginning of the vector
weight_g



#Exercise: Class coercion - What types are these vectors?
  
num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")

#Hint: use class()

######################################## Factors ######################################

# Create a factor variable
sex <- factor(c("male", "female", "female", "male"))

#Outputs the factor labels (unique values in the column)
levels(sex)  #male/female

# Outputs how many levels are in the factor
nlevels(sex)                #2

#reoder the levels using the levels argument
sex <- factor(sex, levels = c("male", "female"))

## Exercise: 
ranks<- c("2", "5", "7", "3", "3")
ranks<-factor(ranks)
as.numeric(ranks)

#Subsetting vectors

#specify the index with square brackets

animals<-c("mouse", "rat", "dog", "cat")
animals[2] #displays the second element ("rat")

#can specify more than one element
animals[c(3,2)] #displays the third and second elements ("dog", "rat")

#can reuse elements, make longer vectors
animals[c(1,2,3,2,1,4)]

#Conditional Subsetting: subset by value, not position
# use logical expressions (TRUE/FALSE)

#with numbers
weight_g <- c(21, 34, 39, 54, 55) #weights
weight_tf<-weight_g>50  #evaluate each weight
#FALSE, FALSE, FALSE, TRUE, TRUE

#keeps trues
weight_g[weight_tf]
#same as
weight_g[weight_g>50]

#using boolean operators 
weight_g[weight_g < 30 | weight_g > 50]
weight_g[weight_g >= 30 & weight_g == 21]

#with text
animals <- c("mouse", "rat", "dog", "cat")

#returns cat
animals[animals == "cat"]

# returns both rat and cat
animals[animals == "cat" | animals == "rat"] 

# the %in% operator

#TRUE if value is in the right hand vector, FALSE otherwise
animals %in% c("rat", "cat", "dog", "duck", "goat")

#animals that are rats, cats, dogs, ducks or goats
animals[animals %in% c("rat", "cat", "dog", "duck", "goat")]

#Missing data: NA makes it harder to overlook missing data 
heights <- c(2, 4, 4, NA, 6)
mean(heights)

mean(heights, na.rm = TRUE)

## Extract those elements which are not missing values.

is.na(heights) #TRUE if missing
heights[is.na(heights)] #Only NA are TRUE -> keeps NA
!is.na(heights) #FALSE if missing
heights[!is.na(heights)] #Missing are FALSE -> removes NA

## Extract those elements which are complete cases. 
complete.cases(heights) #NAs are FALSE
heights[complete.cases(heights)] #Removes NA

## Returns the object with incomplete cases removed
na.omit(heights)

# Starting with data

# Load the data into R (read.csv is the function, file name is the argument, output stored in surveys)
surveys <- read.csv('data/raw_surveys.csv')

# Survey is a data frame:
### rows are observations
### columns are variables
### must be rectangular (same # rows and cols)
### each column must be filled with the same data type

# ways to inspect your data
head(surveys) #= look at first 6 rows (all columns)
str(surveys) #= structure # rows, cols, data types
nrow(surveys) #= number of columns
ncol(surveys) #= number of columns
names(surveys) #= column names
summary(surveys) #= does summary stats for each column

#Exercise: inspecting data frames
#Based on the output of str(surveys), can you answer the following questions?
 # What is the class of the object surveys?
 # How many rows and how many columns are in this object?
 # How many species have been recorded during these surveys?
  
################################## Subsetting ######################################################

############ With Bracets
#variable[row,column]

surveys[1,1] #first column, first row
surveys[4,5] #fourth row, fifth column

#subset entire row
surveys[5,] #fifth row

#subset entire column
surveys[,5] #fifth column

#subset a range of rows
surveys[1:10,] #rows 1 through 10
 
#subset a range of columns
surveys[,1:3] #cols 1 through 3

surveys[, c(1,4,7)] #columns 1, 4, and 7

############# Subsetting columns by name
dollar<-surveys$species_id         # Result is a vector
bracket<-surveys["species_id"]     # Result is a data.frame 
surveys[, "species_id"]            # Result is a vector
surveys[["species_id"]]            # Result is a vector 

dollar<-as.data.frame(dollar)      # Convertng a vector to a data.frame


# Exercise: Subsetting
#Create a data frame (surveys_200) containing only the observations from rows 1 to 200 of the surveys dataset.

#Use nrow() to subset the last row in surveys_200.

#Use nrow() to extract the row that is in the middle surveys_200. Store in a variable called surveys_mid

#### Write data to a new file

write.csv(surveys, "data/surveys.csv")
