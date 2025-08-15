#' Check your metadata file to identify potential downstream issues.
#'
#' @param df A data frame or tibble containing your sample metadata.
#' @param ids The column name in your data frame that identifies the sample IDs.
#'
#' @returns Returns warnings or errors with your metadata object that may cause downstream problems.
#' @export
#' @import tibble
#'
#' @examples
#' metadata <- data.frame(
#'                        SampleIDs = c("Sample1", "Sample2", "Sample3"),
#'                        Age       = c(34, 58, 21),
#'                        Health    = c("Healthy", "Sick", NA))
#' checkMeta(metadata, "SampleIDs")
checkMeta <- NULL
checkMeta1 <- function(df, ids = "SampleID") {
  if(!is.data.frame(df) & !tibble::is_tibble(df)) {
    warning("R does not recognize your metadata object as either a data frame or tibble. There may be unexpected downstream issues. It is recommended you convert your metadata object to a data frame or a tibble before proceeding. E.g., try as.data.frame() or tibble::as_tibble() and check if your data still looks as expected.")
  }}

checkMeta2 <- function(df, ids = "SampleID"){

  if(!ids%in% colnames(df)) {
    stop(sprintf("You indicated the variable to use for the sample IDs was %s. However, this was not found as a column name in your metadata file.", ids))
  }
}

checkMeta3 <- function(df, ids = "SampleID"){
  dups <- df[duplicated(df[[ids]]),][ids]
  dups <- paste0(dups[[ids]], collapse=", ")
  if(length(unique(df[[ids]])) != nrow(df)) {
    stop(sprintf("You indicated the variable to use for the sample IDs was %s. However, these are not all unique. All sample IDs must be unique. Your duplicated sample IDs were: %s.", ids, dups))
  }
}

checkMeta4 <- function(df, ids = "SampleID"){
  if(sum(!stats::complete.cases(df)) > 0) {
    warning(sprintf("As least 1 NA or empty cell was detected in %s sample(s) in your metadata object. This is not necessarily bad or wrong, but if you were not expecting this, check your metadata object again. Sample(s) %s were detected to have NAs or empty cells.", sum(!stats::complete.cases(df)), paste0(df[!stats::complete.cases(df),][[ids]], collapse=", ")))
  }
}

checkMeta <- function(df, ids = "SampleID") {
 out1 <- checkMeta1(df, ids)
 out2 <- checkMeta2(df, ids)
 out3 <- checkMeta3(df, ids)
 out4 <- checkMeta4(df, ids)

 if(is.null(out1) & is.null(out2) & is.null(out3) & is.null(out4)){
   message("No warnings or errors detected.")
 }

}
