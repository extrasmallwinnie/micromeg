
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
2. [vegan](https://cran.r-project.org/web/packages/vegan/index.html)  
3. [dada2](https://benjjneb.github.io/dada2/)  
4. [maaslin3](https://huttenhower.sph.harvard.edu/maaslin3/)

## Installation

You can install the development version of micromeg from
[GitHub](https://github.com/extrasmallwinnie/micromeg/) with:

``` r
# install.packages("pak")
pak::pak("extrasmallwinnie/micromeg")
```

## Example

First, load in some example data to get an idea for the format of what’s
expected.

I’ve made up an example study where nasal swabs were taken from people
who were either “healthy” or “sick” at the time of sampling. We’ve
collected their health status, their age at collection, sex, and
location (rural or urban). Let’s load it into our session as an object
called “metadata”:

``` r
library(micromeg)

metadata <- makeExampleMeta()

metadata
#> # A tibble: 7 × 5
#>   SampleID HealthStatus   Age Sex    Location
#>   <chr>    <chr>        <dbl> <chr>  <chr>   
#> 1 HC1      healthy         48 female <NA>    
#> 2 HC2      healthy         32 male   urban   
#> 3 HC3      healthy         24 female urban   
#> 4 Sick1    sick            42 male   rural   
#> 5 Sick2    sick            50 male   urban   
#> 6 Sick3    sick            45 male   rural   
#> 7 Sick4    sick            40 female urban
```

This metadata object is a tibble (because I personally like the
[tidyverse grammar](https://www.tmwr.org/tidyverse)), but data frames
should also be fine to use.

The “SampleID” field hasn’t been discussed yet, but it’s exactly what it
sounds like, and it must be unique, and it must match your sequencing
data.

In this made up example, we did 16S sequencing targeting the V4 region
(following [this
protocol](https://journals.asm.org/doi/10.1128/aem.01043-13)) on these
nasal swabs, then processed the specimens through the
[dada2](https://benjjneb.github.io/dada2/) pipeline. The output we get
from dada2 is:

1.  An [ASV (amplicon sequencing variant)
    table](https://benjjneb.github.io/dada2/).  
2.  Its associated taxonomy table.

Next, let’s load in the example [ASV
table](https://benjjneb.github.io/dada2/). (N.B.: Any sort of data in
tabular format similar to the sample **should** work, but no
guarantees.)

``` r
asvtable <- makeExampleSeqtab()

asvtable
#> # A tibble: 7 × 10
#>   SampleID  ASV1  ASV2  ASV3  ASV4  ASV5  ASV6  ASV7  ASV8  ASV9
#>   <chr>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 HC1       1856 11652 13681  2994  9111  3995 10821  3937     4
#> 2 HC2      25732  4775  2902  1628  1061 13536  6216  4089     6
#> 3 HC3       3385  6760  6184   569  7081  8358  8780  2907     8
#> 4 Sick1    29939 26217 18965  4483  3018   217  1599 12441     6
#> 5 Sick2    29954 16142  9656  9373  3221  9506  4237   294     6
#> 6 Sick3    29724  2771 26380  7803  8003  8157 13010  8469     7
#> 7 Sick4        1     2     0     5     1     0     0     0     1
```

Finally, let’s load in the example taxonomy file. This was generated
during the dada2 workflow, and must match the ASV table.

``` r

taxa <- makeExampleTaxa()

taxa
#> # A tibble: 9 × 8
#>   ASV   Kingdom  Phylum         Class               Order   Family Genus Species
#>   <chr> <chr>    <chr>          <chr>               <chr>   <chr>  <chr> <chr>  
#> 1 ASV1  Bacteria Proteobacteria Gammaproteobacteria Pasteu… Paste… Haem… <NA>   
#> 2 ASV2  Bacteria Bacteroidota   Bacteroidia         Bacter… Prevo… Prev… melani…
#> 3 ASV3  Bacteria Firmicutes     Bacilli             Staphy… Staph… Stap… <NA>   
#> 4 ASV4  Bacteria Proteobacteria Gammaproteobacteria Pasteu… Paste… Haem… <NA>   
#> 5 ASV5  Bacteria Firmicutes     Bacilli             Lactob… Strep… Stre… <NA>   
#> 6 ASV6  Bacteria Bacteroidota   Bacteroidia         Bacter… Prevo… Allo… rava   
#> 7 ASV7  Bacteria Bacteroidota   Bacteroidia         Bacter… Prevo… Allo… <NA>   
#> 8 ASV8  Bacteria Proteobacteria Gammaproteobacteria Xantho… Xanth… Sten… <NA>   
#> 9 ASV9  Bacteria Bacteroidota   Bacteroidia         Bacter… Prevo… Allo… <NA>
```
