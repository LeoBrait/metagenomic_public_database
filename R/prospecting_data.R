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
aquifer_metadata <- read_csv(
  "data_processing/01_original_data/aquifer_samples.csv"
)

phyla <- read_csv(
  "annotated_metagenomes/kraken_biomedb_relative_phyla.csv"
)

radiation <- read_csv("summaries/radiation_phyla.csv")

bad_samples_vector <- c(
  "SRR4343427", "SRR4343429", "SRR4343430", "SRR4343434",
  "SRR4343431", "SRR4343440", "SRR3989308", "SRR3989310",
  "SRR3989311", "SRR3989312", "SRR3989313", "SRR3989315",
  "DRR125227",  "SRR1658343", "SRR1658462", "SRR1658465",
  "SRR1658469", "SRR1658472", "SRR2177362", "SRR2177950",
  "SRR2177952", "SRR2177968", "SRR2177986", "SRR3308675",
  "SRR3309137", "SRR3309326", "SRR3309327"
)

aquifer_metadata <- aquifer_metadata %>%
  filter(!samples %in% bad_samples_vector)

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
  metadata_df = aquifer_metadata,
  metadata_variables = c("habitat", "project_id", "seq_meth", "PI_lastname")
)

merged_df_long <- gather(
  merged_df,
  key = "taxon",
  value = "relative_abundance",
  -c("samples", "habitat", "project_id", "seq_meth", "PI_lastname")
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

good_long <- merged_df_long %>%
  filter(!samples %in% bad_samples_vector)

bad_long <- merged_df_long %>%
  filter(samples %in% bad_samples_vector)


##################################### Plot #####################################

good_plot <-
  ggplot(
    data = good_long,
    aes(x = samples, y = relative_abundance, fill = taxon)
  ) +
  geom_bar(stat = "identity") +
  facet_grid(cols = vars(habitat), space = "free", scales = "free") +

  theme_pubr() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    legend.position = "none"
  )

bad_plot <-
  ggplot(
    data = bad_long,
    aes(x = samples, y = relative_abundance, fill = taxon)
  ) +
  geom_bar(stat = "identity") +
  facet_grid(cols = vars(habitat), space = "free", scales = "free") +
  theme_pubr() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    legend.position = "none"
  )

taxa_plot <- ggarrange(bad_plot, good_plot, widths = c(0.4, 1))

good_plot <-
  ggplot(
    data = good_long,
    aes(x = samples, y = relative_abundance, fill = radiation)
  ) +
  geom_bar(stat = "identity") +
  facet_grid(cols = vars(habitat), space = "free", scales = "free") +

  theme_pubr() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    legend.position = "none"
  )

bad_plot <-
  ggplot(
    data = bad_long,
    aes(x = samples, y = relative_abundance, fill = radiation)
  ) +
  geom_bar(stat = "identity") +
  facet_grid(cols = vars(habitat), space = "free", scales = "free") +
  theme_pubr() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    legend.position = "none"
  )

radiation_plot <- ggarrange(bad_plot, good_plot, widths = c(0.4, 1))

final <- ggarrange(
  taxa_plot,
  radiation_plot,
  nrow = 2
)


ggsave(
  final,
  filename = "figures/stacked_radiation.png",
  width = 20,
  height = 10
)


