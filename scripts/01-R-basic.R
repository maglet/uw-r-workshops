# code associated with exerpts of the data carpentry lessons
#http://www.datacarpentry.org/R-ecology-lesson/01-intro-to-R.html
#http://www.datacarpentry.org/R-ecology-lesson/02-starting-with-data.html

# R can do math!
3+5           #Prints 8 to the console
12/7          #prints 1.714286 to the console

# The assignment operator (<-): storing values in variables

weight_kg <- 55    # doesn't print anything
(weight_kg <- 53)  # but putting parenthesis around the call prints the value of `weight_kg`
weight_kg          # and so does typing the name of the object

# Example: unit conversions
weight_kg*2.2               #Output the weight in pounds to the console
weight_kg<-57.5             #Values of variables can be changed
weight_lb<-weight_kg*2.2    #Results of calculations can be assigned to new variables

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

# Vectors and datatypes
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
weight_g>50  #evaluate each weight
#FALSE, FALSE, FALSE, TRUE, TRUE

#keeps trues
weight_g[c(FALSE, FALSE, FALSE, TRUE, TRUE)]
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



#Missing data



# Starting with data

# Download the file (download.file is the function, the URL and destination file are arguments), 
          #no output

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

# Data types
### R guesses what type of data is in each column based on what's there (numeric or factor mostly)
### numeric = numbers
### factors = numbers with text labels (more on this later)
### If R guesses wrong, you can change it

surveys$record_id<-as.factor(surveys$record_id)  # converts the record id to a factor
surveys$record_id<-as.numeric(surveys$record_id) # if you convert it back to numeric, you get the 
                                                 # 1, 2, 3, 4 values, and you lose the text labels

nums<-c(1, 2, 3, "hi") # Created a column with mixed text and numbers
class(nums)            #converts the numbers to a character

ch<-as.numeric(nums)   # Convert the character vector to numeric, gets warning
ch                     # "hi" gets converted to NA because it can't be interpreted as a number

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

######################################## Factors ######################################

# Create a factor variable
sex <- factor(c("male", "female", "female", "male"))

#Outputs the factor labels (unique values in the column)
levels(sex)  #male/female
levels(surveys$species_id) #all the different species represented 

# Outputs how many levels are in the factor
nlevels(sex)                #2
nlevels(surveys$species_id) #48

#reoder the levels using the levels argument
sex <- factor(sex, levels = c("male", "female"))

############ Plotting with factors

plot(surveys$sex)                          # Makes a bar graph with charts
levels(surveys$sex)[1] <- "missing"        # change the first label to “missing”

## Compare the difference between when the data are being read as 
## `factor`, and when they are being read as `character`. 

surveys <- read.csv("data/portal_data_joined.csv", 
                    stringsAsFactors = TRUE) 
str(surveys) 

surveys <- read.csv("data/portal_data_joined.csv", 
                    stringsAsFactors = FALSE) 
str(surveys) 

## Convert the column "plot_type" into a factor 
plot(surveys$plot_id) #plots value by index

#convert from numeric to factor
surveys$plot_type <- factor(surveys$plot_type)

plot(surveys$plot_id) #plots count of each factor

#### Write data to a new file
surveys200<-surveys[1:200,]
write.csv(surveys200, "data/surveys200.csv")
