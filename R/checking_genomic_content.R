library(tidyverse)
options(scipen = 999)

################################### Read data ##################################

genomic_summary <- read_csv("genomic_content_summaries/genomic_summary.csv")

metadata <- read_csv(
    paste0(
        "reclassification_2022/04_metadata_curated/",
        "biome_classification/merged_metadata_raw.csv"
    )
)

# Merge --------------------------------
merged_table <- genomic_summary %>%
    inner_join(metadata, by = "samples")

###################### 2. Check for problematic samples ########################

problematic_sanger_samples <- merged_table %>%
    filter(seq_method == "sanger") %>%
    pull(samples)

problematic_iontorrent_samples <- merged_table %>%
    filter(seq_method == "ion torrent") %>%
    filter(highest_read_size > 800) %>%
    pull(samples)

problematic_454_samples <- merged_table %>%
    filter(seq_method == "454") %>%
    filter(highest_read_size > 700) %>%
    pull(samples)

problematic_illumina_samples <- merged_table %>%
    filter(seq_method == "illumina") %>%
    filter(highest_read_size > 600) %>%
    pull(samples)

problematic_samples_full <- c(
    problematic_sanger_samples,
    problematic_iontorrent_samples,
    problematic_454_samples,
    problematic_illumina_samples
)

problematic_samples_df <- merged_table %>%
    filter(samples %in% problematic_samples_full)

# impact evaluation --------------------
problematic_samples_df %>%
    group_by(seq_method) %>%
    summarise(count = n())

problematic_samples_df %>%
    group_by(habitat) %>%
    summarise(count = n())

problematic_samples_df %>%
    group_by(ecosystem) %>%
    summarise(count = n())

problematic_samples_df %>%
    group_by(life_style) %>%
    summarise(count = n())

write.csv(
    problematic_samples_df,
    "problematic_samples.csv",
    row.names = FALSE
)

############################ Produce cleaned table #############################

clean_table <- merged_table %>%
    filter(!samples %in% problematic_samples_full)

write.csv(
    clean_table,
    "clean_table.csv",
    row.names = FALSE
)
