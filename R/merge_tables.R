#' @Author: Brait LAS
#' @Date: 2023-27-07
#' @Reviewers: None
#' @Last revision: None
#' @Description: Merge files from biome classification andd add the SRA samples.
#' After this you should run the checking_genomic_content.R

library("tidyverse")
library("data.table")
library("jsonlite")


tables_paths <- list.files(
  path = "reclassification_2022/03_manual_treated/biome_tables_organized",
  pattern = "*.csv", full.names = TRUE, recursive = TRUE
)

merged_table_raw <- do.call(rbind, lapply(tables_paths, fread))

# Extract the sample ID from the "samples" column
sample_id <- merged_table_raw$samples

# Function to read JSON and extract "assembled" value
get_assembled_value <- function(sample_id) {
  json_file <- paste0(sample_id, "_metadata.json")
  json_path <- file.path("metadata/raw", json_file)
  if (file.exists(json_path)) {
    parsed_data <- fromJSON(json_path)
    assembled_value <- parsed_data$pipeline_parameters$assembled
    return(assembled_value)
  } else {
    return(NA)
  }
}

merged_table_raw$assembled <- sapply(
    merged_table_raw$samples,
    get_assembled_value
)
merged_table_raw <- merged_table_raw %>%
   filter(assembled == "no") %>%
   select(-assembled)

## Clean aquifer samples
merged_table_clean <- merged_table_raw %>%
  filter(ecosystem != "groundwater") %>%
  select(
      samples,    life_style,  biosphere,
    ecosystem,       habitat,    country,
     latitude,     longitude
)

aquifer_samples <- read_csv(
  "reclassification_2022/01_original_data/aquifer_samples.csv")

aquifer_samples <- aquifer_samples %>%
 rename(
    "life_style" = "level_1",
    "ecosystem" = "level_2",
    "habitat" = "level_3",
    "country" = "Country",
 )

aquifer_samples <- aquifer_samples %>%
    mutate(habitat =
      case_when(
        habitat == "Porous Contaminated" ~ "porous_contaminated",
        habitat == "Karst-Porous" ~ "karst_porous",
        habitat == "Mine" ~ "mine",
        habitat == "Subsurface saline" ~ "subsurface_saline",
        habitat == "Geyser" ~ "geyser",
        habitat == "Porous" ~ "porous",
        TRUE ~ habitat
      )
    ) %>%
    mutate(biosphere =
      case_when(
        habitat == "subsurface_saline" ~ "marine",
        TRUE ~ "freshwater"
      )
    )



aquifer_samples <- aquifer_samples %>%
   select(
      samples,    life_style,  biosphere,
    ecosystem,       habitat,    country,
     latitude,     longitude
)


final_table <- rbind(merged_table_clean, aquifer_samples)

# typo correcting
final_table <- final_table %>%
 mutate(ecosystem =
  case_when(
    ecosystem == "plant-associated" ~ "plant_associated",
    ecosystem == "plant_hots-associated" ~ "plant_associated",
    ecosystem == "plant_host-associated" ~ "plant_associated",
    TRUE ~ ecosystem
  )
 )

#count the number of samples per habitat
x <- final_table %>%
  group_by(habitat) %>%
  summarise(n = n())


#plot ordered
ggplot(x, aes(x = reorder(habitat, -n), y = n)) +
  geom_bar(stat = "identity", color = "blue") +
  geom_text(aes(label = n), hjust = -1.1) +
  coord_flip() +
  labs(
    x = "Habitat",
    y = "Number of samples",
    title = "Number of samples per habitat"
  ) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))

final_table_before <- final_table
final_table <- final_table_before


# get seq method

seq_method_df <- read_csv(
  "reclassification_2022/01_original_data/metadata_categorized.csv"
) %>%
  select(samples, seq_meth)

final_table <- final_table %>%
  inner_join(seq_method_df, by = "samples")

# remove seq_method == "assembled"
final_table <- final_table %>%
  filter(seq_meth != "assembled") %>%
  rename("seq_method" = "seq_meth")

write.csv(
    final_table,
    file = paste0(
        "reclassification_2022/04_metadata_curated/",
        "biome_classification/merged_metadata_raw.csv"
    ),
    row.names = FALSE
)
