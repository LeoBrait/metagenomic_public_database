library("tidyverse")

metadata_raw <- read.csv("raw_data//27022023//mg-rast_metadata.csv", sep = ";")
metadata_issued <- read.csv("raw_data//27022023//metadata_complete.csv")

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
  "treated_data//27022023//base_table.csv", row.names = FALSE)

metadata_merged$raw_biome <- gsub("/", "_slash_", metadata_merged$raw_biome)
metadata_merged$raw_biome <- as.factor(metadata_merged$raw_biome)

raw_biomes <- levels(metadata_merged$raw_biome)


for(x in 1:length(raw_biomes)){
  subset <- subset(metadata_merged, raw_biome == raw_biomes[x])
  write.csv(
    subset, paste0("treated_data//27022023//biome_tables//",
    raw_biomes[x], ".csv"), row.names = FALSE)
}
