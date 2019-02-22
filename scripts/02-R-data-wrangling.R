######################### Data wrangling in R ######################
#### Based on the data carpentry ecology lessons: 
####       http://www.datacarpentry.org/R-ecology-lesson/03-dplyr.html

#installing packages
#install.packages("tidyverse")

#loading packages
library("tidyverse")

#read the data as a data frame
surveys_dot <- read.csv("data/raw_surveys.csv")
surveys_dot
str(surveys_dot)

#read the data as a 'tibble'
surveys <- read_csv('data/raw_surveys.csv')
surveys
str(surveys)

############################## The Verbs! ################################

### Select
select(surveys,      #the data
       weight)       #selects the weight column

#same as
tibble(surveys$weight)

#select multiple columns
select(surveys,      #the data
       plot_id,      #selects the plot_id column
       species_id,   #selects the species_id column
       weight)       #selects the weight column


### Filter
filter(surveys, year == 1995) 

#same as 
surveys[surveys$year == 1995, ]

#filter by multiple attributes

filter(surveys,          #the data
       year == 1995 &    #filter for rows that have 1995 in year column
       sex == "F")       #filter for rows that have F in the sex column

#same as 
surveys[surveys$year == 1995 & surveys$sex == "F", ]

###pipes
surveys %>%                             #the data then
       filter(weight<5) %>%             #filter for rows where weight is less than 5 then
       select(species_id, sex, weight)  #select the species_id, sex, and weight columns

surveys_sml <- surveys %>%              # saves to a new object
       filter(weight < 5) %>%
       select(species_id, sex, weight)

surveys_sml                             #prints object to console


#Exercise #1: 
### Using pipes, subset the survey data to include individuals collected 
###     before 1995 and retain only the columns year, sex, and weight.

surveys %>%
       filter(year == 1995) %>%
       select(year, sex, weight)

#                   OR
surveys %>%
       select(year, sex, weight) %>%
       filter(year == 1995)

### Mutate
mutate(surveys,                          #the data
       weight_kg = weight/1000)          #a new column definition
                                         #creates a new column called weight_kg
                                         #that holds the corresponding weight value / 1000

#same as
surveys %>%                              #the data
       mutate(weight_kg = weight / 1000) #see above 

# add 2 new columns at once
surveys %>%                              #the data
       mutate(weight_kg = weight / 1000, #see above
              weight_kg2 = weight_kg *2) #creates a column called weight_kg2
                                         #that holds the value weight_kg*2

##### Exercise 2 
#Create a new data frame from the survey data that meets the following criteria: 
# * contains only the species_id column and a new column called hindfoot_half containing 
# values that are half the hindfoot_length values. 
# * In this hindfoot_halfcolumn, there are no NAs and all values are less than 30.
#Hint: think about how the commands should be ordered to produce this data frame!

surveys%>%
  filter(year>1990)%>%
  mutate(hindfoot_half = hindfoot_length/2) %>%
  select(species_id, hindfoot_half)

# create a summary of the weight variable
grouped_surveys<-surveys %>%
       summarize(mean_weight = mean(weight,         #summary statistic
                                    na.rm = TRUE))  #ignore NAs
#not very informative w/o group by

#group by then summarize creats a summary table
grouped_surveys<-surveys %>%
       group_by(sex) %>%                            #categorical variable
       summarize(mean_weight = mean(weight,         #see
                                    na.rm = TRUE))  #   above

#group by multiple variables
grouped_surveys<- surveys %>%
       group_by(sex, species_id) %>%                #two categoriacl variables
       summarize(mean_weight = mean(weight,         #see
                                    na.rm = TRUE))  #   above

#remove missing data with is.na
surveys %>%
       filter(!is.na(weight)) %>%               #remove NAs
       group_by(sex, species_id) %>%            #make rows for sex and species id
       summarize(mean_weight = mean(weight))    #create mean_weight stat

#filtering makes it easy to calculate  multiple summary statistics
grouped_surveys<-surveys %>%
       filter(!is.na(weight)) %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight),
                 min_weight = min(weight))      #calculate a second stat

#Counting observations in categories

# count observation in each category
surveys %>%              #the data
  count(sex)             #variable to count by

#Same as
surveys %>%                 #the data
  group_by(sex) %>%         #the variable to coutn by
  summarize(count = n())    #summarize with the count function

# group by multiple variables
surveys %>%                 #the data
  count(sex,  species)      #count by 2 variables

#sort by 2 things
surveys %>%                      #the data
  count(sex,  species) %>%       #count by 2 variables
  arrange(species,               #arrange alphabetical
          desc(n))               #arrange descending

################################# Exercise 3 ####################################################################
#How many individuals were caught in each plot_type surveyed?
       #Use group_by() and summarize() to find the mean, min, and max hindfoot length for each species (using species_id).
       #What was the heaviest animal measured in each year? Return the columns year,  genus, species_id, and weight.
       #You saw above how to count the number of individuals of each sex using a combination of group_by() and tally(). 
       #How could you get the same result using group_by() and summarize()? Hint: see ?n.

#Individuals per plot type
surveys %>%
       count(plot_type) #count the number of records for each plot type

#hfl by species
surveys %>%
       group_by(species_id) %>%            # group by species id
       filter(!is.na(hindfoot_length))%>%  # filter out missing values
       summarize(mean_hfl = mean(hindfoot_length), #calculate
                 min_hfl = min(hindfoot_length),       #summary
                 max_hfl = max(hindfoot_length))         #statistics

#heavist animal measured in each year
big_animal<- surveys %>%                            # the data
       filter(!is.na(weight)) %>%                   # remove missing values
       group_by(year) %>%                           # group by year
       filter(weight == max(weight)) %>%            # filter to keep only max value
       select(year, genus, species_id, weight) %>%  # select columns
       arrange(year)                                # arrange by year.

########################### Spread ############################################
#find the most abundant species
surveys%>%
  count(species_id)%>%
  arrange(desc(n))

#subset on the columns you want
surveys_sp<-surveys %>%
  filter(!is.na(weight), species_id=="DM")%>%
  group_by(sex, plot_type)%>%
  summarize(mean_weight = mean(weight))

#spread to make a table with rows for plots and cols for sex
surveys_spread<-surveys_sp%>%
  spread(key = sex, value = mean_weight)


#plot
ggplot(surveys_sp, aes(x = plot_type, y = mean_weight, color = sex))+
  geom_point()


surveys_gw <- surveys %>%
       filter(!is.na(weight)) %>%
       group_by(genus, plot_id) %>%
       summarize(mean_weight = mean(weight))

str(surveys_gw)

surveys_spread <- surveys_gw %>%
       spread(key = genus, value = mean_weight)

str(surveys_spread)

surveys_gw %>%
       spread(key = genus, value = mean_weight, fill = 0) %>%
       head()

############################### Gather ######################################### 
surveys_gather <- surveys_spread %>%
       gather(key = genus, value = mean_weight, -plot_id)

str(surveys_gather)

surveys_spread %>%
       gather(key = genus, value = mean_weight, Baiomys:Spermophilus) %>%
       head()

################### Exercise 4
#Spread the surveys data frame with year as columns, plot_id as rows, and the number of genera per plot as the values. Hints: 
 # 1. Summarize before reshaping
## use the function n_distinct() to get the number of unique genera 

ex4<-surveys %>%
  group_by(plot_id, year)%>%
  summarize(genera=n_distinct(genus))%>%
  spread(key = year, value = genera)

# 2. Now take that data frame and gather() it again, so each row is a unique plot_id by year combination.

ex4 %>% 
  gather(key = year, value =  n, "1977":"2002")

########################### Data Cleaning ################################################################
#What colmns have missing values?

long_surveys<-surveys%>%
  gather(key = metric, 
         value = value)

na_table<-long_surveys%>%
  group_by(metric)%>%
  summarize(nas = sum(is.na(value)))

# 3 cols with NAs: sex, weight, hindfoot length

#remove missing values
surveys_complete <- surveys %>% 
       filter(!is.na(weight), # remove missing weight 	      	 				
              !is.na(hindfoot_length), # remove missing hindfoot_length 
              sex != "") # remove missing sex


## Extract the most common species_id 
species_counts <- surveys_complete %>%
       group_by(species_id) %>% 
       tally %>% 
       filter(n >= 50) 
## Only keep the most common species 
surveys_complete <- surveys_complete %>% 
       filter(species_id %in% species_counts$species_id)

################################# Exporting data #######################################################
write_csv(surveys_complete, path = "data/complete_surveys.csv")
