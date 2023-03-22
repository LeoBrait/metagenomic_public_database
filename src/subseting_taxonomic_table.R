#Script for subseting taxonomic table to have the same samples as the metadata table

#Loading libraries
library(tidyverse)

#Loading data
metadata <- read.csv("data/05_IUCN_reclassification/curated_metadata_with_IUCN_classification.csv")
taxonomic_table <- read.csv("data/06_taxonomic_table/phyla_relative_matrix.csv")

#Subseting taxonomic table to have the same samples as the metadata table
samples_in_metadata <- metadata$samples
taxonomic_table_subset <- taxonomic_table %>% filter(samples %in% samples_in_metadata)

#geting classification in metadata table
classification <- metadata %>% select(samples, life_style, biosphere, ecosystem, habitat, Realm., Biome, Functional.group)

#Taking old classification out of the taxonomic table
taxonomic_table_subset <- taxonomic_table_subset %>% select(-level_1, -level_2, -level_3)

#Merging the two tables
taxonomic_table_subset <- taxonomic_table_subset %>% inner_join(classification, by = "samples")

#ordering
taxonomic_table_subset <- taxonomic_table_subset %>% select(samples, life_style, biosphere, ecosystem, habitat, Realm., Biome, Functional.group, everything())

#Saving the table
write.csv(taxonomic_table_subset, "data/06_taxonomic_table/phyla_relative_matrix_after_curatory_and_IUCN_classification.csv")
