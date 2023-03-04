##Script for merging the dataframes in biome_tables_organized folder##
##Author: Diogo Burgos

#Libraries#
library(tidyverse)
library(data.table)

#Creating a list with the file names in each folder
#of the "biome_tables_organized" folder.
#for this, the function list.files was used,
#with the argument pattern = "*.csv" to exlude the readme files,
#the argument recursive = TRUE because the datasets are in subfolders,
#and the argument full.names = TRUE to get the full directory.#
files <- list.files(path = "data\\03_manual_treatment\\biome_tables_organized",
         pattern = "*.csv", full.names = TRUE, recursive = TRUE)

View(files) #Viewing the list.

#Taking the the files list and applying the function fread
#in each item with lapply function, and calling rbind to all
#the outputs of the lapply function, i.e. the separate dataframes
#joining all of them into one final dataset.#
df <- do.call(rbind, lapply(files, fread))

#Coercing to a dataframe
df <- as.data.frame(unclass(df))

View(df)

d <- Sys.Date() %>% str_replace_all("-", "_")
write.csv(df, 
    file = paste(
        "data\\04_metadata_after_curatory\\curated_metadata_", d, ".csv"
        ))
