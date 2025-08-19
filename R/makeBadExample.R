#' Title
#'
#' @param ... inherited from something tbd
#'
#' @returns An example of a "bad" metadata, ASV table, or taxonomy object
#' @export
#'
#' @examples
#' makeBadExample("meta")
makeBadExample <- function(...){

  if(...=="meta" | ...=="metadata"){
    meta <- makeExampleMeta()
    metaNoSampleID <- meta %>% rename(ID=.data$SampleID)
    return(metaNoSampleID)
  }

  temp <- makeExample(...)
  return(temp)
}

makeBadExampleMeta <- function(operation) {
  result <- switch(operation,
                   "ids" = makeExampleMeta() %>% dplyr::rename(ID=.data$SampleID), # rename SampleID column
                   "dups" = makeExampleMeta() %>% dplyr::mutate("SampleID" = replace(.data$SampleID, .data$SampleID == "HC2", "HC1")), # create a duplicated value in SampleID column
                   "default" = "Invalid operation")
  return(result)
}

makeBadExampleASV <- function(operation) {
  result <- switch(operation,
                   "ids" = makeExampleSeqtab() %>% dplyr::rename(ID=.data$SampleID), # rename SampleID column
                   "remove" = makeExampleSeqtab() %>% dplyr::select(-utils::tail(names(makeExampleSeqtab()), 2)), # remove some ASVs so it won't match the taxa table anymore
                   "default" = "Invalid operation")
  return(result)
}
