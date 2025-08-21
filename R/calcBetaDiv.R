#' Calculate beta diversity dissimilarities with or without rarefaction
#'
#' @param asvtable Input ASV table. Can be filtered with filtering()
#' @param numRare Number of rarefactions to perform. Set to 0 if you do not want to do any rarefication.
#' @param method Dissimilarity index to use. See ?vegan::vegdist for more information.
#'
#' @returns A dissimilarity matrix
#' @export
#'
#' @examples
#' asvtable <- makeExampleSeqtab()
#' calcBetaDiv(asvtable, 400, "bray")
calcBetaDiv <- function(asvtable, numRare = 400, method = "bray") {
  minlibrary <- min(rowSums(asvtable[-1]))

  if (numRare > 0) {
    rarefactions <- lapply(as.list(1:numRare), function(x) vegan::rrarefy(asvtable[-1], minlibrary))
    braycurtis <- lapply(rarefactions, function(x) vegan::vegdist(x, method = method, binary = TRUE))
    averagedbc <- Reduce("+", braycurtis) / length(braycurtis)
  } else {
    averagedbc <- vegan::vegdist(asvtable[-1], method = method, binary = TRUE)
  }
}
