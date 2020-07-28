library("suppdata")
library("testthat")

context("Europe PMC")

test_that("EPMC works", {   
    skip_on_cran()
    expect_true(file.exists(suppdata("10.1371/journal.pone.0126524",
                                     "pone.0126524.s002.jpg", "epmc")))
})

test_that("EPMC fails for numeric SI info", {    
    skip_on_cran()
    expect_error(suppdata("10.1371/journal.pone.0126524", si = 999, "epmc"), "character SI info")
})
