## code to prepare `exampleTaxa` dataset goes here

exampleTaxa <- makeExample()$taxa

usethis::use_data(exampleTaxa, overwrite = TRUE)
