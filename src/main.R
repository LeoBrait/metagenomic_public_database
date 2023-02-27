library("tidyverse")

metadata <- read.csv("raw_data//27022023//mg-rast_metadata.csv", sep = ";")
project_id <- read.csv("raw_data//27022023//metadata_complete.csv")

project_id <- project_id %>%
select(samples, project_id)

#change column name from sample to samples
colnames(metadata)[1] <- "samples"

metadata <- inner_join(metadata, project_id, by = "samples")

write.csv(metadata, "treated_data//27022023//base_table.csv", row.names = FALSE)
