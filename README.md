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

@Diogo Burgos @Eduardo Galvao, must develop this part for organization purposes
