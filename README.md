
<!-- README.md is generated from README.Rmd. Please edit that file -->

# micromeg

<!-- badges: start -->

<!-- badges: end -->

The goal of `micromeg` is to document and share convenience functions I
use frequently for microbiome data analysis and processing. This package
does not create any brand new functionality and was built on the great
work of others. Many of the functions it provides already exist in other
packages. For example,
[phyloseq](https://bioconductor.org/packages/release/bioc/html/phyloseq.html)
provides many similar tools, and is very well-documented and commonly
used (I use it myself!) and so may be better for your purposes.

Other R packages heavily used here include:  
1. [tidyverse](https://tidyverse.tidyverse.org) ecosystem  
2. [vegan](https://cran.r-project.org/web/packages/vegan/index.html)  
3. [dada2](https://benjjneb.github.io/dada2/)  
4. [maaslin3](https://huttenhower.sph.harvard.edu/maaslin3/)

I started my career in microbiome research at the bench and had to
[ELI5](https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExY3hrYzg1a2I2eGtuNWIwYTRqNDMzNGE0cWlkNGE5OXB4ZHV1YXY4dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/WsNbxuFkLi3IuGI9NU/giphy.gif)
to myself how to process and analyze “big data”. I’ve spent a ton of
time poring over and experimenting with [others’
code](https://github.com/extrasmallwinnie/micromeg/?tab=readme-ov-file#acknowledgements).
Likely, the ideal candidate to benefit from `micromeg` would be another
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

## My Usual Workflow

I’ve listed the steps that I usually take with 16S data, some of which
will be demonstrated below with some made up data.

1.  Do the lab work to extract DNA, make libraries, submit for
    sequencing, etc. Both negative and positive controls are very
    important! Why, and what are those? Read more here:
    <sup>[1](https://pubmed.ncbi.nlm.nih.gov/25387460/),</sup>
    <sup>[2](https://pubmed.ncbi.nlm.nih.gov/27239228/),</sup>
    <sup>[3](https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-020-01839-y),</sup>
    <sup>[4](https://bmcmicrobiol.biomedcentral.com/articles/10.1186/s12866-016-0738-z),</sup>
    <sup>[5](https://journals.asm.org/doi/10.1128/msystems.00062-16)</sup>  
2.  Get the data from the sequencing core.  
3.  Process the data through [dada2](https://benjjneb.github.io/dada2/)
    then
    [decomtam](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html)
    to generate a cleaned [ASV (amplicon sequencing variant) count table
    and its associated taxonomy
    table](https://www.nature.com/articles/nmeth.3869).  
4.  Create a “metadata” file with pertinent information on the samples
    and controls in your run. [Go to example
    ↓](https://github.com/extrasmallwinnie/micromeg/?tab=readme-ov-file#metadata)
5.  Do some basic sanity checking on the metadata, ASV, and taxonomy
    objects. [Go to example
    ↓](https://github.com/extrasmallwinnie/micromeg/?tab=readme-ov-file#sanity-check-the-data)  
6.  Check the quality of the sequencing data by examining both the
    positive and negative controls, and additionally how the controls
    compare to your real samples. [Go to example
    ↓](https://github.com/extrasmallwinnie/micromeg?tab=readme-ov-file#quality-check-the-data)  
7.  Alpha diversity (vegan).  
8.  Beta diversity (vegan).  
9.  Differential abundance (maaslin3).

## Toy Example

First, load in a very simple example to get an idea for the format of
what’s expected and the general processing flow.

### Load in example data

I’ve made up an example study where nasal swabs were taken from people
who were either “healthy” or “sick” at the time of sampling. We’ve
collected from each participant their health status, their age at
collection, sex, and a simplified location category (in this case,
‘rural’ or ‘urban’). There was also one lab negative control and one lab
positive control.

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

This metadata object is a tibble (because I personally prefer the
[tidyverse grammar](https://www.tmwr.org/tidyverse)), but data frames
should also be fine to use. If you use my tools, everything will end up
getting ~ tibblefied ~ anyway.

The “SampleID” field wasn’t discussed yet, but it’s exactly what it
sounds like! It must be unique, and it must match what you’ve called
your samples in your sequencing data. (If you use this package, it’s
highly recommended that you call your sample IDs field exactly
“SampleID” in both your metadata and ASV count table objects.)

You may also notice that there’s some missing data (the NAs), which
we’ll talk about more later.

#### ASV count and taxonomy tables

In this made up toy example, we did 16S sequencing targeting the V4
region (following [the Kozich et al. 2013
protocol](https://journals.asm.org/doi/10.1128/aem.01043-13)) on these
nasal swabs, then processed the sequencing data through
[dada2](https://benjjneb.github.io/dada2/). The output we got from dada2
was:

1.  An [ASV (amplicon sequencing variant) count
    table](https://benjjneb.github.io/dada2/) and  
2.  Its associated taxonomy table.

I do have my own wrapper for dada2+decontam. However, rather than using
my exact dada2+decontam workflow, I’d highly recommend instead that you
first follow the tutorials
[for](https://benjjneb.github.io/dada2/tutorial.html)
[each](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html),
as they very nicely describe how to use them and the considerations you
should have for your own data.

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

all <- makeExample() # OR all <- makeExample("all")

str(all, max.level=1)  # if you're really new to R, FYI, str() is an inbuilt R function that displays the STRucture of an R object, and I've set max.level to 1 so it will only display the first nested level (AKA, minimal display here)
#> List of 3
#>  $ metadata: tibble [9 × 6] (S3: tbl_df/tbl/data.frame)
#>  $ asvtable: tibble [9 × 10] (S3: tbl_df/tbl/data.frame)
#>  $ taxa    : tibble [9 × 8] (S3: tbl_df/tbl/data.frame)

# Object "all" is a list, so, you can access (and assign, if you want) each tibble with the $ operator:

metadata <- all$metadata
asvtable <- all$asvtable
taxa     <- all$taxa
```

### Sanity check the data

Now that we’ve loaded in our main objects (metadata, ASV counts, ASV
taxonomy) we will do some basic sanity checks on these three objects.

First, let’s check the metadata object:

``` r

checkMeta(metadata)
#> Warning in checkMeta4(df, ids): As least 1 NA or empty cell was detected in 3
#> sample(s) in your metadata object. This is not necessarily bad or wrong, but if
#> you were not expecting this, check your metadata object again. Sample(s) HC1,
#> NegControl1, PosControl1 were detected to have NAs or empty cells.
```

You’ll see there’s a warning that NAs were detected in the metadata
table. This is not bad or wrong, and it’s OK to have NAs! The warning is
there to check with *you* that *you* were expecting to see some missing
data. If you weren’t, check that your metadata object was loaded in
correctly.

In this case, there are NAs in a few spots:

1.  Demographic data is “missing” for the lab positive and negative
    controls, as that kind of information is not
    applicable/relevant/meaningful for those samples.  
2.  Location is missing from the participant for sample “HC1”. Let’s say
    that this participant declined to share their geographic location,
    so it is indeed truly missing. With real life data, it’s pretty
    normal to have some information missing. People much smarter than I
    am have [written](https://hbiostat.org/rmsc/missing.html)
    [extensively](https://link.springer.com/chapter/10.1007/978-1-4757-3462-1_3)
    [about](https://pubmed.ncbi.nlm.nih.gov/20338724/)
    [missing](https://www.appliedmissingdata.com)
    [data](https://pubmed.ncbi.nlm.nih.gov/17401454/), and how to deal
    with it, so that won’t be discussed much more here.

This is all fine and there are no glaring red flags with our metadata
object.

(checkMeta takes two arguments; the first is your metadata object and
the second is your sample IDs column. It’s set so that ‘SampleID’ is the
default so we didn’t have to explicitly tell the function that. Try
`checkMeta(metadata, "SampleType")` to see another example of a
different type of warning you can get.)

------------------------------------------------------------------------

OK, now let’s also check on the ASV and taxonomy tables:

``` r

checkASV(asvtable, taxa, metadata)
```

Since we didn’t get any warnings from checkASV(), our three objects all
passed my sanity checks. That isn’t super helpful as an example, so
instead, let’s deliberately make some “bad” ASV count tables that will
throw a warning with these checks:

``` r

badasv1 <- makeBadExampleASV("ids") # changes name of 'SampleID' column to 'ID'

badasv1
#> # A tibble: 9 × 10
#>   ID        TACGGAGGGTGCGAGCGTTA…¹ TACGGAAGGTCCAGGCGTTA…² TACGTAGGTGGCAAGCGTTA…³
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

checkASV(badasv1, taxa, metadata)
#> Warning in checkASV(badasv1, taxa, metadata): A column called 'SampleID' wasn't
#> found in your ASV table 'badasv1'. It's recommended to run
#> checkSampleID(badasv1) first.
```

This is the least “bad” warning to get. We got a warning that no column
named “SampleID” was found in the ASV count table. You don’t *have* to
follow this convention, but to use this package, it will make things
much easier if you do.

We got the prompt to run checkSampleID() on badasv1, so let’s do that:

``` r
badasv1_fixed <- checkSampleID(badasv1)
```

This function is interactive, which is hard to demonstrate here, but
this will have popped up on the console:

`A column called 'SampleID' was not detected. What is the column name that you're using as your sample IDs?`

I’ll now type in the name, which was ‘ID’:

`ID`

Now it checks with me that it’s OK to change the name:

`Is it OK to change column name 'ID' to 'SampleID'? y/n:`

Type in `y` to accept the change.

Check that it looks good and we’re no longer getting any warnings:

``` r
badasv1_fixed
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

checkASV(badasv1_fixed, taxa, metadata)
```

Great, we’re all set. You can also use checkSampleID() on the metadata
object; that’s not demonstrated here as it’s the same thing, just with a
different input.

Let’s move on to much more serious problems.

``` r
badasv2 <- makeBadExampleASV("remove") # removes one of the ASVs from the count table

checkASV(badasv2, taxa, metadata)
#> Warning in checkASV(badasv2, taxa, metadata): The number of ASVs in your ASV
#> table doesn't match the number of ASVs in your taxonomy table.
```

In this case, one of the ASVs was removed from the count table, so now
the number of ASVs in the count table doesn’t match the number in the
taxonomy table. If this happens with your data, you’ll need to check
that you’re using the correct data and that nothing happened to corrupt
it. You may need to re-run dada2 (or whatever workflow you used).

Next, a similar example of something that can go wrong:

``` r
badasv3 <- makeBadExampleASV("rename") # replaces the name of one of the ASVs with something else

checkASV(badasv3, taxa, metadata)
#> Warning in checkASV(badasv3, taxa, metadata): The names of your ASVs in your
#> ASV table don't match the names in the taxonomy table.
```

Like the previous example, this represents another mismatch between the
ASV count and taxonomy tables. Again, if this were to happen with your
data, make sure you’re using the correct data and that it’s not messed
up somehow. Re-run the data processing steps if necessary.

Finally, one more example of something that can go wrong is that there’s
no match in the SampleIDs in the metadata and ASV count objects. Maybe
you used a different number of padding zeroes, or got the wrong file
somewhere.

``` r
badmetadata <- makeBadExampleMeta("wrongmeta") # adds a zero to the SampleIDs in the metadata object
checkASV(asvtable, taxa, badmetadata)
#> Warning in checkASV(asvtable, taxa, badmetadata): After merging your metadata
#> and ASV objects, no samples were retained. Check that the SampleIDs match in
#> each object. For example, you may have a non-matching number of padded zeroes.
```

Since R can’t figuere out how to match the samples from the metadata and
ASV objects, you won’t be able to do any actual analysis with your
metadata. This would need to be fixed before moving on. \_\_\_

### Quality check the data

Since we’re done with the basic sanity checks and the original objects
`metadata`, `asvtable`, and `taxa` all looked good, now we can do an
actual more interesting quality check of our data.

As mentioned previously, lab positive and negative controls are VERY
important and should be included at minimum in every single sequencing
run.

#### An aside to pontificate on negative controls

Negative controls are especially important with 16S data due the nature
of the process: 1) bacteria and their DNA are ubiquitous and can live
even in environments hostile to most other life, 2) the PCR protocol
deliberately enriches for all bacteria in a semi-universal way. This
means the data can be extremely susceptible to contamination. The
details of this are out of the scope of this document, but your FIRST
step should be improving your lab methods to reduce contamination
potential as much as possible.

However, no matter how amazing you (or your colleagues) are in the lab,
you’ll probably still have at least some contamination. That’s where the
negative controls come in. I would recommend having at least one
negative extraction control (e.g., extract some ultraclean water or
sample buffer) per every extraction batch, and a PCR negative control
for every PCR master mix batch.

If you’ve processed your data through
[decomtam](https://benjjneb.github.io/decontam/vignettes/decontam_intro.html)
or another such tool, you’ve already bioinformatically removed some
potential contaminants. I’d recommend doing this as part of your
workflow before data analysis.

However, for the first assessment of your negative controls, I recommend
looking at the “raw” data, i.e., BEFORE it goes through `decontam` or
other similar tool.

## Placeholder

This is for me to remember to add to this document:

Add “bad” examples.  
identifyNegs and assessNegs.  
filtering.  
calcBetaDiv.

------------------------------------------------------------------------

# Acknowledgements

As mentioned above, I could not have done any of this without the
benefit of what the work of others. These tools below were especially
important:

- [mothur](https://mothur.org)  
- [qiime](https://qiime2.org)  
- [mgsat](https://github.com/andreyto/mgsat)  
- maaslin[2](https://huttenhower.sph.harvard.edu/maaslin/)/[3](https://huttenhower.sph.harvard.edu/maaslin3/)  
- [vegan](https://cran.r-project.org/web/packages/vegan/index.html)
- [tidyverse](https://tidyverse.tidyverse.org), especially
  [dplyr](https://dplyr.tidyverse.org) and
  [ggplot2](https://ggplot2.tidyverse.org). In addition to these
  packages, Hadley Wickham and team have written several extremely
  helpful [guides and tutorials](https://hadley.nz) on data science.
- [dada2 and decontam](https://callahanlab.cvm.ncsu.edu/software/)
- [Suite from Dr. Frank Harrell](https://hbiostat.org), especially
  [rms](https://cran.r-project.org/web/packages/rms/index.html) and
  [Hmisc](https://cran.r-project.org/web/packages/Hmisc/index.html).
- Colleague and physician-scientist [Dr. Christian
  Rosas-Salazar](https://pediatrics.vumc.org/person/christian-rosas-salazar-md-mph)
  is talented at many things, but has an especial knack for creating
  figures that are both beautiful and informative.

More acknowledgements and more details to be added later
