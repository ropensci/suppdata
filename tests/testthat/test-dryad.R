library("suppdata")
library("testthat")

context("Dryad")

test_that("DRYAD works and file contents are as expected (csv file)", {
    skip_on_cran()
    file  <- suppdata("10.5061/dryad.34m6j", "datafile.csv")
    expect_true(file.exists(file))
    data <- read.csv(file)
    expect_equal(dim(data), c(145,49))
})

test_that("DRYAD works and file contents are as expected (txt file)", {
    skip_on_cran()
    file <- suppdata("10.5061/dryad.55610", "Data (revised).txt")
    expect_true(file.exists(file))
    data <- read.delim(file)
    expect_equal(dim(data), c(740,25))
})

test_that("DRYAD fails for numeric SI", {
    skip_on_cran()
    expect_error(suppdata("10.5061/dryad.34m6j", si = 999), "character SI info")
})
