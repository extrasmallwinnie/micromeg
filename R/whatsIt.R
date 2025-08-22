whatsIt <- function(x) {
  if (class(x)[1] == "list") {
    if (switcher(x) == "packedUp") {
      return("packedUp")
    }
  }
  if (isASVtable(x) == TRUE) {
    return("asvtable")
  }
  if (isMeta(x) == TRUE) {
    return("metadata")
  }
  if (isTaxa(x) == TRUE) {
    return("taxa")
  }
}
