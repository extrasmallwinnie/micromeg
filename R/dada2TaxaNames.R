#' Returns a character vector of expected column names for dada2 taxonomy object
#'
#' Not intended to be used by end user; is called upon by other functions.
#'
#' @returns Returns a character vector of expected column names for dada2 taxonomy object
#' @export
#'
#' @examples
#' dada2TaxaNames()
dada2TaxaNames <- function() {
  return(c("ASV", "Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species"))
}
