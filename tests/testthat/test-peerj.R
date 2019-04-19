library("suppdata")
library("testthat")

context("PeerJ and PeerJ Preprints")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))

test_that("PeerJ Preprints works with numeric SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.7287/peerj.preprints.26561v1", si = 1)))
})

test_that("PeerJ Preprints works with character SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.7287/peerj.preprints.26561v1", si = "supp-2")))
})

test_that("PeerJ works with numeric SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.7717/peerj.3006", si = 1)))
})

test_that("PeerJ works with character SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata("10.7717/peerj.3006", si = "supp-2")))
})

test_that("PeerJ with multiple DOIs work using numeric SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                           "10.7717/peerj.3006"),
                                         si = 1))))
})

test_that("PeerJ with multiple DOIs work using character SI", {
    if(skip.these.tests)
        skip_on_cran()
    expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                           "10.7717/peerj.3006"),
                                         si = "supp-2"))))
})

test_that("Accessing specific SI from PeerJ has correct suffix for file", {
    if(skip.these.tests)
        skip_on_cran()
    expect_equal(attr(suppdata("10.7717/peerj.3006", si = 1), which = "suffix"), "docx")
})

test_that("Accessing specific SI from PeerJ Preprints has correct suffix for file", {
    if(skip.these.tests)
        skip_on_cran()
    expect_equal(attr(suppdata("10.7287/peerj.preprints.26561", si = 1), which = "suffix"), "csv")
})
