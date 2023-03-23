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

#converting fake char columns to numeric columns
for(i in 9:length(data_after)){
    data_after[i] <- as.numeric(data_after[[i]])
    data_after[is.na(data_after)] <- 0
}
str(data_after)

is.na(data_after) %>% sum() # chacking for na values

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
    select(-life_style, -biosphere, -ecosystem, -habitat, -Realm, -Biome, -Functional_group) %>%
    column_to_rownames("samples") %>%
    vegdist(,method = "bray")


#calculating dispersion from data_before
dispersion_before <- betadisper(dist_before, group = data_before$level_2, type = "centroid")

#calculating dispersion from data_after
dispersion_after <- betadisper(dist_after, group = data_after$ecosystem, type = "centroid")

#plotting dispersion
dispersion_plot_before <- boxplot(dispersion_before$distances ~ dispersion_before$group,
                          main = "Dispersion of samples before curatory",
                          xlab = "Ecosystems",
                          ylab = "Dispersion",
                          col = "blue",
                          #horizontal = TRUE,
                          las = 2,
                          cex.lab = 1.5,
                          cex.axis = 1.5,
                          cex.main = 1.5,
                          cex.sub = 1.5,
                          cex = 1.5)

dev.print(dispersion_plot_before, file = "output/01_dispersion/boxplot_before_plot.png")

after_plot <- boxplot(dispersion_after$distances ~ dispersion_after$group,
                          main = "Dispersion of samples before curatory",
                          xlab = "Ecosystems",
                          ylab = "Dispersion",
                          col = "blue",
                          #horizontal = TRUE,
                          las = 2,
                          cex.lab = 1.5,
                          cex.axis = 1.5,
                          cex.main = 1.5,
                          cex.sub = 1.5,
                          cex = 1.5)
