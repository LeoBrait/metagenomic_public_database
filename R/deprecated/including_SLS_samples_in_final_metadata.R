library(tidyverse)


df <- read_csv("final_metadata/final_biome_classification.csv")

sls_samples <- grep("mgm", df$samples, value = TRUE, invert = TRUE)
sls_samples

sls_samples_df <- df %>% filter(samples %in% sls_samples)
View(sls_samples_df)

df <- read_csv("final_metadata/IUCN_classification_without_sls_samples.csv")

df <- df %>%
    subset(select = -c(metagenome_taxonomy, investigation_type))

sls_samples_df <- sls_samples_df %>%
    subset(select = -c(PI_lastname, seq_meth, drop))
str(df)
str(sls_samples_df)

sls_samples_df[c("Realm", "Biome", "Functional_group")] <- NA
str(sls_samples_df)

sub_fresh <- df %>% 
    filter(grepl("Subterranean", Realm))

sls_samples_df[c("Realm")] <- "Subterranean-Freshwater"
sls_samples_df[c("Biome")] <- "Subterranean_freshwaters"
str(sls_samples_df)

final_df <- rbind(df, sls_samples_df)

final_df <- final_df %>%
    subset(select = c(samples, Realm, Biome, Functional_group))

View(final_df)

write_csv(final_df, "final_metadata/final_IUCN_classification.csv")
