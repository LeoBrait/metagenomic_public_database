##Script for measuring dispersion of the data##

#Loading libraries
library(tidyverse)
library(vegan)
library(cowplot)

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
#samples_after <- data_after$samples
#data_before <- data_before %>% filter(samples %in% samples_after)

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
names(dispersion_before)
dispersion_before_df <- data.frame(dispersion_before$distances)
dispersion_before_df$group <- dispersion_before$group
#calculating dispersion from data_after
dispersion_after <- betadisper(dist_after, group = data_after$ecosystem, type = "centroid")
names(dispersion_after)
dispersion_after_df <- data.frame(dispersion_after$distances)
dispersion_after_df$group <- dispersion_after$group
 
#Plotting dispersion with ggplot
dispersion_before_plot <- dispersion_before_df %>%
    ggplot(aes(x = group, y = dispersion_before.distances)) +
    geom_boxplot() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    labs(x = "Ecosystems", y = "Dispersion", title = "Dispersion of samples before curatory")
dispersion_before_plot

ggsave(plot = dispersion_before_plot, filename = paste("outputs/01_dispersion_plots/dispersion_before_curatory.png", sep = ""))
ggsave(plot = dispersion_before_plot, filename = paste("outputs/01_dispersion_plots/dispersion_before_curatory.pdf", sep = ""))

dispersion_after_plot <- dispersion_after_df %>%
    ggplot(aes(x = group, y = dispersion_after.distances)) +
    geom_boxplot() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    labs(x = "Ecosystems", y = "Dispersion", title = "Dispersion of samples after curatory")
dispersion_after_plot

ggsave(plot = dispersion_after_plot, filename = paste("outputs/01_dispersion_plots/dispersion_after_curatory.png", sep = ""))
ggsave(plot = dispersion_after_plot, filename = paste("outputs/01_dispersion_plots/dispersion_after_curatory.pdf", sep = ""))


#dispersion after grouped by IUCN Biome category
dispersion_IUCN_biome <- betadisper(dist_after, group = data_after$Biome, type = "centroid")
names(dispersion_IUCN_biome)
dispersion_IUCN_biome_df <- data.frame(dispersion_IUCN_biome$distances)
dispersion_IUCN_biome_df$group <- dispersion_IUCN_biome$group

#Plotting dispersion with ggplotcen
dispersion_IUCN_biome_plot <- dispersion_IUCN_biome_df %>%
    ggplot(aes(x = group, y = dispersion_IUCN_biome.distances)) +
    geom_boxplot() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    labs(x = "IUCN Biome", y = "Dispersion", title = "Dispersion of samples in IUCN Biome class")

dispersion_IUCN_biome_plot

ggsave(plot = dispersion_IUCN_biome_plot, filename = paste("outputs/01_dispersion_plots/dispersion_IUCN_biome_curatory.png", sep = ""))
ggsave(plot = dispersion_IUCN_biome_plot, filename = paste("outputs/01_dispersion_plots/dispersion_IUCN_biome_curatory.pdf", sep = ""))

#dispersion after grouped by IUCN Realm category
dispersion_IUCN_realm <- betadisper(dist_after, group = data_after$Realm, type = "centroid")
names(dispersion_IUCN_realm)
dispersion_IUCN_realm_df <- data.frame(dispersion_IUCN_realm$distances)
dispersion_IUCN_realm_df$group <- dispersion_IUCN_realm$group

#Plotting dispersion with ggplot
dispersion_IUCN_realm_plot <- dispersion_IUCN_realm_df %>%
    ggplot(aes(x = group, y = dispersion_IUCN_realm.distances)) +
    geom_boxplot() +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
    labs(x = "IUCN Realm", y = "Dispersion", title = "Dispersion of samples in IUCN Realm class")

dispersion_IUCN_realm_plot

ggsave(plot = dispersion_IUCN_realm_plot, filename = paste("outputs/01_dispersion_plots/dispersion_IUCN_realm_curatory.png", sep = ""))
ggsave(plot = dispersion_IUCN_realm_plot, filename = paste("outputs/01_dispersion_plots/dispersion_IUCN_realm_curatory.pdf", sep = ""))

plot_before_after <- plot_grid(dispersion_before_plot, dispersion_after_plot, ncol = 2, nrow = 1)
plot_before_after
ggsave(plot = plot_before_after, filename = paste("outputs/01_dispersion_plots/dispersion_before_and_after_curatory.png", sep = ""))
ggsave(plot = plot_before_after, filename = paste("outputs/01_dispersion_plots/dispersion_before_and_after_curatory.pdf", sep = ""))

plot_old_and_new_biome <- plot_grid(dispersion_after_plot, dispersion_IUCN_biome_plot, ncol = 2, nrow = 1)
plot_old_and_new_biome
ggsave(plot = plot_old_and_new_biome, filename = paste("outputs/01_dispersion_plots/dispersion_after_and_IUCN_biome.png", sep = ""))
ggsave(plot = plot_old_and_new_biome, filename = paste("outputs/01_dispersion_plots/dispersion_after_and_IUCN_biome.pdf", sep = ""))

#Ploting NMDS before curatory
NMDS_before_curatory <- metaMDS(dist_before)

NMDS_before_and_classification <- inner_join(categories_before, NMDS_before_curatory)

centroid_before <- NMDS_before_and_classification %>%
    group_by(ecosystem) %>% 
    summarize(NMDS1 = mean(NMDS1), NMDS2 = mean(NMDS2))

NMDS_before_class_plot <- NMDS_before_and_classification %>%
    ggplot(aes(x = NMDS1, y = NMDS2, color = ecosystem)) +
    geom_point() +
    stat_ellipse(show.legend = FALSE) +
    geom_point(data = centroid_before, size = 5, shape = 21, color = "black",
    aes(fill = ecosystem), show.legend = FALSE)
NMDS_before_class_plot

ggsave(plot = NMDS_before_class_plot, filename = paste())
ggsave(plot = NMDS_before_class_plot, filename = paste())
    

#Ploting NMDS after curatory
NMDS_after_curatory <- metaMDS(dist_after)

NMDS_before_and_classification <- inner_join(categories_before, NMDS_before_curatory)

centroid_before <- NMDS_before_and_classification %>%
    group_by(ecosystem) %>% 
    summarize(NMDS1 = mean(NMDS1), NMDS2 = mean(NMDS2))

NMDS_before_class_plot <- NMDS_before_and_classification %>%
    ggplot(aes(x = NMDS1, y = NMDS2, color = ecosystem)) +
    geom_point() +
    stat_ellipse(show.legend = FALSE) +
    geom_point(data = centroid_before, size = 5, shape = 21, color = "black",
    aes(fill = ecosystem), show.legend = FALSE)
NMDS_before_class_plot

ggsave(plot = NMDS_before_class_plot, filename = paste())
ggsave(plot = NMDS_before_class_plot, filename = paste())
    