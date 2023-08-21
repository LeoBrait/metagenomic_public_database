#' @Author: Brait LAS
#' @Date: 2023-27-07
#' @Reviewers: Barbosa FAS
#' @LastRevision: None
#' @Description: Check for assembled metagenomes and filter them.

################################ Environment ###################################

source("R/src/install_and_load.R")
install_and_load(
  libs = c(
    "tidyverse" = "any",
    "data.table" = "any",
    "jsonlite" = "any")
)

unzip(
    "annotated_metagenomes/kraken_biomedb_relative.zip",
    exdir = "annotated_metagenomes/")

################################### Read data ##################################

genomic_summary <- read_csv("summaries/genomic_read_summary.csv")

metadata <-
    read_csv(
        "data_processing/03_manual_labeling/merged_and_classified.csv"
    )

phyla <- read_csv("annotated_metagenomes/kraken_biomedb_relative_phyla.csv")


###################### 2. Check for problematic samples ########################

# Merge --------------------------------
merged_table <- genomic_summary %>%
    inner_join(metadata, by = "samples")

badsamples_nondownloaded <- setdiff(
    metadata$samples,
    genomic_summary$samples
)

badsamples_lowreads <- merged_table %>%
    filter(total_number_of_reads < 1000000) %>%
    pull(samples)

badsamples_sanger <- merged_table %>%
    filter(seq_meth == "sanger") %>%
    pull(samples)

badsamples_iontorrent <- merged_table %>%
    filter(seq_meth == "ion torrent") %>%
    filter(highest_read_size > 800) %>%
    pull(samples)

badsamples_454 <- merged_table %>%
    filter(seq_meth == "454") %>%
    filter(highest_read_size > 700) %>%
    pull(samples)

badsamples_illumina <- merged_table %>%
    filter(seq_meth == "illumina") %>%
    filter(highest_read_size > 600) %>%
    pull(samples)

# Get richness
badsamples_lowrichness <- phyla %>%
    gather(taxon,  abundance, -samples) %>%
    filter(abundance != 0) %>%
    group_by(samples) %>%
    summarise(richness = n_distinct(taxon)) %>%
    ungroup() %>%
    filter(richness < 50) %>%
    pull(samples)

# merge all badsamples
badsamples_full <- c(
    badsamples_lowrichness,
    badsamples_lowreads,
    badsamples_nondownloaded,
    badsamples_sanger,
    badsamples_iontorrent,
    badsamples_454,
    badsamples_illumina
)

badsamples_df <- metadata %>%
    filter(samples %in% badsamples_full)

# impact evaluation --------------------
badsamples_df %>%
    group_by(seq_meth) %>%
    summarise(count = n())

write.csv(
    badsamples_df,
    paste0(
        "data_processing/06_assembled_removal/",
        "badsamples.csv"
    ),
    row.names = FALSE
)

# summary of problematic samples per habitat
badsamples_df %>%
    group_by(habitat) %>%
    summarise(count = n()) %>%
    write.csv(
        paste0(
            "data_processing/06_assembled_removal/",
            "summary_problematic_habitat.csv"
        ),
        row.names = FALSE
    )

# summary of problematic samples per ecosystem
badsamples_df %>%
    group_by(ecosystem) %>%
    summarise(count = n()) %>%
    write.csv(
        paste0(
            "data_processing/06_assembled_removal/",
            "summary_problematic_ecosystem.csv"
        ),
        row.names = FALSE
    )

# summary of problematic samples per life_style
badsamples_df %>%
    group_by(life_style) %>%
    summarise(count = n()) %>%
    write.csv(
        paste0(
            "data_processing/06_assembled_removal/",
            "summary_problematic_life_style.csv"
        ),
        row.names = FALSE
    )

############################ Produce cleaned tables ############################

clean_table <- merged_table %>%
    filter(!samples %in% badsamples_full)

write.csv(
    clean_table,
    paste0(
        "data_processing/06_assembled_removal/",
        "genomic_content_clean_table.csv"
    ),
    row.names = FALSE
)

# cleaned metadata ---------------------
clean_metadata <- metadata %>%
    filter(!samples %in% badsamples_full)

write.csv(
    clean_metadata,
    "metadata/biome_classification.csv",
    row.names = FALSE
    )
