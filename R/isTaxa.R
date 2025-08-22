#' Is an object a taxonomy table?
#'
#' This function tries to identify if a data frame or tibble is a taxonomy table or not. It is called by other functions, and isn't intended to be used by end user.
#'
#' @param x A data frame or tibble
#'
#' @returns TRUE if it thinks object is a taxonomy table, FALSE otherwise
#' @export
#'
#' @examples
#' isTaxa(exampleMetadata) # returns FALSE
#' isTaxa(exampleASVtable) # returns FALSE
#' isTaxa(exampleTaxa) # returns TRUE
isTaxa <- function(x) {
  all_numeric <- all(sapply(x[-1], is.numeric))
  first_column_character <- all(sapply(x[1], is.character))

  restricted_taxa_names <- if (ncol(x) == 8) {
    all(names(x) == dada2TaxaNames())
  } else {
    FALSE
  }

  if (all(!all_numeric, first_column_character, restricted_taxa_names == TRUE)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
