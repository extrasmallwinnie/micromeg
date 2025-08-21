#' Package up your three objects (metadata, asvtable, taxonomy table) into a single list for less typing
#'
#' @param metadata Metadata object
#' @param asvtable ASV count table object
#' @param taxa Taxonomy table object
#'
#' @returns A list containing those three objects
#' @export
#'
#' @examples
#' packItUp(makeExample()$metadata, makeExample()$asvtable, makeExample()$taxa)
packItUp <- function(metadata=NULL, asvtable=NULL, taxa=NULL){
  return(list("metadata" = metadata, "asvtable" = asvtable, "taxa" = taxa))
}
