#' Filter the ASV table
#'
#' @param seqtab Input ASV table
#' @param minDepth Minimum number of reads a sample must have to be kept
#' @param minASVCount Minimum count an ASV must have to be kept
#'
#' @returns A filtered ASV table
#' @export
#' @import dplyr
#' @import magrittr
#'

filtering <- function(seqtab, minDepth, minASVCount){
  seqtab %>% dplyr::rowwise() %>% dplyr::mutate("row.sum" = sum(dplyr::c_across(where(is.numeric)))) %>% dplyr::filter(row.sum > minDepth) %>% dplyr::select(-c("row.sum")) %>% dplyr::select(c("X", where(~ is.numeric(.) && sum(.) >= minASVCount))) %>% dplyr::rename("SampleID" = "X") %>% ungroup()
}
