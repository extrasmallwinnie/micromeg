#' Creats a simple metadata table
#'
#' @returns Simple metadata table for testing and demonstration.
#' @export
#'
#' @examples
#' metadata <- makeExampleMeta()
makeExampleMeta <- function(){
  tibble::tibble(SampleID=c("HC1", "HC2", "HC3", "Sick1", "Sick2", "Sick3", "Sick4"),
                 HealthStatus=c("healthy", "healthy", "healthy", "sick", "sick", "sick", "sick"),
                 Age=c(48, 32, 24, 42, 50, 45, 40),
                 Sex=c("female", "male", "female", "male", "male", "male", "female"),
                 Location=c(NA, "urban", "urban", "rural", "urban", "rural", "urban"))
}
