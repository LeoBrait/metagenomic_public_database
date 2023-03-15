##Script for romoving samples that contain reads above
##400 bp that is aprox. the max read size from illumina##
metadata_table <- read.csv("data/06_collected_metadata_read_sizes/collected_metadata_output-1.csv", 
    header = TRUE, sep = ";")

str(metadata_table)

#Remove rows that are above 400 bp
metadata_table <- metadata_table[metadata_table$read_mean_lenght < 400,]

#Save table
write.csv(metadata_table, file = "data/06_collected_metadata_read_sizes/datacollected_metadata_output-filtered.csv",
    row.names = FALSE)

