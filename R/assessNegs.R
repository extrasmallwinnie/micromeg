assessNegs <- function(asvtable=NULL, ...){
 metadataWithNegs <- identifyNegs(...)
 both <- dplyr::inner_join(metadataWithNegs, asvtable, by="SampleID")
 both <- both %>% mutate(ReadCount = rowSums(across(colnames(asvtable[-1]))))

 return(both)

 print(ggplot2::ggplot(both, ggplot2::aes(x=.data[[column_to_look_in]], y=ReadCount)) + ggplot2::geom_boxplot())
}
