library("suppdata")
library("testthat")

context("MDPI")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))


test_that("MDPI journal works with numeric SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.3390/cosmetics2020066", si = 2)))
})

test_that("MDPI fails with non-existing SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata("10.3390/arts8020048", si = 3), "No SI with id")
})

test_that("MDPI fails with character SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata("10.3390/arts8020048", si = "s1"), "numeric SI")
})

test_that("MDPI with multiple DOIs work using numeric SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(all(file.exists(suppdata(c("10.3390/arts8020048",
                                           "10.3390/rs9101025"),
                                         si = 1))))
})

test_that("Accessing single SI from MDPI has correct suffix for pdf file", {
    if(skip.these.tests)
        skip_on_cran()
    expect_equal(attr(suppdata("10.3390/rs9101025", si = 1), which = "suffix"), "pdf")
})

test_that("Accessing single SI from MDPI has correct suffix for zip file", {
    if(skip.these.tests)
        skip_on_cran()
    expect_equal(attr(suppdata("10.3390/arts8020048", si = 1), which = "suffix"), "zip")
})
