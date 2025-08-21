switcher <- function(x){

  if(class(x)[1] != "data.frame" & class(x)[1] != "list" & class(x)[1] != "tbl_df"){
    warning("Object was not detected to be a list, tibble, or data frame, so this function isn't going to work properly.")
  }

  if(class(x)[1] == "data.frame") {
    print("is a data frame")
  }

  if(class(x)[1] == "list") {
    print("is a list")
  }

  if(class(x)[1] == "tbl_df") {
    print("is a tibble")
  }
}
