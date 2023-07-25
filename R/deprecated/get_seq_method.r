library("tidyverse")

genomic <- read_csv2(
    "D:/documentos/leonardo/01_universidade/01_biome_lab/1_paper_production/metagenomic_public_database/genomic_content_summaries/merged_metadata.csv" 

)

metadata_complete <- read_csv(
    "D:/documentos/leonardo/01_universidade/01_biome_lab/1_paper_production/metagenomic_public_database/genomic_content_summaries/metadata_complete.csv"
)

metadata_complete <- metadata_complete %>%
 select(samples, seq_meth )

merged_table <- genomic %>%
  inner_join(metadata_complete, by = "samples")
unique(merged_table$seq_meth)

write.csv(
    merged_table,
    file = paste0(
        "D:/documentos/leonardo/01_universidade/01_biome_lab/",
        "1_paper_production/metagenomic_public_database/",
        "genomic_content_summaries/genomic_content.csv"
    ),
    row.names = FALSE
)
