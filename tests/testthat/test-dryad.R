library("suppdata")
library("testthat")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))


context("Dryad")

test_that("DRYAD works and file contents are as expected (csv file)", {
    if(skip.these.tests)
        skip_on_cran()
    file  <- suppdata("10.5061/dryad.34m6j", "datafile.csv")
    expect_true(file.exists(file))
    data <- read.csv(file)
    expect_equal(dim(data), c(145,49))
})

test_that("DRYAD works and file contents are as expected (txt file)", {
    if(skip.these.tests)
        skip_on_cran()
    file <- suppdata("10.5061/dryad.55610", "Data (revised).txt")
    expect_true(file.exists(file))
    data <- read.delim(file)
    expect_equal(dim(data), c(740,25))
})

test_that("DRYAD fails for numeric SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata("10.5061/dryad.34m6j", si = 999), "character SI info")
})
