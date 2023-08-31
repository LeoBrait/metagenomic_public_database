#' @author Leonardo Brait
#' @created 29 aug 2023


source("R/src/install_and_load.R")

install_and_load(
  libs = c(
    "tidyverse" = "any",
    "ggplot2" = "any",
    "ggpubr" = "any"
  )
)

unzip(
  "annotated_metagenomes/kraken_biomedb_relative.zip",
  exdir = "annotated_metagenomes/"
)

################################### Load data ##################################
metadata <- read_csv(
  "metadata/biome_classification.csv"
)

phyla <- read_csv(
  "annotated_metagenomes/kraken_biomedb_relative_phyla.csv"
)

radiation <- read_csv("summaries/radiation_phyla.csv")

################################# Data processing ##############################
dpann_radiation <- radiation %>%
  filter(microgroup == "DPANN") %>%
  pull(taxon)

cpr_radiation <- radiation %>%
  filter(microgroup == "CPR") %>%
  pull(taxon)


source("R/src/merge_sampleinfo.R")
merged_df <- merge_sampleinfo(
  annotation_df = phyla,
  metadata_df = metadata,
  metadata_variables = c(
    "habitat", "project_id", "seq_meth", "PI_lastname", "ecosystem"
  )
)

merged_df_long <- gather(
  merged_df,
  key = "taxon",
  value = "relative_abundance",
  -c("samples", "habitat", "project_id", "seq_meth", "PI_lastname", "ecosystem")
) %>%
  mutate(
    radiation = factor(
      case_when(
        taxon %in% dpann_radiation ~ "DPANN",
        taxon %in% cpr_radiation ~ "CPR",
        TRUE ~ "Bonafide"
      )
    )
  )

##################################### Plot #####################################
plot_dir <- "figures/phyla_composition/"
if (!file.exists(plot_dir)) {
  dir.create(plot_dir)
}

ecosystems <- unique(merged_df$ecosystem)
source("R/src/draw_stacked.R")

# taxa composition
plot_list <- list()
for (i in ecosystems) {

  plot_list[[i]] <- ggplot(
    data = subset(merged_df_long, ecosystem == i),
    aes(x = samples, y = relative_abundance, fill = taxon)
  ) +
    geom_bar(stat = "identity") +
    facet_grid(cols = vars(habitat), space = "free", scales = "free") +

    theme_pubr() +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, size = unit(9, "cm")),
      legend.position = "none"
    ) +
    ggtitle(paste0("TAXA OF ", i, sep = ""))
  ggsave(
    filename = paste0(plot_dir, i, "_taxon.png", sep = ""),
    plot = plot_list[[i]],
    width = unit(12, "cm"),
    height = unit(9, "cm")

  )
}

#radiation composition
plot_list <- list()
for (i in ecosystems) {

  plot_list[[i]] <- ggplot(
    data = subset(merged_df_long, ecosystem == i),
    aes(x = samples, y = relative_abundance, fill = radiation)
  ) +
    geom_bar(stat = "identity") +
    facet_grid(cols = vars(habitat), space = "free", scales = "free") +

    theme_pubr() +
    theme(
      axis.text.x = element_text(angle = 90, hjust = 1, size = unit(9, "cm")),
      legend.position = "none"
    ) +
    ggtitle(paste0("RADIATIONS OF ", i, sep = ""))
  ggsave(
    filename = paste0(plot_dir, i, "_radiation.png", sep = ""),
    plot = plot_list[[i]],
    width = unit(12, "cm"),
    height = unit(9, "cm")
  )
}


