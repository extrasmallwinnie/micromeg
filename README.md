
<!-- README.md is generated from README.Rmd. Please edit that file -->

# micromeg

<!-- badges: start -->

<!-- badges: end -->

The goal of micromeg is to document and share convenience functions I
personally use frequently for microbiome data analysis and processing.
This package does not create anything new and is built on the great work
of others. Many of the functions it provides already exist in other
packages. For example,
[phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)
provides many tools for analysis of microbiome data; it is very
well-documented, heavily used (I use it myself!) and so may be better
for your purposes.

Other R packages heavily used here include:  
1. [tidyverse](https://tidyverse.tidyverse.org) ecosystem  
2. [vegan](https://cran.r-project.org/web/packages/vegan/index.html) 3.
[dada2](https://benjjneb.github.io/dada2/) 4.
[maaslin3](https://huttenhower.sph.harvard.edu/maaslin3/)

## Installation

You can install the development version of micromeg from
[GitHub](https://github.com/extrasmallwinnie/micromeg/) with:

``` r
# install.packages("pak")
pak::pak("extrasmallwinnie/micromeg")
```

## Example

Basic usage:

``` r
library(micromeg)

## Check your metadata file for potential errors and problems with checkMeta():

# Start with a toy example:
dplyr::band_members
#> # A tibble: 3 × 2
#>   name  band   
#>   <chr> <chr>  
#> 1 Mick  Stones 
#> 2 John  Beatles
#> 3 Paul  Beatles

# If we run checkMeta, and we're going to use column "name" as our "Sample ID", we should 
# get no warnings or errors as every name is unique:
checkMeta(dplyr::band_members, "name")
#> No problems were detected with your metadata file.

# However, if we were to use "band" as our "Sample ID", we would get an error because not every entry in band is unique, so it can't function as a valid sample ID:
#checkMeta(dplyr::band_members, "band")
# Error in tryCatchList(expr, classes, parentenv, handlers) : 
#  You indicated the variable to use for the sample IDs was band. However, these are not all unique. All sample IDs # must be unique. Your duplicated sample IDs were: Beatles
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
