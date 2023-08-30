#' @title merge_sampleinfo
#' @description Merge two long-tables and keep the important metadata variables.
#' @param annotation_df the annotated table.
#' @param metadata_df the metadata table.
#' @param metadata_variables the variables to include in the annotation.
#' @returns The merged table, with the selected metadata variables.
merge_sampleinfo <- function(
    annotation_df,
    metadata_df,
    metadata_variables,
    by = "samples") {
    
    metadata_variables <- c(by, metadata_variables)

    metadata_filtered <- metadata_df %>%
        dplyr::select(
            metadata_variables)

    metagenomes_metadata <- inner_join(
        metadata_filtered,
        annotation_df,
        by = by)


return(metagenomes_metadata)
}
