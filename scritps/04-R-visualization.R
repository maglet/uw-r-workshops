## Code obtained from Data Carpentry Ecology Lesson
####  http://www.datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html

# plotting package
library(ggplot2)
# modern data frame manipulations
library(dplyr)
library(readr)

################## Load data ###################################################
surveys_complete <- read_csv('data/surveys_complete.csv')

###################### Scatterplots  ###########################################
#Basic graph elements
# Step 1: specify the data to be plotted
ggplot(data = surveys_complete)
#opens a plot window, but doesn't graph anything

# Step 2: specify what to put on each axis
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length))
#opens a plot window and draws axes

# Step 3: specify the geometry 
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) + 
       geom_point()
#opens a plot window, draws axes, and draw points for each row of the data frame

# Add transparency with the alpha argument to geom_pont
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
       geom_point(alpha = 0.1)

# Add color with the color argument to geom_point
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
       geom_point(alpha = 0.1, color = "blue")

# Add color by species with color argument to aes
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
       geom_point(alpha = 0.1, aes(color=species_id))
#aes in geom_point specifies only for the point

# aes argument to ggplot specifies for the whole graph, 
ggplot(data = surveys_complete, aes(x = weight, 
                                    y = hindfoot_length, 
                                    color=species_id)) +
       geom_point(alpha = 0.1)

################## Exercise 1 #################################################
#Use the previous example as a starting point.

#Add color to the data points according to the plot from which the sample was 
#taken (plot_id).

#Hint: Check the class for plot_id. Consider changing the class of plot_id from 
#integer to factor. Why does this change how R makes the graph?


############## Boxplots ###################################################
# Make a boxplot 
ggplot(data = surveys_complete, aes(x = species_id,         # factor variable
                                    y = hindfoot_length)) + # numeric variable
       geom_boxplot()

# Overlay points on a boxplot
ggplot(data = surveys_complete, aes(x = species_id, y = hindfoot_length)) +
       geom_boxplot(alpha = 0) +
       geom_jitter(alpha = 0.3, 
                   color = "tomato")

################### Exercise 2 #################################################
# Plot the same data as in the previous example, but as a Violin plot
# Hint: see geom_violin().

# What information does this give you about the data that a box plot does?

################### Time series data ###########################################
#reshape the data
yearly_counts <- surveys_complete %>%
       group_by(year, species_id) %>%
       tally
# Output: a data frame with year, species_id and n, where n is the number
#         of observations of a species in a given year

#Plot n vs. year
ggplot(data = yearly_counts, aes(x = year, # year on the x axis
                                 y = n)) + # n on the y axis
       geom_line()
#Combines number of all species into one line

#One line for each species
ggplot(data = yearly_counts, 
       aes(x = year, y = n, 
           group = species_id)) +  # make a new line for each species id
       geom_line()

# add color by species
ggplot(data = yearly_counts, aes(x = year, y = n, group = species_id, 
                                 color = species_id)) + # add color to create legend
       geom_line()

#################### Exercise 3 ################################################
#Use what you just learned to create a plot that depicts how the average 
#weight of each species changes through the years.


################### Using pre-made themes ######################################

#Apply a theme
ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
       geom_line() +
       theme_bw()          # see ?theme_bw for this and other themes

################ Customizing themes ############################################

#Change axis labels and titles
ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
       geom_line() +
       labs(title = 'Species count over time',
            x = 'Year of observation',
            y = 'Count') +
       theme_bw()

#Change font size
ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
       geom_line() +
       labs(title = 'Species count over time',
            x = 'Year of observation',
            y = 'Count') +
       theme_bw() +
       theme(text=element_text(size=16, family="Arial"))

#################### Save a customized theme ###################################
arial_theme <- theme_bw() + theme(text=element_text(size=16, family="Arial"))

#Apply saved theme
ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
       geom_boxplot() +
       arial_theme

##################### Save your plot ###########################################

#save plot to a variable
my_plot <- ggplot(data = yearly_counts, aes(x = year, y = n, color = species_id)) +
       geom_line() +
       labs(title = 'Observed species in time',
            x = 'Year of observation',
            y = 'Number of species') +
       theme_bw() +
       theme(axis.text.x = element_text(colour="grey20", size=12, angle=90, 
                                        hjust=.5, vjust=.5),
             axis.text.y = element_text(colour="grey20", size=12),
             text=element_text(size=16, family="Arial"))

# save plot to a file
ggsave("name_of_file.png", my_plot, width=15, height=10)

###################### FIN #####################################################
