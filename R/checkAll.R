#' Title
#'
#' @param x Objects to check (either a single list) or three objects
#' @param ... can take a flexible number of arguments
#'
#' @returns something
#' @export
#'
#'
#' @examples
#' checkAll(exampleData)
#' checkAll(exampleMetadata, exampleASVtable, exampleTaxa)
checkAll <- function(x, ...) {
  if (switcher(x, ...) == "packedUp") {
    if (dplyr::setequal(names(x), c("metadata", "asvtable", "taxa"))) {
      return(x)
    }
    if (!dplyr::setequal(names(x), c("metadata", "asvtable", "taxa"))) {
      return(renamePackedList(x))
    }
  }

  if (switcher(x, ...) == "notPackedUp" & nargs() != 3) {
    stop("You must provide either three arguments (asvtable, taxa table, metadata) or one argument (a list containg those three).")
  }

  if (switcher(x, ...) == "notPackedUp" & nargs() == 3) {
    print("get to this later")
  }
}
