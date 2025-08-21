## code to prepare `badmetadata1` dataset goes here

badmetadata1 <- makeBadExampleMeta("wrongmeta")

usethis::use_data(badmetadata1, overwrite = TRUE)
