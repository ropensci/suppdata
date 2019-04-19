library("suppdata")
library("testthat")

context("Figshare")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))


test_that("Figshare works with minimal input", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", 1)))
})

test_that("Accessing specific SI from Figshare works", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", "analysis.R")))
})

test_that("Accessing specific SI from Figshare has correct suffix for file", {
    if(skip.these.tests)
        skip_on_cran()
    expect_identical(attr(suppdata("10.6084/m9.figshare.979288", 1),"suffix"),"R")
})
