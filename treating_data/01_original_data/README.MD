# Original data

## Introduction
Here you will find the original data we used to build the BIOME database.

## Tables
1. `mg-rast_raw.csv` contains only information obtained by the mg-rast API.
All samples (n = 7044) are the result of a manual filtering by the mg-rast site done in 2017.
2. `gross_classification.csv` contains the samples after a gross curatory of this data, which was the first steps into biome categorization. It also contains some SRA samples.
3. `preprocessed.csv` is the merged data of the previous two tables achieved by an [R-script](../../R/01_split_tables.R). We used this as a model for the refined curatory.
4. `aquifer_samples.csv` is the result of the refined and manual curatory of aquifer SRA samples. This table is on its last stage and it is only used for merge in the end of the metadata curatory process.