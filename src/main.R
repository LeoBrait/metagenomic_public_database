library("tidyverse")

metadata <- read.csv("raw_data//27022023//mg-rast_metadata.csv", sep = ";")
project_id <- read.csv("raw_data//27022023//metadata_complete.csv")

project_id <- project_id %>%
select(samples, project_id)

#change column name from sample to samples
colnames(metadata)[1] <- "samples"

metadata <- inner_join(metadata, project_id, by = "samples")

write.csv(metadata, "treated_data//27022023//base_table.csv", row.names = FALSE)

metadata$biome <- gsub("/", "_slash_", metadata$biome)
metadata$biome <- as.factor(metadata$biome)

biomes <- levels(metadata$biome)
#replace / character with _


for(x in 1:length(biomes)){
  subset <- subset(metadata, biome == biomes[x])
  write.csv(
    subset, paste0("treated_data//27022023//biome_tables//",
    biomes[x], ".csv"), row.names = FALSE)
}
