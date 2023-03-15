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
joined_table <- right_join(curated_table, read_size_meta)

View(joined_table)

#Inner joining was not used because it would remove samples
#that are not in the curated table so the samples
#that are not in the curated table are missing samples#

#Missing samples in curated table
missing_samples <- setdiff(read_size_meta$samples, curated_table$samples)

View(missing_samples)
