##Script for measuring dispersion of the data##

#Loading libraries
library(tidyverse)
library(vegan)

#Loading data
data_before <- read.csv(
    "data/06_taxonomic_table/phyla_relative_matrix.csv",
    header = TRUE)
data_after <- read.csv(
    "data/06_taxonomic_table/phyla_relative_matrix_after_curatory_and_IUCN_classification.csv", 
    header = TRUE)

categories_final <- data_after[,2:8] 
categories_before <- data_before[,2:4]
#Viewing total sample numver in tables
tail(data_before)
tail(data_after)

#Removing samples in data_before that is not in data_after
samples_after <- data_after$samples
data_before <- data_before %>% filter(samples %in% samples_after)

tail(data_before)

#calculating distances

dist_before <- data_before %>%
    select(-level_1, -level_2, -level_3) %>%
    column_to_rownames("samples") %>%
    vegdist(,method = "bray")

dist_after <- data_after %>%
    select(-life_style, -biosphere, -ecosystem, -habitat, -Realm., -Biome, -Functional.group) %>%
    column_to_rownames("samples") %>%
    select_if(is.numeric) %>%
    vegdist(,method = "bray")

#calculating nmds
set.seed(1)
nmds_before <- metaMDS(dist_before)



#calculating dispersion from data_before
#getting the group
habitat_before <- data_before$habitat
habitat_before <- as.factor(habitat_before)
dispersion_before <- betadisper(dist_before, group = habitat_before, type = "centroid")

#calculating dispersion from data_after
#getting the group
habitat_after <- data_after$habitat
habitat_after <- as.factor(habitat_after)
dispersion_after <- betadisper(dist_after, group = habitat_after, type = "centroid")
