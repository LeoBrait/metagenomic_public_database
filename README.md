# BIOME METAGENOMIC PUBLIC DATABASE

**warning: None of the present data should be shared or used without the consent of the supervisor Dr. Pedro Meirelles.**  
**warning: None of the present data should be shared or used without the consent of the supervisor Dr. Pedro Meirelles.**  
**warning: None of the present data should be shared or used without the consent of the supervisor Dr. Pedro Meirelles.**  
## Introduction  
  
The BIOME metagenomic public database contains N?? metagenomic samples collected from MG-RAST and NCBI databases. The samples were recategorized based on two methods, the authoral BIOME classification and the IUCN classification.  
This database comprimises other works of the lab, such as:
- [Aquifers Landscapes](https://github.com/MeirellesLab/aquifer_metagenomes)
- [New Microbial Keystones](https://github.com/MeirellesLab/keystones_paper)

## Data organization
- **The [data_processing](data_processing/) contains step-by-step used to process the data.**  
    - The data_processing folder is procedimental and used by the scripts to produce the ready-to-use data contained in all cited bellow.
    For more Details, please check the [readme](data_processing/README.md) file.  
- The [annotated_metagenomes](annotated_metagenomes/) contains the taxonomic relative and absolute abundance matrices generated by Kraken2 using the standard and Biome database.   
- The [metadata](metadata/) contains the BIOME and IUCN classifications of these samples.   
- The [summaries](summaries/) folder contains information about the samples, such as the number of reads, GC content, etc.

## Requirements
All scripts were executed in a Linux environment by bash, R and Python scripts.
- **R** version 4.3.1
- **Python** version 3.7.3
- **Bash** version 5.1.16(1)-release (x86_64-pc-linux-gnu)
- **Linux** Ubuntu 22.04 LTS (WSL2)

We also used the Anaconda 3 environment solver. You can install and use the required python packages by typing:

```bash
conda create --name biome_database --file Python/requirements.txt
conda activate biome_database
```

## Procediments and script order
This database started as a coarse curatory of the mg-rast metagenomic samples followed by a fine and detailed reclassification. The [coarse classification](data_processing/01_original_data/coarse_classification.csv) was done in the seek of short-reads metagenomes from natural environments that could be classified in life-style, ecosystem and habitats. The fine and detailed reclassification used the same principles, but more accurate.


### Metadata treatment

1. From the coarse classification [table](data_processing/01_original_data/coarse_classification.csv) we downloaded the metadata of all samples by a [python script](Python/mgrast_download_metadata.py). All metadata is stored in a [zip file](data_processing/01_original_data/mgrast_json/mgrast_raw.zip). You will need to unzip it to perform the next steps.

```bash
unzip data_processing/01_original_data/mgrast_json/mgrast_raw.zip -d data_processing/01_original_data/mgrast_json/
```

Or (not recomended) you can download all samples all over again by typing:

```bash
python3 Python/mgrast_download_metadata.py
```

2. To clean our data from some assembled samples we used [treat_split.R](R/treat_split.R). This script also splited the data in subsets on the [02_dismembered_tables](data_processing/02_dismembered_tables/) folder to facilitate the work of a fine labeling. To run the correspondent script, just type:

```bash
Rscript R/treat_split.R
```

3. The splited tables from [02_dismembered_tables](data_processing/02_dismembered_tables/) were manually grouped by themes in the folder [03_maunual_labeling](data_processing/03_manual_labeling/), where we performed a refined and detailed classification. 

4. The content of the folder got joined, them merged with [aquifer samples](data_processing/01_original_data/aquifer_samples.csv), resulting in the [merged and labeled table](data_processing/03_manual_labeling/merged_and_labeled.csv), the [mgrast sample list](data_processing/04_download_sequences/mgrast_list.txt) and [sra sample list](data_processing/04_download_sequences/sra_list.txt) . For this we used:
    
```bash 
Rscript R/merge_tables.R
```

### Downloading sequences

Missing step
### clean from assembled samples

```bash 
Rscript R/remove_assembled.R
```

## Troubleshooting



























































