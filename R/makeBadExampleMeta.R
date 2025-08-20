#' Make a "bad" metadata object that will fail checks
#'
#' @param operation "ids", "dups", or "wrongmeta"
#'
#' @returns A "bad" metadata object that will throw up warnings on sanity checks
#' @export
#'
#' @examples
#' makeBadExampleMeta("ids")
#' makeBadExampleMeta("dups")
#' makeBadExampleMeta("wrongmeta")
makeBadExampleMeta <- function(operation) {
  result <- switch(operation,
                   "ids" = makeExampleMeta() %>% dplyr::rename(ID=.data$SampleID), # rename SampleID column
                   "dups" = makeExampleMeta() %>% dplyr::mutate("SampleID" = replace(.data$SampleID, .data$SampleID == "HC2", "HC1")), # create a duplicated value in SampleID column
                   "wrongmeta" = makeExampleMeta() %>% dplyr::mutate("SampleID" = paste0(.data$SampleID, "0")),
                   "default" = "Invalid operation")
  return(result)
}
