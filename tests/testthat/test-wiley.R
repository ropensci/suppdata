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

test_that("Wiley works", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.1111/ele.12437", si = 1)))
})

test_that("Wiley works (accessing different SI)", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.1111/ele.12437", si = 2)))
})

test_that("Wiley works (yet another DOI)", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.1002/ece3.1679", si = 2)))
})

test_that("Non-existing SI number is handled for Wiley", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata('10.1111/ele.12437', si = 3), "greater than number of detected SIs")
})

test_that("Wiley fails with character SI info)", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata("10.1111/ele.12437", "999"), "numeric SI info")
})
