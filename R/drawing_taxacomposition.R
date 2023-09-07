#' @title drawing_taxacomposition
#' @description Draw the taxacomposition for each ecosystem
#' @author Leonardo Brait
#' @created 09 sept 2023

source("R/src/install_and_load.R")
install_and_load(
  libs = c(
    "tidyverse" = "any",
    "ggplot2" = "any",
    "ggpubr" = "any",
    "viridis" = "any"
  )
)

unzip(
  "annotated_metagenomes/kraken_biomedb_relative.zip",
  exdir = "annotated_metagenomes/"
)

################################### Load data ##################################
metadata <- read_csv("metadata/biome_classification.csv") %>%
  select(samples, habitat, ecosystem)

phyla_relative <- read_csv(
  "annotated_metagenomes/kraken_biomedb_relative_phyla.csv"
)

################################ Data processing ###############################
data <- phyla_relative %>% inner_join(metadata, by = "samples")

data_long <- gather(
  data,
  key = "taxon",
  value = "relative_abundance",
  -c("samples", "habitat", "ecosystem")
) %>%
  group_by(habitat, ecosystem, taxon) %>%
  summarise(relative_abundance = mean(relative_abundance))

taxa_list <- data_long %>%
  pull(taxon) %>%
  unique() %>%
  sort()

taxa_colors <- viridis_pal()(length(taxa_list))
names(taxa_colors) <- taxa_list

##################################### Plot #####################################
plot_dir <- "figures/phyla_composition/"
if (!dir.exists(plot_dir)) {
  dir.create(plot_dir)
}

for (i in unique(data_long$ecosystem)) {
  print(paste0("Plotting ", ecosystem, "..."))

  ecosystem_data <- data_long %>%
    filter(ecosystem == i)


  plot_list <- list()
  print(unique(ecosystem_data$habitat))
  for (j in unique(ecosystem_data$habitat)) {

    habitat_data <- ecosystem_data %>%
      filter(habitat == j)

    plot_list[[j]] <-
      ggplot(
        habitat_data,
        aes(x = taxon, y = relative_abundance)
      ) +
      geom_bar(stat = "identity", aes(fill = taxon)) +
      scale_fill_manual(values = taxa_colors) +
      theme_pubr() +
      theme(
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position = "none"
      ) +
      labs(
        x = "Samples",
        y = "Relative abundance",
        title = paste0(j)
      )

  }
  panel <- ggarrange(plotlist = plot_list) +
    labs(title = i)
  ggsave(
    paste0(plot_dir, i, ".png"),
    plot = panel,
    width = 20,
    height = 10,
    units = "cm"
  )
  print(paste0(i, " Done!"))
}
