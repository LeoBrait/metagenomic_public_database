#' @Author: Brait LAS
#' @Date: 2023-27-07
#' @Reviewers: None
#' @LastRevision: None
#' @Description: Check for assembled metagenomes and filter them.

################################ Environment ###################################
if (!file.exists("r_libs")) {
  dir.create("r_libs")
}

source("R/src/install_and_load.R")
install_and_load(
  libs = c(
    "tidyverse" = "any",
    "data.table" = "any",
    "jsonlite" = "any"),
  loc = "r_libs"
)

################################### Read data ##################################

genomic_summary <- read_csv("summaries/genomic_read_summary.csv")

metadata <-
    read_csv(
        "data_processing/03_manual_labeling/merged_and_labeled.csv"
    )

######################### Extracts assembled from Json Data ####################


# Function to read JSON and extract "assembled" value
get_assembled_value <- function(sample_id) {
  json_file <- paste0(sample_id, "_metadata.json")
  json_path <-
    file.path(
      "data_processing/01_original_data/mgrast_json",
      json_file
    )
  if (file.exists(json_path)) {
    parsed_data <- fromJSON(json_path)
    assembled_value <- parsed_data$pipeline_parameters$assembled
    return(assembled_value)
  } else {
    return("no")
  }
}

metadata$assembled <- sapply(
    metadata$samples,
    get_assembled_value
)

metadata <- metadata %>%
   filter(assembled == "no") %>%
   select(-assembled)

###################### 2. Check for problematic samples ########################
# Merge --------------------------------
merged_table <- genomic_summary %>%
    inner_join(metadata, by = "samples")

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
        "data_processing/04_assembled_removal/",
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
            "data_processing/04_assembled_removal/",
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
            "data_processing/04_assembled_removal/",
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
            "data_processing/04_assembled_removal/",
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
        "data_processing/04_assembled_removal/",
        "genomic_content_clean_table.csv"
    ),
    row.names = FALSE
)

# cleaned metadata ---------------------
clean_metadata <- metadata %>%
    filter(!samples %in% problematicsamples_full) %>%
    write.csv(
        "metadata/biome_classification.csv",
        row.names = FALSE
    )
