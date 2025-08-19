makeBadExample <- function(...){

  if(...=="meta" | ...=="metadata"){
    meta <- makeExampleMeta()
    metaNoSampleID <- meta %>% rename(ID=SampleID)
    return(metaNoSampleID)
  }

  temp <- makeExample(...)
  return(temp)
}

makeBadExampleMeta <- function(operation) {
  result <- switch(operation,
                   "ids" = makeExampleMeta() %>% rename(ID=SampleID), # rename SampleID column
                   "dups" = makeExampleMeta() %>% mutate(SampleID = replace(SampleID, SampleID == "HC2", "HC1")), # create a duplicated value in SampleID column
                   "default" = "Invalid operation")
  return(result)
}

makeBadExampleASV <- function(operation, x) {
  result <- switch(operation,
                   "ids" = makeExampleMeta() %>% rename(ID=SampleID), # rename SampleID column
                   "dups" = makeExampleMeta() %>% mutate(SampleID = replace(SampleID, SampleID == "HC2", "HC1")), # create a duplicated value in SampleID column
                   "default" = "Invalid operation")
  return(result)
}
