##Script for joining the read size metadata with the curated table##
#load libraries 
library(tidyverse)

#load curated table
curated_table <- read.csv("data/05_IUCN_reclassification/curated_metadata_with_IUCN_classification.csv", 
    header = TRUE, sep = ",")

#load read size metadata
read_size_meta <- read.csv("data/06_collected_metadata_read_sizes/datacollected_metadata_output-filtered.csv", 
    header = TRUE, sep = ",")

#rename sample columns
colnames(read_size_meta)[1] <- "samples"

#Viewing the data
View(curated_table)
View(read_size_meta)

#join tables
joined_table <- inner_join(curated_table, read_size_meta)

joined_table <- joined_table[-1] #remove former rownumbers

View(joined_table)



#save table
write.csv(joined_table, file = "data/07_final_metadata/final_metadata.csv",
    row.names = FALSE)
