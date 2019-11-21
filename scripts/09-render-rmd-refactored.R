library(rmarkdown)
library(stringr)

parse_arguments <- function(files){
  
  ## Input: a vector with terminal input
  ## output: a vector of files to render

    if(length(files) == 0 ){
      print("Please provide a list of .csv files containing surveys data to be read. To specify all .csv files in the data directory, use -a as input")
    } 
    
    if("-a" %in% files){
      
      folder <- files[2]
      
      files<-Sys.glob(str_c(folder,"/*.csv"))
      if(length(files) <1){
        print("No files found in the specified folder.")
      }
    }  else {
      files<-files
    }
  
  return(files)
}

render_doc <- function(file){
  
  #input: a csv file to run the Rmd on
  #output: an .html file written to the reports folder.
  
  out_name<-str_split_fixed(string=file,
                            pattern="[/|.]",
                            n=3)
  
  out_name<-str_c(out_name[2], '.html')
  
  render(input = "surveys-report.Rmd",     # file to render
         output_file = out_name,
         output_dir = "reports",                #select output directory
         params = list(file=file)   #sets the file name
  )
}

render_docs <- function(files){
  
  #input: a vector of file names
  #output: calls the render_doc function for each file
  
    for(file in files)
    {
      render_doc(file)
    }

}

main<-function(){
  #call functions from above to render the documents
  
  files <- parse_arguments(commandArgs(trailingOnly = TRUE))
  
  render_docs(files)
}

main() # calls the main function
