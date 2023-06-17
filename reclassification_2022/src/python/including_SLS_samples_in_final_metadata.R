library(tidyverse)


df <- read_csv("final_metadata/final_biome_classification.csv")

sls_samples <- grep("mgm", df$samples, value = TRUE, invert = TRUE)
sls_samples

sls_samples_df <- df %>% filter(samples %in% sls_samples)
View(sls_samples_df)
