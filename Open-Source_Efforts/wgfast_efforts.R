# convert WGFAST json open-source file to an HTML table
# code from Colin Millar and Hjalte Parner from ICES IT
#
# to run this from the command line:
# set the working directory to the directory of the program 
# e.g., > setwd("NOAA_Gdrive/sonarpros/R_programs/WGFAST")
# source("wgfast_efforts.R")


# read in table info:
wgfast_efforts <- jsonlite::read_json("Open-Source_Efforts/WGFAST_open-source_efforts.json")

# create the rows of the table to create
# note: column names provide the table headers
table_df <-
  do.call(
    rbind,
    lapply(wgfast_efforts$efforts, function(effort) {
      data.frame(
        Title = effort$title,
        url = effort$url,
        Language = effort$programming_language,
        Description = effort$description,
        `Contact name` = effort$contact$name,
        `Contact email` = effort$contact$`e-mail`,
        check.names = FALSE
      )
    })
  )

# render the document
rmarkdown::render(
  "Open-Source_Efforts/wgfast_efforts.Rmd",
  params = list(
    title = wgfast_efforts$title,
    description = wgfast_efforts$description,
    table_df = table_df
  )
)
