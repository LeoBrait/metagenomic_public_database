

## [01_Original_data](01_Original_data/)
1. [mgrast_raw.csv](01_Original_data/mgrast_raw.csv) contains only information obtained by the mg-rast API.
All samples (n = 7044) are the result of a manual filtering by the mg-rast site done in 2017.
2. [mgrast_json](01_Original_data/mgrast_json/) contains the zip of json files obtained by the mg-rast API of 7043 sample ids. It is stored in a separate folder for better organization when extracting the data.
3. [coarse_classification](01_Original_data/coarse_classification.csv) contains the samples after a coarse curatory of this data, which was the first steps into biome categorization. It also contains some SRA samples.
4. [preprocessed_metadata](01_Original_data/preprocessed_metadata.csv) is the merged data of the previous two tables achieved by an [R-script](../R/01_split_tables.R). We used this as a model for the refined curatory.
5. [aquifer_samples](01_Original_data/aquifer_samples.csv) is the result of the refined and manual curatory of aquifer SRA samples. This table is on its last stage and it is only used for merge in the end of the metadata curatory process.

## [02_dismembered_tables](02_dismembered_tables/)
- Tables splited by mg-rast biome classification got through the R-script [01_split_tables.R](../R/01_split_tables.R).

## [03_manual_labeling](03_manual_labeling/)
1. Initially, the same content as the [02_dismembered_tables](02_dismembered_tables/). Then we manually grouped the tables into tematic folders.

2. Each table there was manually analyzed and finelly labeled.

3. Each directory there contains a README.MD file serving as a logbook of the manual curatory process.

## [04_merged_labeled](04_merged_labeled/)

## [05_refined_curatory](04_refined_curatory/)
### Tables
- Summaries of samples removed by genomic content filter on each category;
    - [Life-Style](summary_problematic_life_style.csv);
    - [Ecosystem](summary_problematic_ecosystem.csv)
    - [Habitat](summary_problematic_habitat.csv)
- [Problematic samples for removal](problematic_samples.csv);
- [Cleaned table of samples to be used in downstream analysis](genomic_content_clean_table.csv).
# Treatment of MG-RAST samples metadata

Some database samples downloaded from the MG-RAST contains incorrect metadata information. 
To address this issue, we have manually reevaluated the sample metadata for accuracy. 
Mistakes include contradictions between sequencing type and sample name, 
incorrect coordinates, and discrepancies between sample categories metadata and 
project descriptions. Our goal is to provide more accurate data information.

---

## Procedures for metadata reavaliation

1. We used a python script to download all samples metadata from the MG-RAST api.
Then we have selected the important metadata columns to reavaliate. 
The considereted columns were the sample name, feature, biome, material, "env_package", 
"metagenome_taxonomy", coordinates and country. 

2. For the manual repair of the contradictions we have analyzed first the individual
column of the sample name to remove samples with contigs, scaffolds and assemblies.
Futhermore we have filtered samples with the name "RNA" and "cDNA".

3. To analyze mistakes or contradictions we compared the project description with 
the sample name, biome, material, feature, env_package and coordinates.

4. To detect incorrect coordinates we also reviewed the project description in 
combination to metadata categories such as feature, biome, material, 
metagenome taxonomy, "env_package" and if necessary the country.

---

## Repository organization

@Diogo Burgos @Leonardo Brait @Eduardo Galvao, must develop this part for organization purposes
