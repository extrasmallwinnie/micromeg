#' Make a "bad" ASV count object that will fail checks
#'
#' @param operation "ids", "remove", or "rename"
#'
#' @returns A "bad" ASV count object that will fail checks
#' @export
#'
#' @examples
#' makeBadExampleASV("ids")
#' makeBadExampleASV("remove")
#' makeBadExampleASV("replace")
makeBadExampleASV <- function(operation) {
  result <- switch(operation,
    "ids" = makeExampleSeqtab() %>% dplyr::rename(ID = .data$SampleID), # rename SampleID column
    "remove" = makeExampleSeqtab() %>% dplyr::select(-utils::tail(names(makeExampleSeqtab()), 2)), # remove some ASVs so it won't match the taxa table anymore
    "rename" = makeExampleSeqtab() %>% dplyr::rename(ATCG = .data$TACGGAGGGTGCGAGCGTTAATCGGAATAACTGGGCGTAAAGGGCACGCAGGCGGTTATTTAAGTGAGGTGTGAAAGCCCTGGGCTTAACCTAGGAATTGCATTTCAGACTGGGTAACTAGAGTACTTTAGGGAGGGGTAGAATTCCACGTGTAGCGGTGAAATGCGTAGAGATGTGGAGGAATACCGAAGGCGAAGGCAGCCCCTTGGGAATGTACTGACGCTCATGTGCGAAAGCGTGGGGAGCAAACAGG), # mess up name of an ASV
    "default" = "Invalid operation"
  )
  return(result)
}
