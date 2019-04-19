library("suppdata")
library("testthat")

context("PLOS")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))

test_that("PLOS works with minimal input", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1)))
})

test_that("PLOS works specifying 'from'", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1, "plos")))
})

test_that("PLOS fails with character SI info", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata("10.1371/journal.pone.0127900", "999"), "numeric SI info")
})

test_that("PLOS fails with unknown journal SI info", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata:::.suppdata.plos("10.1111/ele.12437", 1), "Unrecognised PLoS journal")
})
