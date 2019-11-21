library(rmarkdown)
library(stringr)

files <- commandArgs(trailingOnly = TRUE)

#same as hitting knit, uses the default parameters
#render("code/surveys-report.Rmd")
 
if(length(files)==0){
  print("Please provide a list of .csv files containing surveys data to be read. To specify all .csv files in the data directory, use -a as input")
} else{
  files<-files
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



for(file in files)
{
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
