#' Is an object a metdata table?
#'
#' This function tries to identify if a data frame or tibble is a metadata table or not. It is called by other functions, and isn't intended to be used by end user.
#'
#' @param x A data frame or tibble
#'
#' @returns TRUE if it thinks object is a metadata table, FALSE otherwise
#' @export
#'
#' @examples
#' isMeta(exampleMetadata) # returns TRUE
#' isMeta(exampleASVtable) # returns FALSE
isMeta <- function(x) {
  all_numeric <- all(sapply(x[-1], is.numeric))
  first_column_character <- all(sapply(x[1], is.character))

  not_restricted_taxa_names <- if (ncol(x) != 8) {
    TRUE
  } else {
    all(names(x) != dada2TaxaNames())
  }

  if (all(!all_numeric, first_column_character, not_restricted_taxa_names)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
