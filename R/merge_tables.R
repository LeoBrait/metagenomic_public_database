#' @Author: Brait LAS
#' @Date: 2023-27-07
#' @Reviewers: None
#' @Last revision: None
#' @Description: Merge files from biome classification andd add the SRA samples.
#' After this you should run the 03_checking_genomic_content.R

################################ Environment ###################################


source("R/src/install_and_load.R")
install_and_load(
  libs = c(
    "tidyverse" = "any",
    "data.table" = "any",
    "jsonlite" = "any"
  )
)

############################ Load and merge tables #############################
tables_paths <- list.files(
  path = "data_processing/03_manual_labeling/splited/",
  pattern = "*.csv", full.names = TRUE, recursive = TRUE
)

#reapir artifact
recover <- read.csv(
  "data_processing//01_original_data//mgrast_coarse_classification.csv") %>%
  select(
    samples, PI_lastname, seq_meth
  )

for (table_path in tables_paths) {
  table <- read_csv(table_path)
  table <- table %>%
    left_join(
      recover,
      by = "samples"
    )
  write.csv(
    table,
    table_path,
    row.names = FALSE
  )
}




aquifer_samples <- read_csv(
  "data_processing/01_original_data/aquifer_samples.csv")

merged_table_raw <- do.call(rbind, lapply(tables_paths, fread))

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

unzip(
    "data_processing/01_original_data/mgrast_json/mgrast_raw.zip", 
    exdir = "data_processing/01_original_data/mgrast_json")

merged_table_raw$assembled <- sapply(
    merged_table_raw$samples,
    get_assembled_value
)

merged_table_raw <- merged_table_raw %>%
   filter(assembled == "no") %>%
   select(-assembled)

########################### Add SRA to the table ###############################
## Remove aquifer samples to avoid duplicated samples
merged_table_clean <- merged_table_raw %>%
  filter(ecosystem != "groundwater") %>%
  select(
      samples,    life_style,  biosphere,
    ecosystem,       habitat,    country,
    project_name, latitude,     longitude
)

## Get metadata of groundwater database from article published
#by Brait and Barbosa, since their metadata
#is already validated and published
aquifer_samples <- read_csv(
  "data_processing/01_original_data/aquifer_samples.csv")

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
    project_name, latitude,     longitude
)


final_table <- rbind(merged_table_clean, aquifer_samples)

############################### Refined treatment ##############################
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


# get seq method and PI lastname
seq_method_df <- read_csv(
  "data_processing/01_original_data/coarse_classification.csv"
) %>%
  select(samples, PI_lastname, seq_meth)

final_table <- final_table %>%
  inner_join(seq_method_df, by = "samples")


final_table <- final_table %>%
  filter(seq_meth != "assembled") %>%
  rename("seq_method" = "seq_meth")

write.csv(
    final_table,
    file = "data_processing/03_manual_labeling/merged_and_labeled.csv",
    row.names = FALSE
)

mgrast_list <- final_table %>%
    filter(str_detect(samples, "mgm")) %>%
    pull(samples)
writeLines(mgrast_list, "data_processing/04_download_sequences/mgrast_list.txt")


sra_list <- final_table %>%
    filter(!str_detect(samples, "mgm")) %>%
    pull(samples)
writeLines(sra_list, "data_processing/04_download_sequences/sra_list.txt")
