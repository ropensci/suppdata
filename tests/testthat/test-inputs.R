library("suppdata")
library("testthat")

context("suppdata inputs")

test_that("specifying multiple DOIs works", {
  expect_true(all(file.exists(suppdata(c("10.1101/016386", "10.1111/ele.12437"), si = 1))))
})

test_that("specifying multiple DOIs with vector of SIs works", {
  expect_true(all(file.exists(suppdata(c("10.1101/016386", "10.1111/ele.12437"), si = c(1:2)))))
})

test_that("There is an error on non-existing DOI", {
  skip_on_cran()
  expect_error(expect_warning(suppdata('nonsense', 1), "404"), "nonsense")
})

test_that("There is an error if SI vector is longer than DOI vector", {
  skip_on_cran()
  expect_error(suppdata("10.6084/m9.figshare.979288", si = c(1,2,3)), "length")
})

test_that("There is an error if SI number is too large", {
  skip_on_cran()
  expect_error(suppdata('10.6084/m9.figshare.979288', 20), "greater than number of detected SIs")
})

test_that("There are errors for non-existing SIs", {
  skip_on_cran()
  expect_error(suppdata('10.6084/m9.figshare.979288', "does_exist.csv"))
  expect_error(suppdata("10.7717/peerj.3006", si = 99))
  expect_error(suppdata("10.7717/peerj.3006", si = "si_1"))
  expect_error(suppdata("10.5194/bg-15-3625-2018", si = 1), "No supplement found")
})

test_that("There is an error for non-existing publishers", {
  skip_on_cran()
  expect_warning(expect_error(suppdata("10.5194/bg-15-3625-xxxx", si = 1), "Cannot find publisher"), "404")
})

test_that("There is an error for boolean SI info", {
  skip_on_cran()
  expect_error(suppdata("10.6084/m9.figshare.979288", FALSE), "'si' must be numeric or character")
  expect_error(suppdata:::.suppdata.figshare("10.6084/m9.figshare.979288", FALSE), "numeric or character SI info")
})

test_that("There is an error on empty DOI vector", {
  skip_on_cran()
  expect_error(suppdata(as.character(c()), "1"), "'x' must contain some data")
})

test_that("There is an error if target dir does not exist", {
  skip_on_cran()
  expect_error(suppdata("10.1371/journal.pone.0127900", 1, dir = "/wrong.path"), "must exist")
})

test_that("file name can be set", {
      skip_on_cran()
  filename <- "myfile.R"
  saved_file <- suppdata("10.6084/m9.figshare.979288", "analysis.R", save.name = filename)
  expect_true(file.exists(saved_file))
  expect_equal(basename(saved_file), filename)
})

test_that("output dir can be set", {
  skip_on_cran()
  testdir <- file.path(tempdir(), "testdir")
  dir.create(testdir)
  saved_file <- suppdata("10.6084/m9.figshare.979288", "analysis.R", dir = testdir)
  expect_true(file.exists(file.path(testdir, "10.6084_m9.figshare.979288_analysis.R")))
  unlink(testdir)
})

test_that("no console output by default", {
  skip_on_cran()
  expect_equal(capture_output(suppdata(x = "10.1038/nbt.1883", si = "41598_2018_37987_Fig1_HTML.jpg")), "")
})

test_that("no console output if deactivated", {
  skip_on_cran()
  expect_equal(capture_output(suppdata(x = "10.1038/nbt.1883", si = "41598_2018_37987_Fig1_HTML.jpg", list = FALSE)), "")
})

test_that("zipfile contents can be listed on the console", {
  skip_on_cran()
  expect_output(suppdata(x = "10.1038/nbt.1883", si = "41598_2018_37987_Fig1_HTML.jpg", list = TRUE), "Files in ZIP")
})

test_that("zipfile contents are listed on the console even if file is missing", {
  skip_on_cran()
  expect_error(expect_output(suppdata(x = "10.1038/nbt.1883", si = "not_there", list = TRUE), "41598_2018_37987_MOESM1_ESM.pdf"))
})
