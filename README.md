# BIOME METAGENOMIC PUBLIC DATABASE

## Introduction  
  
The BIOME metagenomic public database contains 6130 metagenomic samples collected from MG-RAST and NCBI databases. The samples were recategorized based on two methods, the authoral BIOME classification and the IUCN classification.  
These datbase comprimises other works of the lab, such as:
- [Aquifers Landscapes](https://github.com/MeirellesLab/aquifer_metagenomes)
- [New Microbial Keystones](https://github.com/MeirellesLab/keystones_paper)

**warning: None of the present data should be shared or used without the consent of the supervisor Dr. Pedro Meirelles.**

## Data organization
- In the [annotated_genomes](annotated_genomes/) you will find the taxonomic relative abundance matrices generated by Kraken2 using the Biome database.  
- in the [final_metadata](final_metadata/) you will find the final version of the BIOME classification and the IUCN classification.  
- in the [genomic_content_summaries](genomic_content_summaries/) folder you will find the genomic content information of our samples.  
- in the [reclassification_2022](reclassification_2022/) folder you will find the pipelines we used to produce our final metadata. (control porpuses only)  

## Detailed information about the metadata
  
### 1. Biome classification information  

#### The BIOME classification is based on the ecologic and geographic information of the samples. There we have:  
  
##### 2 life-styles   
```
free-living         holobiont
  
```
##### 3 biospheres  
```
freshawater         marine                  terrestrial
```
  
##### 9 ecosystems  
```
wastewater          animal_host-associated  saline_water 
soil                freshwater              human_host-associated
plant-associated    sediment                groundwater
```
  
##### 85 habitats  
```
sludge              animal_feces            coastal_seawater
desert_soil         hot_spring              human_feces
sponge              saline_marsh            bodily_fluid
plant-associated    estuarine_seawater      human-gut
bone                coastal_marine_sediment park_soil
sewage              animal_manure           wastewater_treatment_plant
agricultural_soil   rhizosphere             hydrothermal_vent
oceanic_seawater    lake                    drinking_water_reservoir
polar_seawater      reactor_sludge          forest_soil
mangrove_sediment   coral                   saliva
anoxic_seawater     pasture_soil            continental_slope_sediment
farm_soil           stream                  plant-associated_hypersaline_water
hypersaline_water   compost                 saline_marsh_sediment
tundra_soil         lake_sediment           anaerobic_sediment
alkaline_salt_lake  permafrost              contaminated_soil
peat_soil           river                   reclaimed_water
sea_worm            meadow_soil             human_associated_biofilm
grassland           wood_fall               saline_water_biofilm
river_sediment      salt_lake               prairie
lung                rumen                   coral_reef_seawater
river_saline        savanna_soil            alkaline_environment
contaminated_water  desert_sediment         freshwater_biofilm
stream_biofilm      human-skin              chyme
street_sweepings    beef                    oil_affected_sediment
animal_gut          saline_evaporation_pond shrubland_soil
marine_biofilm      garden_soil             aqueous_humour
coral_reef_biofilm  karst-porous            porous_contaminated
mine                subsurface_saline       porous
geyser
```





