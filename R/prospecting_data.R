#' @author Leonardo Brait
#' @created 29 aug 2023


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
metadata <- read_csv(
  "metadata/biome_classification.csv"
)

phyla_relative <- read_csv(
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
  annotation_df = phyla_relative,
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
)


##################################### Plot #####################################
plot_dir <- "figures/phyla_composition/"
if (!file.exists(plot_dir)) {
  dir.create(plot_dir)
}

ecosystems <- unique(merged_df$ecosystem)
source("R/src/draw_stacked.R")


for (i in ecosystems) {


  # Vectors of taxa
  high_abundant <- merged_df_long %>%
    filter(ecosystem == i) %>%
    group_by(samples) %>%
    filter(relative_abundance >= 0.01) %>%
    pull(taxon)

  low_abundant <- merged_df_long %>%
    filter(ecosystem == i) %>%
    group_by(samples) %>%
    filter(
      relative_abundance < 0.01
      & relative_abundance >= 0.005
      & !taxon %in% high_abundant
    ) %>%
    pull(taxon)

  super_low_abundant <- merged_df_long %>%
    filter(ecosystem == i) %>%
    group_by(samples) %>%
    filter(
      relative_abundance < 0.005
      & relative_abundance >= 0.001
      & !taxon %in% high_abundant
      & !taxon %in% low_abundant
    ) %>%
    pull(taxon)

  hiper_low_abundant <- merged_df_long %>%
    filter(ecosystem == i) %>%
    group_by(samples) %>%
    filter(
      relative_abundance < 0.001
      & relative_abundance >= 0.0005
      & !taxon %in% high_abundant
      & !taxon %in% low_abundant
      & !taxon %in% super_low_abundant
    ) %>%
    pull(taxon)

  mega_low_abundant <- merged_df_long %>%
    filter(ecosystem == i) %>%
    group_by(samples) %>%
    filter(
      relative_abundance < 0.0005
      & relative_abundance >= 0.0001
      & !taxon %in% high_abundant
      & !taxon %in% low_abundant
      & !taxon %in% super_low_abundant
      & !taxon %in% hiper_low_abundant
    ) %>%
    pull(taxon)

  # Dataframes
  high_abundant_df <- merged_df_long %>%
    filter(ecosystem == i & taxon %in% high_abundant)

  low_abundant_df <- merged_df_long %>%
    filter(ecosystem == i & taxon %in% low_abundant)

  super_low_abundant_df <- merged_df_long %>%
    filter(ecosystem == i & taxon %in% super_low_abundant)

  hiper_low_abundant_df <- merged_df_long %>%
    filter(ecosystem == i & taxon %in% hiper_low_abundant)

  mega_low_abundant_df <- merged_df_long %>%
    filter(ecosystem == i & taxon %in% mega_low_abundant)

  # Plotting
  ## High -------------------------------
  plot <- draw_stacked(
    data = subset(high_abundant_df, ecosystem == i),
    fill_var = "taxon",
    facet = "habitat",
    title = paste0("taxa of ", i, sep = "")
  )
  ggsave(
    filename = paste0(plot_dir, i, "_high.png", sep = ""),
    plot = plot,
    width = unit(12, "cm"),
    height = unit(9, "cm")
  )

  ## Low --------------------------------
  plot <- draw_stacked(
    data = subset(low_abundant_df, ecosystem == i),
    fill_var = "taxon",
    facet = "habitat",
    title = paste0("taxa of ", i, sep = "")
  )
  ggsave(
    filename = paste0(plot_dir, i, "_low.png", sep = ""),
    plot = plot,
    width = unit(12, "cm"),
    height = unit(9, "cm")
  )

  ## Super low --------------------------
  plot <- draw_stacked(
    data = subset(super_low_abundant_df, ecosystem == i),
    fill_var = "taxon",
    facet = "habitat",
    title = paste0("taxa of ", i, sep = "")
  )
  ggsave(
    filename = paste0(plot_dir, i, "_super_low.png", sep = ""),
    plot = plot,
    width = unit(12, "cm"),
    height = unit(9, "cm")
  )

  ## hiper low --------------------------
  plot <- draw_stacked(
    data = subset(hiper_low_abundant_df, ecosystem == i),
    fill_var = "taxon",
    facet = "habitat",
    title = paste0("taxa of ", i, sep = "")
  )
  ggsave(
    filename = paste0(plot_dir, i, "_hiper_low.png", sep = ""),
    plot = plot,
    width = unit(12, "cm"),
    height = unit(9, "cm")
  )

  ## mega low --------------------------
  plot <- draw_stacked(
    data = subset(mega_low_abundant_df, ecosystem == i),
    fill_var = "taxon",
    facet = "habitat",
    title = paste0("taxa of ", i, sep = "")
  )
  ggsave(
    filename = paste0(plot_dir, i, "_mega_low.png", sep = ""),
    plot = plot,
    width = unit(12, "cm"),
    height = unit(9, "cm")
  )
}
