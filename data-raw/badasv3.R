## code to prepare `badasv3` dataset goes here

badasv3 <- makeBadExampleASV("rename")

usethis::use_data(badasv3, overwrite = TRUE)
