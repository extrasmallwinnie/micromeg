#' Title
#'
#' Not intended to be used by end user
#'
#'
#' @param x list or set of arguments
#' @param ... flexible
#'
#' @returns
#' @export
#'
#' @examples
#' switcher(exampleData)
switcher <- function(x, ...) {
  numArgs <- nargs()
  firstClass <- class(x)[1]
  firstClassNames <- names(x)

  if (numArgs != 1 & numArgs != 3) {
    stop(sprintf("The number of arguments to provide to this function must be either 3 (metadata, ASV count, ASV taxa objects) or 1 (a list containing those 3 objects). The number of arguments you provided was %s.", nargs()))
  }

  if (numArgs == 1 & firstClass != "list") {
    stop(sprintf("You only provided one argument, %s, but it is not a list. The number of arguments to provide to this function must be either 3 (metadata, ASV count, ASV taxa objects) or 1 (a list containing those 3 objects)", deparse(substitute(x))))
  }

  # if(numArgs == 1 & firstClass == "list" & all(firstClassNames != c("metadata", "asvtable", "taxa"))){
  #    stop(sprintf("The names of objects in your list do not match the expected convention. Use function packItUp() to create a list that will work with this package."))
  #  }

  if (numArgs == 1) {
    return("packedUp")
  }

  if (numArgs == 3) {
    # packedUp <- FALSE
    return("notPackedUp")
  }

  # sprintf("Number of arguments was %s; first class was %s", numArgs, firstClass)

  #  if (class(x)[1] != "data.frame" & class(x)[1] != "list" & class(x)[1] != "tbl_df") {
  #    warning("Object was not detected to be a list, tibble, or data frame, so this function isn't going to work properly.")
  #  }

  # if (class(x)[1] == "data.frame") {
  #  print("is a data frame")
  # }

  # if (class(x)[1] == "list") {
  #  print("is a list")
  # }

  # if (class(x)[1] == "tbl_df") {
  #  print("is a tibble")
  # }
}
