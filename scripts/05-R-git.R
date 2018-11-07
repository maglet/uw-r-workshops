# load packages


library(tidyverse)

surveys_complete <- read_csv("data/surveys_complete.csv")

ggplot(data = surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length)) + 
          geom_point(alpha = 0.1, 
                     color = "blue")

ggplot(data = surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length, 
           color = species_id)) + 
          geom_smooth(color = "black")+ #this makes a trend line 
          geom_smooth()+
          geom_point(alpha = 0.1,
           aes(color = species_id))

# Exercise 1 
surveys_complete$plot_id<-as.factor(surveys_complete$plot_id)

ggplot(data = surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length, 
           color = plot_id)) + 
          geom_point(alpha = 0.1)

# Boxplot

ggplot(data = surveys_complete, 
       aes(x = species_id, 
           y = hindfoot_length))+
       
          geom_jitter(color = "tomato", alpha = 0.1)

#exercise 2
ggplot(data = surveys_complete,
       aes(x = species_id,
           y = hindfoot_length))+
          geom_violin()

yearly_counts <- surveys_complete %>%
          group_by(year, species_id) %>%
          tally

ggplot(data = yearly_counts, 
       aes ( x = year, 
             y = n, 
             color = species_id))+  
          geom_line()

yearly_weight <- surveys_complete %>%           		group_by(year, species_id) %>%
          summarize(avg_weight = mean(weight), 
                    sd_weight = sd(weight))
pd <- position_dodge(0.1)
ggplot(data = yearly_weight, 
       aes(x = year, 
           y = avg_weight, 
           color = species_id))+
          geom_line()+
          geom_errorbar(aes(ymin=avg_weight-sd_weight, 
                            ymax=avg_weight+sd_weight), 
                            width=.1) 


#themes

ggplot(data = yearly_counts, 
       aes ( x = year, 
             y = n, 
             color = species_id))+  
          geom_line()+ 
          theme_classic()+ 
          labs(title = "Observed Species in time",
               x = 'Year of observation',
               y = 'Count') + 
          theme(text=element_text(size=16, 
                        family="Arial"))

arial_theme <- theme_classic()+ 
          theme(text=element_text(size=16, 
                                  family="Arial"))
arialtheme<-ggplot(data = yearly_counts, 
       aes ( x = year, 
             y = n, 
             color = species_id))+  
          geom_line()+ 
          arial_theme

notarial<-ggplot(data = yearly_counts, 
                   aes ( x = year, 
                         y = n, 
                         color = species_id))+  
          geom_line()

ggsave(filename = "myplot.png", 
       arialtheme)

       