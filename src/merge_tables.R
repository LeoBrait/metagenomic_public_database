##Script for merging the dataframes in biome_tables_organized folder##
##Author: Diogo Burgos

#Libraries#
library(tidyverse)

#Creating a list with the file names in each folder of the "biome_tables_organized" folder.#
#for this, the function list.files was used, with the argument pattern = ".csv" to exlude the readme files.#
dflist <- list.files(path = "data/03_manual_treatment/biome_tables_organized", pattern = ".csv",
                     full.names = FALSE, recursive = TRUE, include.dirs = FALSE)

View(dflist) #Viewing the list.

#Now, geting the number of dataframes in the list with the function length.#
n_of_datasets <- length(dflist)

print(n_of_datasets) #Printing the number.

#Now lets use a for loop to load every dataframe in those folders.#