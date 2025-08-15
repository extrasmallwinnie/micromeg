test_that("Samples with < minDepth filtered out", {
  asvtable <- data.frame(X=c("Sample1", "Sample2", "Sample3"),
                         ASV1=c(1, 1, 1),
                         ASV2=c(1, 2, 3),
                         ASV3=c(4, 5, 6))
  asvtableout <- data.frame(SampleID=c("Sample2", "Sample3"),
                            ASV1=c(1, 1),
                            ASV2=c(2, 3),
                            ASV3=c(5, 6))

  expect_equal(filtering(asvtable, 7, 2), tibble::as_tibble(asvtableout))
})
