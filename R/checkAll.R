checkAll <- function(x, ...){
  if(nargs() != 1 & nargs() != 3){
    stop(sprintf("The number of arguments to provide to this function must be either 3 (metadata, ASV count, ASV taxa objects) or 1 (a list containing those 3 objects). The number of arguments you provided was %s.", nargs()))
  }

  if(nargs() == 1 & class(x)[1] != "list"){
    stop(sprintf("You only provided one argument, %s, but it is not a list. The number of arguments to provide to this function must be either 3 (metadata, ASV count, ASV taxa objects) or 1 (a list containing those 3 objects)", deparse(substitute(x))))
  }

  if(nargs() == 1 & class(x)[1] == "list" & all(names(x) != c("metadata", "asvtable", "taxa"))){
    stop(sprintf("The names of objects in your list do not match the expected convention. Use function packItUp() to create a list that will work with this package."))
  }

  if(nargs() == 1 & class(x)[1] == "list" & all(names(x) == c("metadata", "asvtable", "taxa"))){
    metadata <- x$metadata
    asvtable <- x$asvtable
    taxa     <- x$taxa
    #return(taxa)
  }

  if(nargs() == 3){
    args <- list(...) # Convert ... to a list
    for (arg in args) {
      print(arg)
    }
  }
}
