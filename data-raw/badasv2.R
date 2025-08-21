## code to prepare `badasv2` dataset goes here

badasv2 <- makeBadExampleASV("remove")

usethis::use_data(badasv2, overwrite = TRUE)
