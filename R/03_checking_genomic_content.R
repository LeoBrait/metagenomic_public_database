#' @Author: Brait LAS
#' @Date: 2023-27-07
#' @Reviewers: None
#' @LastRevision: None
#' @Description: Check for assembled metagenomes and filter them.

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

problematicsamples_nondownloaded <- setdiff(
    metadata$samples,
    genomic_summary$samples
)

problematicsamples_sanger <- merged_table %>%
    filter(seq_method == "sanger") %>%
    pull(samples)

problematicsamples_iontorrent <- merged_table %>%
    filter(seq_method == "ion torrent") %>%
    filter(highest_read_size > 800) %>%
    pull(samples)

problematicsamples_454 <- merged_table %>%
    filter(seq_method == "454") %>%
    filter(highest_read_size > 700) %>%
    pull(samples)

problematicsamples_illumina <- merged_table %>%
    filter(seq_method == "illumina") %>%
    filter(highest_read_size > 600) %>%
    pull(samples)

problematicsamples_full <- c(
    problematicsamples_nondownloaded,
    problematicsamples_sanger,
    problematicsamples_iontorrent,
    problematicsamples_454,
    problematicsamples_illumina
)

problematic_samples_df <- metadata %>%
    filter(samples %in% problematicsamples_full)

# impact evaluation --------------------
problematic_samples_df %>%
    group_by(seq_method) %>%
    summarise(count = n())

write.csv(
    problematic_samples_df,
    paste0(
        "reclassification_2022/05_genomic_content_filter/",
        "problematic_samples.csv"
    ),
    row.names = FALSE
)

# summary of problematic samples per habitat
problematic_samples_df %>%
    group_by(habitat) %>%
    summarise(count = n()) %>%
    write.csv(
        paste0(
            "reclassification_2022/05_genomic_content_filter/",
            "summary_problematic_habitat.csv"
        ),
        row.names = FALSE
    )

# summary of problematic samples per ecosystem
problematic_samples_df %>%
    group_by(ecosystem) %>%
    summarise(count = n()) %>%
    write.csv(
        paste0(
            "reclassification_2022/05_genomic_content_filter/",
            "summary_problematic_ecosystem.csv"
        ),
        row.names = FALSE
    )

# summary of problematic samples per life_style
problematic_samples_df %>%
    group_by(life_style) %>%
    summarise(count = n()) %>%
    write.csv(
        paste0(
            "reclassification_2022/05_genomic_content_filter/",
            "summary_problematic_life_style.csv"
        ),
        row.names = FALSE
    )

############################ Produce cleaned tables ############################

clean_table <- merged_table %>%
    filter(!samples %in% problematicsamples_full)

write.csv(
    clean_table,
    paste0(
        "reclassification_2022/05_genomic_content_filter/",
        "genomic_content_clean_table.csv"
    ),
    row.names = FALSE
)

# cleaned metadata ---------------------
clean_metadata <- metadata %>%
    filter(!samples %in% problematicsamples_full) %>%
    write.csv(
        "metadata/treated/biome_classification.csv",
        row.names = FALSE
    )
