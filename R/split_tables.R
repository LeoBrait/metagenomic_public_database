#' @title Split metadata table by biome
#' @description Split metadata table by biome
#' @param metadata_merged metadata table with merged biomes
#' @param raw_biomes vector with biomes names
#' @return csv files with metadata tables for each biome


################################# Environment ##################################
source("R/src/install_and_load.R")

if (!dir.exists("r_libs")) {
  dir.create("r_libs")
}

install_and_load(
  libs = c("tidyverse" = "any"),
  loc = "r_libs"
)

################################### Load data ##################################

metadata_raw <- read.csv(
  "data//01_original_data//mg-rast_metadata.csv", sep = ";")

metadata_issued <- read.csv(
  "data//01_original_data//metadata_categorized.csv")

metadata_raw <- metadata_raw %>%
  select(
    sample,
    biome,
    feature,
    material,
    env.package,
    metagenome_taxonomy,
    sample_name,
    project_name,
    investigation_type,
    sequence_type,
    continent,
    country,
    latitude,
    longitude) %>%
  mutate(raw_biome = biome) %>%
  select(-biome)

metadata_issued <- metadata_issued %>%
  select(
    samples,
    project_id,
    biome,
    life_style,
    environment,
    habitat) %>%
  mutate(
    biosphere = biome,
    ecosystem = environment) %>%
  select(-biome, -environment)

#change column name from sample to samples
colnames(metadata_raw)[1] <- "samples"
metadata_merged <- left_join(metadata_raw, metadata_issued, by = "samples")

write.csv(
  metadata_merged,
  "data//01_original_data//merged_metadata.csv", row.names = FALSE)

metadata_merged$raw_biome <- gsub("/", "_slash_", metadata_merged$raw_biome)
metadata_merged$raw_biome <- as.factor(metadata_merged$raw_biome)

raw_biomes <- levels(metadata_merged$raw_biome)


for(x in 1:length(raw_biomes)){
  subset <- subset(metadata_merged, raw_biome == raw_biomes[x])
  write.csv(
    subset, paste0("data//biome_tables//",
    raw_biomes[x], ".csv"), row.names = FALSE)
}
