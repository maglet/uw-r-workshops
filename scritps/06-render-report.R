library(rmarkdown)

#Render a markdown document with a specified parameter
render(input = "Markdown_demo.Rmd", 
       output_format = "html_document",
       params = list( file = "data/surveys_complete.csv",
                 sex = "F"))

#Render a markdown document with a UI to select parameters
render(input = "Markdown_demo.Rmd", 
       output_format = "html_document",
       params = "ask")

#Render several markdown documents with different data files as input

#get a list of files
files<-list.files(path = "data", pattern=".csv")

#loop through the files, render a doc for each one.
for (f in files){
   render(input = "Markdown_demo.Rmd", 
          output_format = "html_document",
          output_file = paste(f, ".html", sep = ""))
}
