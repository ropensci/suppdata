library("suppdata")
library("testthat")

context("RSBP")

test_that("'Proceedings of the royal society Biology' (RSBP) works", {
  expect_true(file.exists(suppdata("10.1098/rspb.2015.0338", vol = 282,
                                   issue = 1811, 1)))
})

test_that("'Proceedings of the royal society Biology' (RSBP) fails for character SI info", {
      skip_on_cran()
  expect_error(suppdata("10.1098/rspb.2015.0338", vol = 282, issue = 1811, "99"), "numeric SI info")
})
