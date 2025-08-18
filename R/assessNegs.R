assessNegs <- function(metadata=NULL, asvtable=NULL){
  negs <- metadata %>% filter(SampleType == "negative control")
  negsasv <- asvtable %>% filter(SampleID == "NegControl1")
}
