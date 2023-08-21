# Data processing
Description of the folder contents and resumed information about the data processing.

## [01_original_data](01_original_data/)
- [mgrast_json](01_original_data/mgrast_json/) contains the zip of json files obtained by the mg-rast API of 7043 sample id's by a [Python script](../Python/mgrast_download_metadata.py). It is stored in a separate folder for better organization when extracting the data.
- [MG-rast coarse_classification](01_original_data/mgrast_coarse_classification.csv) contains the samples after a coarse curatory of this data, which was the first steps into biome categorization.
- [aquifer_samples](01_original_data/aquifer_samples.csv) ia previously curated data from SRA and Mg-Rast. This table is already in its last stage and it is only used for merge in the end of the metadata curatory process.

## [02_dismembered_tables](02_dismembered_tables/)
- Tables splited by mg-rast biome classification got through the R-script [01_treat_split.R](../R/treat_split.R).

## [03_manual_labeling](03_manual_labeling/)
- It have the same content as the [02_dismembered_tables](dismembered_tables/), but thematically organized for manual curatory.

- Each table there was manually analyzed and detailed categorized.  
This processes have many subjective decisions of the team, but some standard procedures was the reading of the project description, and mg-rast metadata in the look for contradictions. We also used samples names to remove samples suspected to being of contigs, scaffolds, assemblies, RNA and cDNA sequencing.

- Each directory there contains a README.MD file serving as a log-book of the manual curatory process.

## [06_assembled_removal](06_assembled_removal/)

**we need to add the samples download before this step**

This is the Final step of the metadata curatory process.

- We used the [R-script](../R/remove_assembled.R) to remove the assembled samples from the tables based on Json files, and on the [genomic's reads information](../summaries/genomic_read_summary.csv).

- For internal consume we also prepared some additional summaries:
    - Summaries of samples removed by genomic content filter on each category;
        - [Life-Style](06_assembled_removal/summary_problematic_life_style.csv);
        - [Ecosystem](06_assembled_removal/summary_problematic_ecosystem.csv)
        - [Habitat](06_assembled_removal/summary_problematic_habitat.csv)
    - [Problematic samples for removal](06_assembled_removal/badsamples.csv);
    - [Cleaned table of samples to be used in downstream analysis](06_assembled_removal/genomic_content_clean_table.csv).

- From this point we produce a very important file, the [biome_classification](../metadata/biome_classification.csv)


## Repository organization
Director: Brait LAS
Co-Directors: Burgos D, Galvao E
Supervisor: Meirelles PM
