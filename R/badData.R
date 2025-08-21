#' Example ASV count table that will give warnings on sanity check
#'
#' Made up ASV count table
#'
#'
#' @format ## `badasv1`
#' A data frame with 12 rows and 10 columns:
#' \describe{
#'   \item{ID}{Sample ID}
#'
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV count table style but with a non-standard SampleID column
"badasv1"
#' Example ASV count table that will give warnings on sanity check
#'
#' Made up ASV count table with two ASVs deleted
#'
#'
#' @format ## `badasv2`
#' A data frame with 12 rows and 8 columns:
#' \describe{
#'   \item{SampleID}{Sample ID}
#'
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV count table style but with two ASVs deleted
"badasv2"
#' Example ASV count table that will give warnings on sanity check
#'
#' Made up ASV count table with one ASV name deliberately messed up
#'
#'
#' @format ## `badasv3`
#' A data frame with 12 rows and 10 columns:
#' \describe{
#'   \item{SampleID}{Sample ID}
#'
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV count table style but with one of the ASV names messed up
"badasv3"
#' Example metadata with different SampleIDs
#'
#' Made up metadata object with the wrong Sample IDs
#'
#'
#' @format ## `badmetadata1`
#' A data frame with 12 rows and 6 columns:
#' \describe{
#'   \item{SampleID}{Sample ID}
#'   \item{SampleType}{Sample Type}
#'   \item{HealthStatus, Age, Sex, Location}{demographic data on participants}
#'
#'
#'   ...
#' }
#' @source made up data following typical dada2 ASV count table style but with one of the ASV names messed up
"badmetadata1"
