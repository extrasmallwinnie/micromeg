#' Simple function to check for a column called SampleID
#'
#' @param df Your ASV table or metadata object
#'
#' @returns Your ASV table or metadata object with your sample IDs column named 'SampleID'
#' @export
#'
#' @examples
#' asvtable <- makeExample("asvtable")
#' checkSampleID(asvtable)
checkSampleID <- function(df) {
  if (!("SampleID" %in% colnames(df))) {
    user_input <- readline(sprintf("A column called 'SampleID' was not detected. What is the column name that you're using as your sample IDs? "))
    if (!(user_input %in% colnames(df))) stop(sprintf("Column '%s' wasn't found in your data. Look for typos.", user_input))
    user_answer <- readline(sprintf("Is it OK to change column name '%s' to 'SampleID'? y/n: ", user_input))
    if (user_answer != "y") print("OK, no change made since you did not press y.")
    if (user_answer == "y") {
      df <- df %>% rename(SampleID = user_input)
      return(df)
    }
  }

  if ("SampleID" %in% colnames(df)) {
    sprintf("Looks good")
  }
}
