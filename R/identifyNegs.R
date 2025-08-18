#' Add a column to metadata object which identifies lab negative controls
#'
#' @param df Your metadata object
#' @param column_to_look_in What is the name of the column that identifies which controls are negative?
#' @param how What pattern should be looked for in the column to find the negative controls in that column?
#'
#' @returns An updated metadata object with a column called isNeg identifying lab negative controls
#' @export
#'
#' @examples
#' metadata <- makeExampleMeta()
#' identifyNegs(metadata, "SampleType", "negative control")  # "how" can be a vector e.g., "c("negative", "neg control", "negative control")
identifyNegs <- function(df=NULL, column_to_look_in=NULL, how=NULL){
  #df$isNeg <- 0
  #df$isNeg[df[[column_to_look_in]]==how] <- 1

  df <- df %>% dplyr::mutate(isNeg = dplyr::case_when(
                                      .data[[column_to_look_in]] %in% how ~ 1,
                                      !(.data[[column_to_look_in]] %in% how) ~ 0)
                            )
  return(df)
}
