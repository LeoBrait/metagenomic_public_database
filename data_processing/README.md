# Data processing
Description of the folder contents and resumed information about the data processing.

## [01_original_data](01_original_data/)
- [mgrast_raw.csv](01_original_data/mgrast_raw.csv) contains only information obtained by the mg-rast API.
All samples (n = 7044) are the result of a manual filtering by the mg-rast site done in 2017.
- [mgrast_json](01_original_data/mgrast_json/) contains the zip of json files obtained by the mg-rast API of 7043 sample ids. It is stored in a separate folder for better organization when extracting the data.
- [coarse_classification](01_original_data/coarse_classification.csv) contains the samples after a coarse curatory of this data, which was the first steps into biome categorization. It also contains some SRA samples.
- [preprocessed_metadata](01_original_data/preprocessed_metadata.csv) is the merged data of the previous two tables achieved by an [R-script](../R/01_split_tables.R). We used this as a model for the refined curatory.
- [aquifer_samples](01_original_data/aquifer_samples.csv) is the result of the refined and manual curatory of aquifer SRA samples. This table is on its last stage and it is only used for merge in the end of the metadata curatory process.

## [02_dismembered_tables](02_dismembered_tables/)
- Tables splited by mg-rast biome classification got through the R-script [01_split_tables.R](../R/01_split_tables.R).

## [03_manual_labeling](03_manual_labeling/)
- Initially, the same content as the [02_dismembered_tables](02_dismembered_tables/). Then we manually grouped the tables into tematic folders.

- Each table there was manually analyzed and finelly labeled.  
This processes have many subjective decisions of the team, but some standard procedures was the reading of the project description, and mg-rast metadata in the look for contradictions. We also used samples names to remove samples suspected to being of contigs, scaffolds, assemblies, RNA and cDNA sequencing.


- Each directory there contains a README.MD file serving as a logbook of the manual curatory process.

## [04_assembled_removal](04_assembled_removal/)

**we need to add the samples download before this step**

This is the Final step of the metadata curatory process.

- We used the [R-script](../R/03_remove_assembled.R) to remove the assembled samples from the tables based on Json files, and on the [genomic's reads information](../summaries/genomic_read_summary.csv).

- For internal consume we also prepared some additional summaries:
    - Summaries of samples removed by genomic content filter on each category;
        - [Life-Style](04_assembled_removal/summary_problematic_life_style.csv);
        - [Ecosystem](04_assembled_removal/summary_problematic_ecosystem.csv)
        - [Habitat](04_assembled_removal/summary_problematic_habitat.csv)
    - [Problematic samples for removal](04_assembled_removal/problematic_samples.csv);
    - [Cleaned table of samples to be used in downstream analysis](04_assembled_removal/genomic_content_clean_table.csv).

- From this point we produce a very important file, the [biome_classification](../metadata/biome_classification.csv)


## Repository organization
Director: Brait LAS
Co-Directors: Burgos D, Galvao E
Supervisor: Meirelles PM
