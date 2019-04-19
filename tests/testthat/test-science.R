library("suppdata")
library("testthat")

context("Science")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))

test_that("Science works", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.1126/science.1255768",
                                     "Appendix_BanksLeite_etal.txt")))
})

test_that("Science fails with numeric SI info", {
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata("10.1126/science.1255768", 999), "character SI info")
})
