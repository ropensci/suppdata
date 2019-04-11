library("suppdata")
library("testthat")

context("Science")

test_that("Science works", {
  expect_true(file.exists(suppdata("10.1126/science.1255768",
                                   "Appendix_BanksLeite_etal.txt")))
})

test_that("Science fails with numeric SI info", {
      skip_on_cran()
  expect_error(suppdata("10.1126/science.1255768", 999), "character SI info")
})
