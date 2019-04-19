# library("suppdata")
library("testthat")

context("ESA (data) archives")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))


skip_if_not_reachable <- function() {
    tryCatch({
        httr::HEAD('http://esapubs.org')
    },
    error = function(e) {
        skip(message = toString(e))
    }
    )
}

test_that("Accessing specific SI from ESA archives works", {
    if(skip.these.tests)
        skip_on_cran()
    skip_if_not_reachable()
    expect_true(file.exists(suppdata("E093-059", "myco_db.csv", "esa_archives")))
})

test_that("Accessing specific SI from ESA archives has correct suffix for file", {
    if(skip.these.tests)
        skip_on_cran()
    skip_if_not_reachable()
    expect_identical(attr(suppdata("E093-059", "myco_db.csv", "esa_archives"),
                          "suffix"), "csv")
})

test_that("ESA archives fail with numeric SI info", {
    if(skip.these.tests)
        skip_on_cran()
    skip_if_not_reachable()
    expect_error(suppdata("E093-059", 999, "esa_archives"), "character SI info")
})

test_that("ESA data archives works", {
    if(skip.these.tests)
        skip_on_cran()
    skip_if_not_reachable()
    expect_true(file.exists(suppdata("E092-201", "MCDB_communities.csv",
                                     "esa_data_archives")))
})

test_that("ESA data archives fail with numeric SI info", {
    if(skip.these.tests)
        skip_on_cran()
    skip_if_not_reachable()
    expect_error(suppdata("E092-201", 999, "esa_data_archives"), "character SI info")
})
