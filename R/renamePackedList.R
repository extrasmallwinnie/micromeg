#' Title
#'
#' Not intended to be used by end user
#'
#' @param x tba
#'
#' @returns
#' @export
#'
#' @examples
#' renamePackedList(exampleData)
renamePackedList <- function(x) {
  for (i in seq_along(x)) {
    # Check if the list element is an ASV table"
    if (isASVtable(x[[i]])) {
      names(x)[i] <- "asvtable"
    }
  }

  for (i in seq_along(x)) {
    # Check if the list element is a taxonomy table"
    if (isTaxa(x[[i]])) {
      names(x)[i] <- "taxa"
    }
  }

  for (i in seq_along(x)) {
    # Check if the list element is a metadata table"
    if (isMeta(x[[i]])) {
      names(x)[i] <- "metadata"
    }
  }

  return(x)
}
