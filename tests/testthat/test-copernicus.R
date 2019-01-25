library("suppdata")
library("testthat")

context("Copernicus")

test_that("Copernicus works (zipfile is automatically extracted)", {
  cop_unzipped_files <- suppdata("10.5194/bg-14-1739-2017", si = 1)
  expect_true(dir.exists(cop_unzipped_files))
  expect_length(list.files(cop_unzipped_files), 8)
})

test_that("Copernicus works if SI is single PDF", {
  cop_pdf_file <- suppdata("10.5194/acp-2016-189", si = 1)
  expect_true(file.exists(cop_pdf_file))
  expect_equal(attr(cop_pdf_file, which = "suffix"), "pdf")
})

test_that("Disabling unzip for Copernicus SI works", {
  skip_on_cran()
  cop_zipfile_only <- suppdata("10.5194/bg-14-1739-2017", si = "bg-14-1739-2017-supplement.zip")
  expect_true(file.exists(cop_zipfile_only))
  expect_false(dir.exists(cop_zipfile_only))
})

test_that("User-defined target directory for Copernicus works", {
  skip_on_cran()
  cop_unzip_dir <- suppdata("10.5194/bg-14-1739-2017", si = 1, save.name = "target-directory")
  expect_true(file.exists(file.path(cop_unzip_dir, "bg-14-1739-2017-supplement-title-page.pdf")))
  expect_match(cop_unzip_dir, "/target-directory$")
})

test_that("Accessing specific SI from Copernicus gives expected file contents", {
  skip_on_cran()
  csv_file <- suppdata("10.5194/bg-14-1739-2017", si = "Table S1 v2 UFK FOR_PUBLICATION.csv")
  expect_true(file.exists(csv_file))
  csv_data <- read.csv(file = csv_file, skip = 3)
  expect_equal(names(csv_data)[2:3], c("YEAR", "NAD83_X"))
})

test_that("User-specific output name for single SI download for Copernicus works", {
  skip_on_cran()
  expect_true(file.exists(
    suppdata("10.5194/bg-14-1739-2017", si = "Table S1 v2 UFK FOR_PUBLICATION.csv", save.name = "data.csv")))
})

test_that("Accessing SI > 1 for Copernicus gives error", {
  skip_on_cran()
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = 2), "one supplemental archive")
})

test_that("Accessing non-existing file for Copernicus gives error (SI identifier)", {
  skip_on_cran()
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = "1"), "file not in zipfile")
})

test_that("Accessing non-existing file for Copernicus gives error (file name)", {
  skip_on_cran()
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = "not a file.csv"), "file not in zipfile")
})