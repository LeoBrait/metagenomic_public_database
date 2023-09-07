#' @title Draw rarefaction curves

options(scipen = 999)
set.seed(500)

source("R/src/install_and_load.R")
install_and_load(
  libs = c(
    "logging" = "0.10.108",
    "tidyverse" = "1.3.0",
    "vegan" = "2.6.4",
    "parallel" = "3.6.2"
  )
)

################################## Load Data ###################################

unzip(
  "annotated_metagenomes/kraken_biomedb_absolute.zip",
  exdir = "annotated_metagenomes/"
)

phyla_abundances_absolute <- read_csv(
  "annotated_metagenomes/kraken_biomedb_absolute_phyla.csv"
)

metadata <- read.csv("metadata/biome_classification.csv") %>%
  select(samples, ecosystem, habitat)

################################# Data processing ##############################

data <- merge(metadata, phyla_abundances_absolute, by = "samples")

data <- data %>%
  group_by(ecosystem, habitat) %>%
  mutate(n_samples = n()) %>%
  filter(n_samples >= 5) %>%
  ungroup() %>%
  select(-n_samples)

category_types <- unique(data[["ecosystem"]])

################################################################################

svg(filename  = "figures/rarefaction_biomedb.svg")
par(mfrow = c(3, 3))

count <- 1
source("R/src/draw_rarefaction.R")
for (category_name in category_types){

  # Print progress
  progress <- paste0("(", count, " / ", length(category_types), ")", sep = "")
  print(paste("Computing rarefaction for:", category_name, progress, sep = " "))

  # Preprocess data --------------------
  preprocessed <- data %>%
    filter(ecosystem == category_name) %>%
    select(-samples, -habitat, -ecosystem) %>%
    .[rowSums(.) != 0, ]

  row.names(preprocessed) <- data %>%
    filter(ecosystem == category_name) %>%
    pull(samples)

  # Apply rarefaction ------------------
  result <- rarec(
    data = preprocessed,
    pace = 20,
    title_plot = "watever",
    cols = c("darkgray")
  )

  print(paste("Rarefaction for:", category_name, "DONE!", sep = " "))
  count <- count + 1
}

dev.off()
View(data)
