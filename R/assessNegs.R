assessNegs <- function(asvtable=NULL, ...){
 metadataWithNegs <- identifyNegs(...)
 both <- dplyr::inner_join(metadataWithNegs, asvtable, by="SampleID")
 both <- both %>% mutate(ReadCount = rowSums(across(colnames(asvtable[-1]))))

 return(both)
}
