checkAll <- function(x, ...) {
  if (switcher(x, ...) == "packedUp") {
    if (dplyr::setequal(names(x), c("metadata", "asvtable", "taxa"))) {
      # metadata <- x$metadata
      # asvtable <- x$asvtable
      # taxa     <- x$taxa
      return(x)
    }
    if (!dplyr::setequal(names(x), c("metadata", "asvtable", "taxa"))) {
      asvtable <- for (i in x) {
        # print(i)
        if (isASVtable(i) == TRUE) {
          return(i)
        }
      }

      metadata <- for (i in x) {
        # print(i)
        if (isMeta(i) == TRUE) {
          return(i)
        }
      }

      taxa <- for (i in x) {
        # print(i)
        if (isTaxa(i) == TRUE) {
          return(i)
        }
      }

      new_x <- packItUp(metadata, asvtable, taxa)
      return(new_x)
      # return(asvtable)
    }
  }
}
