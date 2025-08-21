test_that("Samples with < minDepth filtered out", {
  asvtable <- tibble::tibble(
    X = c("Sample1", "Sample2", "Sample3"),
    ASV1 = c(1, 1, 1),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  asvtableout <- tibble::tibble(
    SampleID = c("Sample2", "Sample3"),
    ASV1 = c(1, 1),
    ASV2 = c(2, 3),
    ASV3 = c(5, 6)
  )

  expect_equal(filtering(asvtable, 7, 2), asvtableout)
})

test_that("Nothing filtered out if all over minDepth and minASVCount", {
  asvtable <- tibble::tibble(
    X = c("Sample1", "Sample2", "Sample3"),
    ASV1 = c(1, 1, 1),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  asvtableout <- tibble::tibble(
    SampleID = c("Sample1", "Sample2", "Sample3"),
    ASV1 = c(1, 1, 1),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  expect_equal(filtering(asvtable, 1, 1), asvtableout)
})

test_that("ASVs under count filtered out", {
  asvtable <- tibble::tibble(
    X = c("Sample1", "Sample2", "Sample3"),
    ASV1 = c(1, 1, 1),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  asvtableout <- tibble::tibble(
    SampleID = c("Sample1", "Sample2", "Sample3"),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  expect_equal(filtering(asvtable, 1, 4), asvtableout)
})

test_that("Get warning if minimum read count seems too aggressive", {
  asvtable <- tibble::tibble(
    X = c("Sample1", "Sample2", "Sample3"),
    ASV1 = c(1, 1, 1),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  expect_warning(filtering(asvtable, 10000, 1))
})

test_that("Get warning if minimum ASV count seems too aggressive", {
  asvtable <- tibble::tibble(
    X = c("Sample1", "Sample2", "Sample3"),
    ASV1 = c(1, 1, 1),
    ASV2 = c(1, 2, 3),
    ASV3 = c(4, 5, 6)
  )
  expect_warning(filtering(asvtable, 1, 10000))
})
