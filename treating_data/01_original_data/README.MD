# Original data

## Introduction
Here you will find the original data we used to build the BIOME database.

## Content
1. `mgrast_raw.csv` contains only information obtained by the mg-rast API.
All samples (n = 7044) are the result of a manual filtering by the mg-rast site done in 2017.
2. [mgrast_json](mgrast_json) contains the zip of json files obtained by the mg-rast API of 7043 sample ids. It is stored in a separate folder for better organization when extracting the data.
3. [coarse_classification](coarse_classification.csv) contains the samples after a coarse curatory of this data, which was the first steps into biome categorization. It also contains some SRA samples.
4. `preprocessed.csv` is the merged data of the previous two tables achieved by an [R-script](../../R/01_split_tables.R). We used this as a model for the refined curatory.
5. `aquifer_samples.csv` is the result of the refined and manual curatory of aquifer SRA samples. This table is on its last stage and it is only used for merge in the end of the metadata curatory process.