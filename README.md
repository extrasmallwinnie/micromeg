
<!-- README.md is generated from README.Rmd. Please edit that file -->

# micromeg

<!-- badges: start -->

<!-- badges: end -->

The goal of micromeg is to document and share convenience functions I
use frequently for microbiome data analysis and processing. This package
does not create anything new and is built on the great work of others.
Many of the functions it provides already exist in other packages. For
example,
[phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)
provides many similar tools, and is very well-documented and commonly
used (I use it myself!) and so may be better for your purposes.

Other R packages heavily used here include:  
1. [tidyverse](https://tidyverse.tidyverse.org) ecosystem  
2. [vegan](https://cran.r-project.org/web/packages/vegan/index.html)  
3. [dada2](https://benjjneb.github.io/dada2/)  
4. [maaslin3](https://huttenhower.sph.harvard.edu/maaslin3/)

I started my career in microbiome research at the bench and essentially
had to [ELI5](https://www.dictionary.com/e/slang/eli5/) to myself how to
process and analyze “big data”. I’ve spent a ton of time poring over and
experimenting with [others’
code](https://github.com/extrasmallwinnie/micromeg/?tab=readme-ov-file#acknowledgements).
Likely, the ideal candidate to benefit from micromeg would be another
bench scientist without much formal statistics or bioinformatics
training. Fair warning, if you already have a strong stats/informatics
background, this may not be of much use for you!

## Installation

You can install the development version of micromeg from
[GitHub](https://github.com/extrasmallwinnie/micromeg/) with:

``` r
# install.packages("pak")
pak::pak("extrasmallwinnie/micromeg")
```

## Common Workflow

I’ve listed the steps that I usually take with 16S data, some of which
will be demonstrated below with some made up data.

1.  Do the lab work to extract DNA, make libraries, submit for
    sequencing, etc. Both positive and negative controls are very
    important! Why?  
2.  Get your data from your sequencing core.  
3.  Process the data through [dada2](https://benjjneb.github.io/dada2/)
    then
    [decomtam](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html)
    to generate a cleaned [ASV (amplicon sequencing variant) table and a
    taxonomy table](https://www.nature.com/articles/nmeth.3869).  
4.  Make a “metadata” file with pertinent information on the samples and
    controls in your run. [Jump to example
    →](https://github.com/extrasmallwinnie/micromeg/?tab=readme-ov-file#metadata)
5.  Check the quality of the pool by examining your positive and
    negative controls, and how they compare to your samples.  
6.  TBA.

## Toy Example

First, load in a very simple example to get an idea for the format of
what’s expected and the general processing flow.

### Load in example data

I’ve made up an example study where nasal swabs were taken from people
who were either “healthy” or “sick” at the time of sampling. We’ve
collected their health status, their age at collection, sex, and simple
location (rural or urban). There is also one lab negative control and
one lab positive control.

#### Metadata

Let’s load the example metadata object into our session as an object
called “metadata”:

``` r
library(micromeg)

metadata <- makeExampleMeta()

metadata
#> # A tibble: 9 × 6
#>   SampleID    SampleType       HealthStatus   Age Sex    Location
#>   <chr>       <chr>            <chr>        <dbl> <chr>  <chr>   
#> 1 HC1         nasal swab       healthy         48 female <NA>    
#> 2 HC2         nasal swab       healthy         32 male   urban   
#> 3 HC3         nasal swab       healthy         24 female urban   
#> 4 Sick1       nasal swab       sick            42 male   rural   
#> 5 Sick2       nasal swab       sick            50 male   urban   
#> 6 Sick3       nasal swab       sick            45 male   rural   
#> 7 Sick4       nasal swab       sick            40 female urban   
#> 8 NegControl1 negative control <NA>            NA <NA>   <NA>    
#> 9 PosControl1 positive control <NA>            NA <NA>   <NA>
```

This metadata object is a tibble (because I personally like the
[tidyverse grammar](https://www.tmwr.org/tidyverse)), but data frames
should also be fine to use. If you use my tools, everything will end up
getting `~`tibblefied`~` anyway.

The “SampleID” field hasn’t been discussed yet, but it’s exactly what it
sounds like! It must be unique, and it must match what you’ve called
your samples in your sequencing data.

You may also notice that there’s some missing data (the NAs), which
we’ll talk about more later.

#### ASV count and taxonomy tables

In this made up toy example, we did 16S sequencing targeting the V4
region (following [the Kozich et al. 2013
protocol](https://journals.asm.org/doi/10.1128/aem.01043-13)) on these
nasal swabs, then processed the sequencing data through
[dada2](https://benjjneb.github.io/dada2/). The output we get from dada2
is:

1.  An [ASV (amplicon sequencing variant) count
    table](https://benjjneb.github.io/dada2/) and  
2.  Its associated taxonomy table.

Next, let’s load in the example ASV count table. (N.B.: The data doesn’t
necessarily strictly have to be an ASV table. Any sort of data in
tabular format, e.g., OTU table, similar to the example **should**
work.)

``` r
asvtable <- makeExampleSeqtab()

asvtable
#> # A tibble: 9 × 10
#>   SampleID  TACGGAGGGTGCGAGCGTTA…¹ TACGGAAGGTCCAGGCGTTA…² TACGTAGGTGGCAAGCGTTA…³
#>   <chr>                      <dbl>                  <dbl>                  <dbl>
#> 1 HC1                         1856                  11652                  13681
#> 2 HC2                        25732                   4775                   2902
#> 3 HC3                         3385                   6760                   6184
#> 4 Sick1                      29939                  26217                  18965
#> 5 Sick2                      29954                  16142                   9656
#> 6 Sick3                      29724                   2771                  26380
#> 7 Sick4                          1                      2                      0
#> 8 NegContr…                      1                      1                      0
#> 9 PosContr…                  10000                  10000                  10000
#> # ℹ abbreviated names:
#> #   ¹​TACGGAGGGTGCGAGCGTTAATCGGAATAACTGGGCGTAAAGGGCACGCAGGCGGTTATTTAAGTGAGGTGTGAAAGCCCTGGGCTTAACCTAGGAATTGCATTTCAGACTGGGTAACTAGAGTACTTTAGGGAGGGGTAGAATTCCACGTGTAGCGGTGAAATGCGTAGAGATGTGGAGGAATACCGAAGGCGAAGGCAGCCCCTTGGGAATGTACTGACGCTCATGTGCGAAAGCGTGGGGAGCAAACAGG,
#> #   ²​TACGGAAGGTCCAGGCGTTATCCGGATTTATTGGGTTTAAAGGGAGCGTAGGCTGGAGATTAAGTGTGTTGTGAAATGTAGACGCTCAACGTCTGAATTGCAGCGCATACTGGTTTCCTTGAGTACGCACAACGTTGGCGGAATTCGTCGTGTAGCGGTGAAATGCTTAGATATGACGAAGAACTCCGATTGCGAAGGCAGCTGACGGGAGCGCAACTGACGCTTAAGCTCGAAGGTGCGGGTATCAAACAGG,
#> #   ³​TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG
#> # ℹ 6 more variables:
#> #   TACGGAGGGTGCGAGCGTTAATCGGAATAACTGGGCGTAAAGGGCACGCAGGCGGTTATTTAAGTGAGGTGTGAAAGCCCCGGGCTTAACCTGGGAATTGCATTTCAGACTGGGTAACTAGAGTACTTTAGGGAGGGGTAGAATTCCACGTGTAGCGGTGAAATGCGTAGAGATGTGGAGGAATACCGAAGGCGAAGGCAGCCCCTTGGGAATGTACTGACGCTCATGTGCGAAAGCGTGGGGAGCAAACAGG <dbl>,
#> #   TACGTAGGTCCCGAGCGTTGTCCGGATTTATTGGGCGTAAAGCGAGCGCAGGCGGTTAGATAAGTCTGAAGTTAAAGGCTGTGGCTTAACCATAGTAGGCTTTGGAAACTGTTTAACTTGAGTGCAAGAGGGGAGAGTGGAATTCCATGTGTAGCGGTGAAATGCGTAGATATATGGAGGAACACCGGTGGCGAAAGCGGCTCTCTGGCTTGTAACTGACGCTGAGGCTCGAAAGCGTGGGGAGCAAACAGG <dbl>, …
```

Finally, let’s load in the example taxonomy file. This was generated
during the dada2 workflow, and must match the ASV table.

``` r

taxa <- makeExampleTaxa()

taxa
#> # A tibble: 9 × 8
#>   ASV                            Kingdom Phylum Class Order Family Genus Species
#>   <chr>                          <chr>   <chr>  <chr> <chr> <chr>  <chr> <chr>  
#> 1 TACGGAGGGTGCGAGCGTTAATCGGAATA… Bacter… Prote… Gamm… Past… Paste… Haem… <NA>   
#> 2 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Prev… melani…
#> 3 TACGTAGGTGGCAAGCGTTATCCGGAATT… Bacter… Firmi… Baci… Stap… Staph… Stap… <NA>   
#> 4 TACGGAGGGTGCGAGCGTTAATCGGAATA… Bacter… Prote… Gamm… Past… Paste… Haem… <NA>   
#> 5 TACGTAGGTCCCGAGCGTTGTCCGGATTT… Bacter… Firmi… Baci… Lact… Strep… Stre… <NA>   
#> 6 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Allo… rava   
#> 7 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Allo… <NA>   
#> 8 TACGAAGGGTGCAAGCGTTACTCGGAATT… Bacter… Prote… Gamm… Xant… Xanth… Sten… <NA>   
#> 9 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Allo… <NA>
```

BTW, the function makeExample() also exists for your convenience and
will call upon any of the above, like so:

``` r

metadata <- makeExample("meta")
asvtable <- makeExample("asv")
taxa     <- makeExample("taxa")
```

You can be even more lazy and make all three example tibbles (metadata,
ASV table, and its taxonomy table) at once:

``` r

all <- makeExample()

# OR

all <- makeExample("all")

all
#> $metadata
#> # A tibble: 9 × 6
#>   SampleID    SampleType       HealthStatus   Age Sex    Location
#>   <chr>       <chr>            <chr>        <dbl> <chr>  <chr>   
#> 1 HC1         nasal swab       healthy         48 female <NA>    
#> 2 HC2         nasal swab       healthy         32 male   urban   
#> 3 HC3         nasal swab       healthy         24 female urban   
#> 4 Sick1       nasal swab       sick            42 male   rural   
#> 5 Sick2       nasal swab       sick            50 male   urban   
#> 6 Sick3       nasal swab       sick            45 male   rural   
#> 7 Sick4       nasal swab       sick            40 female urban   
#> 8 NegControl1 negative control <NA>            NA <NA>   <NA>    
#> 9 PosControl1 positive control <NA>            NA <NA>   <NA>    
#> 
#> $asvtable
#> # A tibble: 9 × 10
#>   SampleID  TACGGAGGGTGCGAGCGTTA…¹ TACGGAAGGTCCAGGCGTTA…² TACGTAGGTGGCAAGCGTTA…³
#>   <chr>                      <dbl>                  <dbl>                  <dbl>
#> 1 HC1                         1856                  11652                  13681
#> 2 HC2                        25732                   4775                   2902
#> 3 HC3                         3385                   6760                   6184
#> 4 Sick1                      29939                  26217                  18965
#> 5 Sick2                      29954                  16142                   9656
#> 6 Sick3                      29724                   2771                  26380
#> 7 Sick4                          1                      2                      0
#> 8 NegContr…                      1                      1                      0
#> 9 PosContr…                  10000                  10000                  10000
#> # ℹ abbreviated names:
#> #   ¹​TACGGAGGGTGCGAGCGTTAATCGGAATAACTGGGCGTAAAGGGCACGCAGGCGGTTATTTAAGTGAGGTGTGAAAGCCCTGGGCTTAACCTAGGAATTGCATTTCAGACTGGGTAACTAGAGTACTTTAGGGAGGGGTAGAATTCCACGTGTAGCGGTGAAATGCGTAGAGATGTGGAGGAATACCGAAGGCGAAGGCAGCCCCTTGGGAATGTACTGACGCTCATGTGCGAAAGCGTGGGGAGCAAACAGG,
#> #   ²​TACGGAAGGTCCAGGCGTTATCCGGATTTATTGGGTTTAAAGGGAGCGTAGGCTGGAGATTAAGTGTGTTGTGAAATGTAGACGCTCAACGTCTGAATTGCAGCGCATACTGGTTTCCTTGAGTACGCACAACGTTGGCGGAATTCGTCGTGTAGCGGTGAAATGCTTAGATATGACGAAGAACTCCGATTGCGAAGGCAGCTGACGGGAGCGCAACTGACGCTTAAGCTCGAAGGTGCGGGTATCAAACAGG,
#> #   ³​TACGTAGGTGGCAAGCGTTATCCGGAATTATTGGGCGTAAAGCGCGCGTAGGCGGTTTTTTAAGTCTGATGTGAAAGCCCACGGCTCAACCGTGGAGGGTCATTGGAAACTGGAAAACTTGAGTGCAGAAGAGGAAAGTGGAATTCCATGTGTAGCGGTGAAATGCGCAGAGATATGGAGGAACACCAGTGGCGAAGGCGACTTTCTGGTCTGTAACTGACGCTGATGTGCGAAAGCGTGGGGATCAAACAGG
#> # ℹ 6 more variables:
#> #   TACGGAGGGTGCGAGCGTTAATCGGAATAACTGGGCGTAAAGGGCACGCAGGCGGTTATTTAAGTGAGGTGTGAAAGCCCCGGGCTTAACCTGGGAATTGCATTTCAGACTGGGTAACTAGAGTACTTTAGGGAGGGGTAGAATTCCACGTGTAGCGGTGAAATGCGTAGAGATGTGGAGGAATACCGAAGGCGAAGGCAGCCCCTTGGGAATGTACTGACGCTCATGTGCGAAAGCGTGGGGAGCAAACAGG <dbl>,
#> #   TACGTAGGTCCCGAGCGTTGTCCGGATTTATTGGGCGTAAAGCGAGCGCAGGCGGTTAGATAAGTCTGAAGTTAAAGGCTGTGGCTTAACCATAGTAGGCTTTGGAAACTGTTTAACTTGAGTGCAAGAGGGGAGAGTGGAATTCCATGTGTAGCGGTGAAATGCGTAGATATATGGAGGAACACCGGTGGCGAAAGCGGCTCTCTGGCTTGTAACTGACGCTGAGGCTCGAAAGCGTGGGGAGCAAACAGG <dbl>, …
#> 
#> $taxa
#> # A tibble: 9 × 8
#>   ASV                            Kingdom Phylum Class Order Family Genus Species
#>   <chr>                          <chr>   <chr>  <chr> <chr> <chr>  <chr> <chr>  
#> 1 TACGGAGGGTGCGAGCGTTAATCGGAATA… Bacter… Prote… Gamm… Past… Paste… Haem… <NA>   
#> 2 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Prev… melani…
#> 3 TACGTAGGTGGCAAGCGTTATCCGGAATT… Bacter… Firmi… Baci… Stap… Staph… Stap… <NA>   
#> 4 TACGGAGGGTGCGAGCGTTAATCGGAATA… Bacter… Prote… Gamm… Past… Paste… Haem… <NA>   
#> 5 TACGTAGGTCCCGAGCGTTGTCCGGATTT… Bacter… Firmi… Baci… Lact… Strep… Stre… <NA>   
#> 6 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Allo… rava   
#> 7 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Allo… <NA>   
#> 8 TACGAAGGGTGCAAGCGTTACTCGGAATT… Bacter… Prote… Gamm… Xant… Xanth… Sten… <NA>   
#> 9 TACGGAAGGTCCAGGCGTTATCCGGATTT… Bacter… Bacte… Bact… Bact… Prevo… Allo… <NA>

# Object "all" is a list, so, for example you can access (and assign, if you want) each tibble with the $ operator:

metadata <- all$metadata
asvtable <- all$asvtable
taxa     <- all$taxa
```

### Check data for potential issues.

Now that we’ve loaded in our metadata file, we can check it:

``` r

checkMeta(metadata)
#> Warning in checkMeta4(df, ids): As least 1 NA or empty cell was detected in 3
#> sample(s) in your metadata object. This is not necessarily bad or wrong, but if
#> you were not expecting this, check your metadata object again. Sample(s) HC1,
#> NegControl1, PosControl1 were detected to have NAs or empty cells.
```

You’ll see there’s a warning that NAs were detected in the metadata
table. This is not bad or wrong, and it’s OK to have NAs! The warning is
there to check with you that you were expecting to see some missing
data. If you weren’t, check that your metadata object was loaded in
correctly.

In this case, there are NAs in a few spots:

1.  Demographic data is missing for the lab positive and negative
    controls, as that kind of information not relevant for those
    samples.  
2.  Location is missing for the participant that sample “HC1” was taken
    from. Let’s say that the participant declined to share their
    location, so that’s why it’s missing from our data. With real life
    data, it’s pretty normal to have some information missing.

This is all fine and there are no glaring red flags with our metadata
object.

(Why are negative controls so important? See
<https://pubmed.ncbi.nlm.nih.gov/25387460/>,
<https://pubmed.ncbi.nlm.nih.gov/27239228/>,
<https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-020-01839-y>)

OK, now let’s check that our ASV and taxonomy tables:

``` r

checkASV(asvtable, taxa, metadata)
```

------------------------------------------------------------------------

# Acknowledgements

As mentioned above, I could not have created this without the benefit of
what others have already created. These tools below were especially
important:

- [mothur](https://mothur.org)  
- [qiime](https://qiime2.org)  
- [mgsat](https://github.com/andreyto/mgsat)  
- maaslin[2](https://huttenhower.sph.harvard.edu/maaslin/)/[3](https://huttenhower.sph.harvard.edu/maaslin3/)  
- [vegan](https://cran.r-project.org/web/packages/vegan/index.html)
- [tidyverse](https://tidyverse.tidyverse.org), especially
  [dplyr](https://dplyr.tidyverse.org) and
  [ggplot2](https://ggplot2.tidyverse.org)
- [dada2 and decontam](https://callahanlab.cvm.ncsu.edu/software/)
- [Suite from Dr. Frank Harrell](https://hbiostat.org), especially
  [rms](https://cran.r-project.org/web/packages/rms/index.html) and
  [Hmisc](https://cran.r-project.org/web/packages/Hmisc/index.html).

More acknowledgements and more details to be added later
