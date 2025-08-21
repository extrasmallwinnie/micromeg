#' Example metadata object
#'
#' Made up demographic, clinical, and lab data on samples
#'
#'
#' @format ## `exampleMetadata`
#' A data frame with 12 rows and 6 columns:
#' \describe{
#'   \item{SampleType}{Sample Type}
#'   \item{HealthStatus, Age, Sex, Location}{demographic data on participants}
#'
#'   ...
#' }
#' @source made up data based on common study design
"exampleMetadata"
#' Example ASV count table object
#'
#' Made up ASV count table
#'
#'
#' @format ## `exampleASVtable`
#' A data frame with 12 rows and 10 columns:
#' \describe{
#'   \item{SampleID}{Sample ID}
#'
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV count table style
"exampleASVtable"
#' Example ASV taxonomy table
#'
#' Made up ASV taxonomy table
#'
#'
#' @format ## `exampleTaxa`
#' A data frame with 9 rows and 8 columns:
#' \describe{
#'   \item{ASV}{ASV name/sequence}
#'   \item{Kingdom, Phylum, Class, Order, Family, Genus, Species}{taxonomic classification at each level}
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV taxonomy table style
"exampleTaxa"
#' List of all three example objects in one package
#'
#' Made up metadata, ASV count, and ASV taxonomy tables
#'
#'
#' @format ## `exampleData`
#' A list with of three tibbles:
#' \describe{
#'   \item{exampleMetadata}{Example metadata tibble}
#'   \item{exampleASVtable}{Example ASV count table}
#'   \item{exampleTaxa}{Example ASV taxonomy table}
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV count and taxonomy table style
"exampleData"
