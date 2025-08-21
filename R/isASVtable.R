isASVtable <- function(x){

  all_numeric <- all(sapply(x[-1], is.numeric))
  all_complete_cases <- sum(!stats::complete.cases(x)) == 0
  first_column_character <- all(sapply(x[1], is.character))

  if(all_numeric & all_complete_cases & first_column_character){
    print("could be an asv table")
  } else {
      print("probably not an asv table")
    }

}
