#' @title Split metadata
#' @description We splited data for collaborative work.
#' @param metadata_raw is a table of metadata obtained by the mg-rast API.
#' @param coarse_classified is a table of these samples after a gross curatory.
#' It also contains some SRA samples.
#' @param coarse_classified is the table we finally split for refined curatory.
#' @param raw_biomes vector with biomes names given by mg-rast. It is used to
#' split the tables in the folder "02_dismembered_tables".
#' @Author Brait LAS.
#' @Date 2023-August-02
#' @Reviewers None


################################# Environment ##################################
source("R/src/install_and_load.R")

install_and_load(
  libs = c(
    "tidyverse" = "any",
    "data.table" = "any",
    "jsonlite" = "any")
)
################################### Load data ##################################

# metdata from coarse curatory
coarse_classified <- read.csv(
  "data_processing//01_original_data//mgrast_coarse_classification.csv")

################################# Treat data ###################################

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

unzip(
    "data_processing/01_original_data/mgrast_json/mgrast_raw.zip", 
    exdir = "data_processing/01_original_data/mgrast_json")

coarse_classified$assembled <- sapply(
    coarse_classified$samples,
    get_assembled_value
)

coarse_classified <- coarse_classified %>%
   filter(assembled == "no") %>%
   select(-assembled)

coarse_classified <- coarse_classified %>%
  filter(seq_meth != "assembled") %>%
  rename("seq_method" = "seq_meth")


################################# Split data ###################################
coarse_classified$raw_biome <- gsub("/", "_slash_", coarse_classified$raw_biome)
coarse_classified$raw_biome <- tolower(coarse_classified$raw_biome)
coarse_classified$raw_biome[is.na(coarse_classified$raw_biome)] <- "no_biome"
coarse_classified$raw_biome <- as.factor(coarse_classified$raw_biome)

raw_biomes <- levels(coarse_classified$raw_biome)
for (x in 1:length(raw_biomes)) {
  subset <- subset(coarse_classified, raw_biome == raw_biomes[x])
  write.csv(
    subset,
    paste0(
      "data_processing//02_dismembered_tables//",
      raw_biomes[x],
      ".csv"
    ),
    row.names = FALSE
  )
}

############################## Checking protocol ###############################
# Do from back to front.

tables_paths <- list.files(
  path = "data_processing/02_dismembered_tables/",
  pattern = "*.csv", full.names = TRUE, recursive = TRUE
)

recall_table <- do.call(rbind, lapply(tables_paths, fread))

setdiff(coarse_classified$samples, recall_table$samples)
setdiff(recall_table$samples, coarse_classified$samples)
