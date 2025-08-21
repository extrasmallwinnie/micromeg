#' Title
#'
#' @param ... inherited from something tbd
#'
#' @returns An example of a "bad" metadata, ASV table, or taxonomy object
#' @export
#'
#' @examples
#' makeBadExample("meta")
makeBadExample <- function(...) {
  if (... == "meta" | ... == "metadata") {
    meta <- makeExampleMeta()
    metaNoSampleID <- meta %>% rename(ID = .data$SampleID)
    return(metaNoSampleID)
  }

  temp <- makeExample(...)
  return(temp)
}
