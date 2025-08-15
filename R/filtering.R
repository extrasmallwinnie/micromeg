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

  if(max(rowSums(seqtab[-1])) < minDepth){
    warning(sprintf("Your filtering may remove all samples. Your minimum requested sequence depth is %s, which may be too aggressive for your data, as the maximum read count in your input data is %s.", minDepth, max(rowSums(seqtab[-1]))))
  }

  if(max(colSums(seqtab[,-1])) < minASVCount){
    warning(sprintf("Your filtering may remove all ASVs. Your minimum requested ASV count is %s, which may be too aggressive for your data, as the maximum ASV count in your input data is %s.", minASVCount, max(colSums(seqtab[,-1]))))
  }

  seqtabout <- seqtab %>% dplyr::rowwise() %>% dplyr::mutate("row.sum" = sum(dplyr::c_across(where(is.numeric)))) %>% dplyr::filter(row.sum >= minDepth) %>% dplyr::select(-c("row.sum")) %>% dplyr::select(c("X", where(~ is.numeric(.) && sum(.) >= minASVCount))) %>% dplyr::rename("SampleID" = "X") %>% ungroup()

  return(seqtabout)
}
