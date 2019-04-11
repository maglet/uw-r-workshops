library(rmarkdown)

#Render a markdown document
render(input = "scripts/05-reports-shiny.Rmd")

#Render a markdown document with a specified parameter
render(input = "scripts/05-reports-shiny.Rmd", 
       params = list( file = "../data/complete_surveys.csv",
                      sex = "F", 
                      weight = 40))

#Render a markdown document with a UI to select parameters
render(input = "scripts/05-reports-shiny.Rmd", 
       params = "ask")

#Render several markdown documents with different data files as input

#get a list of files
files<-list.files(path = "data/by_plot", 
                  pattern=".csv")

#loop through the files, render a doc for each one.
for (f in files){
   render(input = "scripts/05-reports-shiny.Rmd",
          output_file = paste("../reports/",f, ".html", sep = ""))
}
