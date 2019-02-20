######################### Data wrangling in R ######################
#### Based on the data carpentry ecology lessons: 
####       http://www.datacarpentry.org/R-ecology-lesson/03-dplyr.html

#installing packages
#install.packages("tidyverse")
library("tidyverse")

surveys_dot <- read.csv('data/raw_surveys.csv')
surveys_dot
str(surveys_dot)

surveys <- read_csv('data/raw_surveys.csv')
surveys
str(surveys)

############################## The Verbs! ################################

### Select
select(surveys, plot_id, species_id, weight) 

### Filter
filter(surveys, year == 1995) 

###pipes
surveys %>%
       filter(weight<5) %>%
       select(species_id, sex, weight)

surveys_sml <- surveys %>%
       filter(weight < 5) %>%
       select(species_id, sex, weight)

surveys_sml


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
mutate(surveys, weight_kg = weight/1000)

#same as
surveys %>%
       mutate(weight_kg = weight / 1000)

# add 2 new columns at once
surveys %>%
       mutate(weight_kg = weight / 1000, 
              weight_kg2 = weight_kg *2)

# remove missing values

surveys %>%
       filter(!is.na(weight)) %>%
       mutate(weight_kg = weight / 1000)

#removing missing values
surveys %>%
       filter(!is.na(weight)) %>%
       mutate(weight_kg = weight / 1000)

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

#Split-apply-combine with summarize

# create a summary of the weight variable
grouped_surveys<-surveys %>%
       summarize(mean_weight = mean(weight, na.rm = TRUE))
#not very informative w/o group by

#group by then summarize creats a summary table
grouped_surveys<-surveys %>%
       group_by(sex) %>%
       summarize(mean_weight = mean(weight, na.rm = TRUE))

#group by multiple variables
grouped_surveys<- surveys %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight, na.rm = TRUE))

#remove missing data with is.na
surveys %>%
       filter(!is.na(weight)) %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight))

#calculate  multiple summary statistics
grouped_surveys<-surveys %>%
       filter(!is.na(weight)) %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight),
                 min_weight = min(weight))

#Counting observations in categories

# count observation in each category
surveys %>% 
  count(sex)

#Same as
surveys %>% 
  group_by(sex) %>% 
  summarize(count = n())

# group by multiple variables
surveys %>% 
  count(sex,  species)

#sort by 2 things
surveys %>% 
  count(sex,  species) %>%
  arrange(species, #alphabetical
          desc(n)) #descending

################################# Exercise 3 ####################################################################
#How many individuals were caught in each plot_type surveyed?
       #Use group_by() and summarize() to find the mean, min, and max hindfoot length for each species (using species_id).
       #What was the heaviest animal measured in each year? Return the columns year,  genus, species_id, and weight.
       #You saw above how to count the number of individuals of each sex using a combination of group_by() and tally(). 
       #How could you get the same result using group_by() and summarize()? Hint: see ?n.

#Individuals per plot type
surveys %>%
       count(plot_type)

#hfl by species
surveys %>%
       group_by(species_id) %>%
       filter(!is.na(hindfoot_length))%>%
       summarize(mean_hfl = mean(hindfoot_length), 
                 min_hfl = min(hindfoot_length), 
                 max_hfl = max(hindfoot_length))

#heavist animal measured in each year
big_animal<- surveys %>% 
       filter(!is.na(weight)) %>%
       group_by(year) %>%
       filter(weight == max(weight)) %>%
       select(year, genus, species_id, weight) %>%
       arrange(year)

########################### Spread ############################################
surveys_gw <- surveys %>%
       filter(!is.na(weight)) %>%
       group_by(genus, plot_id) %>%
       summarize(mean_weight = mean(weight))

str(surveys_gw)

surveys_spread <- surveys_gw %>%
       spread(key = genus, value = mean_weight)

str(surveys_spread)

surveys_gw %>%
       spread(genus, mean_weight, fill = 0) %>%
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
#What colmns have missing values

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
