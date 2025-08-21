#' Create an example object
#'
#' @param what What do you want to create? Valid options are meta (for a metadata table), asv (for an ASV table), or taxa (for a taxonomy table)
#'
#' @returns Either a metadata, ASV, or taxonomy table, or a list of all three.
#' @export
#'
#' @examples
#' metadata <- makeExample("meta")
#' asvtable <- makeExample("asv")
#' taxa <- makeExample("taxa")
#' all <- makeExample() # OR:
#' all <- makeExample("all")
makeExample <- function(what = NULL) {
  if (is.null(what)) {
    return(list("metadata" = makeExampleMeta(), "asvtable" = makeExampleSeqtab(), "taxa" = makeExampleTaxa()))
  }
  if (is.null(what) | what == "all") {
    return(list("metadata" = makeExampleMeta(), "asvtable" = makeExampleSeqtab(), "taxa" = makeExampleTaxa()))
  }
  if (what == "meta" | what == "metadata") {
    return(makeExampleMeta())
  }
  if (what == "asv" | what == "asvtable" | what == "seqtab") {
    return(makeExampleSeqtab())
  }
  if (what == "taxa" | what == "taxonomy") {
    return(makeExampleTaxa())
  }
  if (what != "meta" & what != "metadata" & what != "asv" & what != "asvtable" & what != "seqtab" & what != "taxa" & what != "taxonomy" & what != "all" & !is.null(what)) {
    stop("Valide options are 'all', 'meta' or 'metadata', 'asv' or 'asvtable' or 'seqtab', or 'taxa' or 'taxonomy'.")
  }
}
