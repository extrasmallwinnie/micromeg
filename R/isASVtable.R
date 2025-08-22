#' Is an object an ASV table?
#'
#' This function tries to identify if a data frame or tibble is an ASV table or not. It is called by other functions, and isn't intended to be used by end user.
#'
#' @param x A data frame or tibble
#'
#' @returns TRUE if it thinks object is an ASV table, FALSE otherwise
#' @export
#'
#' @examples
#' isASVtable(exampleMetadata) # returns FALSE
#' isASVtable(exampleASVtable) # returns TRUE
isASVtable <- function(x) {
  all_numeric <- all(sapply(x[-1], is.numeric))
  all_complete_cases <- sum(!stats::complete.cases(x)) == 0
  first_column_character <- all(sapply(x[1], is.character))

  if (all(all_numeric, all_complete_cases, first_column_character)) {
    return(TRUE)
  } else {
    return(FALSE)
  }

  # if (all_numeric & all_complete_cases & first_column_character) {
  #  return(x)
  # } else {
  # print("probably not an asv table")
  # }
}
