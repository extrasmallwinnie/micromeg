#' Create a simple taxonomy table
#'
#' @returns Simple taxonomy table for testing and demonstration purposes.
#' @export
#'
#' @examples
#' taxa <- makeExampleTaxa()
makeExampleTaxa <- function(){
  tibble::tibble(ASV=c("ASV1", "ASV2", "ASV3", "ASV4", "ASV5", "ASV6", "ASV7", "ASV8", "ASV9"),
                 Kingdom=c(rep("Bacteria", 9)),
                 Phylum=c("Proteobacteria", "Bacteroidota", "Firmicutes", "Proteobacteria", "Firmicutes", "Bacteroidota", "Bacteroidota", "Proteobacteria", "Bacteroidota"),
                 Class=c("Gammaproteobacteria", "Bacteroidia", "Bacilli", "Gammaproteobacteria", "Bacilli", "Bacteroidia", "Bacteroidia", "Gammaproteobacteria", "Bacteroidia"),
                 Order=c("Pasteurellales", "Bacteroidales", "Staphylococcales", "Pasteurellales", "Lactobacillales", "Bacteroidales", "Bacteroidales", "Xanthomonadales", "Bacteroidales"),
                 Family=c("Pasteurellaceae", "Prevotellaceae", "Staphylococcaceae", "Pasteurellaceae", "Streptococcaceae", "Prevotellaceae", "Prevotellaceae", "Xanthomonadaceae", "Prevotellaceae"),
                 Genus=c("Haemophilus", "Prevotella", "Staphylococcus", "Haemophilus", "Streptococcus", "Alloprevotella", "Alloprevotella", "Stenotrophomonas", "Alloprevotella"),
                 Species=c(NA, "melaninogenica", NA, NA, NA, "rava", NA, NA, NA))
}
