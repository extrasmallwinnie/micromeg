tryToGuess <- function(x, ...) {
  # if(nargs() == 3){
  args <- list(x, ...)
  for (arg in args) {
    # print(arg)
    asvtable <- isASVtable(arg)
    return(asvtable)
  }
  # }
}
