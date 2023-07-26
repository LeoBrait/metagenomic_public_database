library(tidyverse)
options(scipen = 999)

df <- read_csv("genomic_content_summaries/genomic_summary.csv")
samples_to_see <- df %>%
    filter(highest_read_size > 600)

metadata <- read_csv("metadata/treated/biome_classification.csv")

df_final <- samples_to_see %>%
    inner_join(metadata, by = "samples")

# filter samples with NA
df_final <- df_final %>%
    filter(!is.na(habitat))

# count samples by life_style
df_final %>%
    group_by(life_style) %>%
    summarise(count = n())

#count by habitat
df_final %>%
    group_by(habitat) %>%
    summarise(count = n())

#count by ecosystem
df_final %>%
    group_by(ecosystem) %>%
    summarise(count = n())




hist(
    df$total_number_of_reads,
    breaks = 100000, col = "blue", xlab = "Total number of reads", main = "Histogram of total number of reads", xlim = c(0, 50000))
