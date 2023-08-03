#' @title Split metadata
#' @description We splited data for collaborative work.
#' @param metadata_raw is a table of metadata obtained by the mg-rast API.
#' @param coarse_classified is a table of these samples after a gross curatory.
#' It also contains some SRA samples.
#' @param preprocessed is the table we finally split for refined curatory.
#' @param raw_biomes vector with biomes names given by mg-rast. It is used to
#' split the tables in the folder "02_dismembered_tables".
#' @Author Brait LAS.
#' @Date 2023-August-02
#' @Reviewers None


################################# Environment ##################################
source("R/src/install_and_load.R")

install_and_load(
  libs = c("tidyverse" = "any")
)
################################### Load data ##################################

# metadata from mg-rast
metadata_raw <- read.csv(
  "data_processing//01_original_data//mgrast_raw.csv", sep = ";")

# metdata from coarse curatory
coarse_classified <- read.csv(
  "data_processing//01_original_data//coarse_classification.csv")

################################# Treat data ###################################
metadata_raw <-
  metadata_raw %>%
  select(
             sample,          biome,              feature,
           material,    env.package,  metagenome_taxonomy,
        sample_name,   project_name,   investigation_type,
      sequence_type,      continent,              country,
           latitude,      longitude
    ) %>%
    mutate(raw_biome = biome) %>%
    select(-biome)

coarse_classified <-
  coarse_classified %>%
    select(
         samples,   project_id,   biome,
      life_style,  environment,  habitat
    ) %>%
    mutate(
      biosphere = biome,
      ecosystem = environment
    ) %>%
    select(-biome, -environment)

#change column name from sample to samples
colnames(metadata_raw)[1] <- "samples"
preprocessed <- left_join(metadata_raw, coarse_classified, by = "samples")

write.csv(
  preprocessed,
  "data_processing//01_original_data//preprocessed_metadata.csv",
  row.names = FALSE
)

################################# Split data ###################################
preprocessed$raw_biome <- gsub("/", "_slash_", preprocessed$raw_biome)
preprocessed$raw_biome <- tolower(preprocessed$raw_biome)
preprocessed$raw_biome <- as.factor(preprocessed$raw_biome)

raw_biomes <- levels(preprocessed$raw_biome)


for (x in 1:length(raw_biomes)) {
  subset <- subset(preprocessed, raw_biome == raw_biomes[x])
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
