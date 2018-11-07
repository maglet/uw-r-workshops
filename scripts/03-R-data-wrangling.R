######################### Data wrangling in R ######################
#### Based on the data carpentry ecology lessons: 
####       http://www.datacarpentry.org/R-ecology-lesson/03-dplyr.html

#installing packages
#install.packages("tidyverse")
library("tidyverse")

surveys <- read_csv('data/portal_data_joined.csv')
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

surveys %>%
       mutate(weight_kg = weight / 1000, 
              weight_kg2 = weight_kg *2)

surveys %>%
       mutate(weight_kg = weight / 1000) %>%
       head

surveys %>%
       filter(!is.na(weight)) %>%
       mutate(weight_kg = weight / 1000)%>%
       head

#removing missing values
surveys %>%
       filter(!is.na(weight)) %>%
       mutate(weight_kg = weight / 1000)%>%
       head

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

surveys %>%
       summarize(mean_weight = mean(weight, na.rm = TRUE))

grouped_surveys<-surveys %>%
       group_by(sex) %>%
       summarize(mean_weight = mean(weight, na.rm = TRUE))

surveys %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight, na.rm = TRUE))

surveys %>%
       filter(!is.na(weight)) %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight))

surveys %>%
       filter(!is.na(weight)) %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight)) %>%
       print(n = 15)

surveys %>%
       filter(!is.na(weight)) %>%
       group_by(sex, species_id) %>%
       summarize(mean_weight = mean(weight),
                 min_weight = min(weight))

#Tally

surveys %>%
       group_by(sex) %>%
       tally

################################# Exercise 3 ####################################################################
#How many individuals were caught in each plot_type surveyed?
       #Use group_by() and summarize() to find the mean, min, and max hindfoot length for each species (using species_id).
       #What was the heaviest animal measured in each year? Return the columns year,  genus, species_id, and weight.
       #You saw above how to count the number of individuals of each sex using a combination of group_by() and tally(). 
       #How could you get the same result using group_by() and summarize()? Hint: see ?n.

#Individuals per plot type
surveys %>%
       group_by(plot_type)%>%
       tally

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
       select(year, genus, species_id) %>%
       arrange(year)
       
big_species<- big_animal %>%
       filter(max(weight))

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
#Goal: look at the relationship between mean values of weight and hindfoot 
#length per year in different plot types. 

#Step 1: Use gather() to create a dataset where we have a key column called 
#measurement and a value column that takes on the value of either 
#hindfoot_length or weight. 

long_data<-surveys%>%
       gather(key = measurement, #new col from col headers
              value = value,     #values
              hindfoot_length, weight) #columns to gather

#Step 2: Calculate the average of each measurement in each year 
#for each different plot_type. 

mean_values<-long_data %>%
       filter(!is.na(value))%>%
       group_by(measurement, plot_type, year)%>%
       summarise(mean = mean(value))
       
#Step 3: spread() them into a data set with a column 
#for hindfoot_length and weight. 

mean_values%>%
       spread(key = measurement, 
              value = mean)

########################### Data Cleaning ################################################################
surveys_complete <- surveys %>% 
       filter(species_id != "", # remove missing species_id 			         		
              !is.na(weight), # remove missing weight 	      	 				
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
write_csv(surveys_complete, path = "data/surveys_complete.csv")
