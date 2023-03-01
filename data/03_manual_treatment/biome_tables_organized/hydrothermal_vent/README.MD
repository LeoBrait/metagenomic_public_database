1. This README is for documentating any alterations and observations in made in the datasets.

Responsavel: Diogo

hydrothermal_vent folder:

	hydrothermal vent dataset:

		sample mgm4448187 - column "metagenome_taxonomy" changed from NA to "hydrothermal vent" 
		 because "feature" and "material" are "hydrothermal vent";

		samples mgm4441102, mgm4441663 and mgm4448187 - column material changed from "hydrothermal vent"
		 to "hydrothermal vent water" to be congruent with the type of variable the column represents;

    marine hydrothermal vent dataset:

		samples mgm4644368, mgm4644369 and mgm4644370 - has assembled in sample name, should be deleted; 

		samples mgm4667949, mgm4668298, mgm4668300, mgm4668301, mgm4668302, mgm4668303, mgm4668304, 
		 mgm4668305 - column "metagenome_taxonomy" changed from NA to "hydrothermal vent" because the biome
		 classification from mg-rast (raw_biome column) is "hydrothermal vent" and it makes sense considering
		 the coordinates from the samples, that is in the north shore of Taiwan, wich have several hydrothermal vents.
		 In those same samples the column "material" changed from "sea water" to "hydrothermal vent water" to be
		 coherent with the alteration in the previous dataset.
		 In tose same samples column "continent" changed from NA to "asia";

		sample mgm4668302 - column "country" changed from "China" to "Taiwan" because it have the same coordinates
		 as the other samples, wich is in Taiwan;