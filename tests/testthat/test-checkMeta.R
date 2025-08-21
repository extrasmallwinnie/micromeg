test_that("Get a warning if NAs are detected", {
  expect_warning(checkMeta(dplyr::starwars %>% dplyr::select(-c(films, vehicles, starships)), "name"))
})

test_that("Get a warning if your sample IDs are not all unique", {
  expect_warning(checkMeta(dplyr::storms, "name"))
})

test_that("Get a warning if the column name you gave for the sample IDs can't be found", {
  expect_warning(checkMeta(dplyr::storms, "nameee"))
})

test_that("No output if it passes all tests", {
  expect_null(checkMeta(dplyr::band_members, "name"))
})
