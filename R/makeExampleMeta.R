#' Creats a simple metadata table
#'
#' @returns Simple metadata table for testing and demonstration.
#' @export
#'
#' @examples
#' metadata <- makeExampleMeta()
makeExampleMeta <- function() {
  tibble::tibble(
    SampleID = c("HC1", "HC2", "HC3", "Sick1", "Sick2", "Sick3", "Sick4", "ExtNegControl1", "ExtNegControl2", "PCRNegControl1", "PCRNegControl2", "PosControl1"),
    SampleType = c("nasal swab", "nasal swab", "nasal swab", "nasal swab", "nasal swab", "nasal swab", "nasal swab", "negative control", "negative control", "negative control", "negative control", "positive control"),
    HealthStatus = c("healthy", "healthy", "healthy", "sick", "sick", "sick", "sick", NA, NA, NA, NA, NA),
    Age = c(48, 32, 24, 42, 50, 45, 40, NA, NA, NA, NA, NA),
    Sex = c("female", "male", "female", "male", "male", "male", "female", NA, NA, NA, NA, NA),
    Location = c(NA, "urban", "urban", "rural", "urban", "rural", "urban", NA, NA, NA, NA, NA)
  )
}
