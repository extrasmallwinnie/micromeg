#' Check your ASV count and taxonomy tables for potential issues.
#'
#' @param asvtable The ASV table
#' @param taxa Its associated taxonomy table
#' @param metadata The associated metadata table
#'
#' @returns Potential warnings or errors.
#' @export
#'
#' @examples
#' asvtable <- makeExample("asv")
#' taxa     <- makeExample("taxa")
#' metadata <- makeExample("meta")
#' checkASV(asvtable, taxa, metadata)
checkASV <- function(asvtable, taxa, metadata){
  if(!ncol(asvtable[-1]) == nrow(taxa)) {
    stop(sprintf("The number of ASVs in your ASV table doesn't match the number of ASVs in your taxonomy table."))
  }

  if(!all(colnames(asvtable[-1]) == taxa$ASV)) {
    stop(sprintf("The names of your ASVs in your ASV table don't match the names in the taxonomy table."))
  }

  if(nrow(tibble::as_tibble(table(tibble::as_tibble(sapply(asvtable[-1], class)))))>1) {
    warning(sprintf("In your ASV table, not all columns (other than the SampleID) were identified as numeric. Check that you don't have anything that's not a number in your ASV count columns."))
  }

  if(nrow(merge(metadata, asvtable, by="SampleID"))<1) {
    warning(sprintf("After merging your metadata and ASV objects, no samples were retained. Check that the SampleIDs match in each object. For example, you may have a non-matching number of padded zeroes."))
  }
}

