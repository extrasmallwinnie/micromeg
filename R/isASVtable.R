isASVtable <- function(x) {
  all_numeric <- all(sapply(x[-1], is.numeric))
  all_complete_cases <- sum(!stats::complete.cases(x)) == 0
  first_column_character <- all(sapply(x[1], is.character))

  all(all_numeric, all_complete_cases, first_column_character)

  #if (all_numeric & all_complete_cases & first_column_character) {
  #  return(x)
  #} else {
    #print("probably not an asv table")
  #}
}
