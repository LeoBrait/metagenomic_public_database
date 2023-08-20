#' @Author: Brait LAS
#' @Date: 2023-27-07
#' @Reviewers: None
#' @Last revision: None
#' @Description: Merge files from biome classification and the aquifer samples.
#' After this you should run the remove_assembled.R

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
tables_paths <-
  list.files(
    path = "data_processing/03_manual_labeling/splited/",
    pattern = "*.csv", full.names = TRUE, recursive = TRUE
  )

aquifer_samples <-
  read_csv(
    "data_processing/01_original_data/aquifer_samples.csv"
  )

merged_table_raw <- do.call(rbind, lapply(tables_paths, fread))

########################### Add Aquifers samples ###############################

merged_table_clean <- merged_table_raw %>%
  filter(ecosystem != "groundwater") %>%
  select(
         samples,    life_style,     biosphere,
       ecosystem,       habitat,       country,
    project_name,      latitude,     longitude,
     PI_lastname,      seq_meth,    project_id
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

#remove duplicated samples
final_table <- final_table %>%
  distinct(samples, .keep_all = TRUE)

############################## Write data ######################################
write.csv(
    final_table,
    file = "data_processing/03_manual_labeling/merged_and_classified.csv",
    row.names = FALSE
)

final_table %>%
    filter(str_detect(samples, "mgm")) %>%
    pull(samples) %>%
    writeLines("data_processing/04_download_sequences/mgrast_list.txt")


final_table %>%
    filter(!str_detect(samples, "mgm")) %>%
    pull(samples) %>%
    writeLines("data_processing/04_download_sequences/sra_list.txt")
