# library("suppdata")
library("testthat")

context("ESA (data) archives")

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
  skip_if_not_reachable()
  expect_true(file.exists(suppdata("E093-059", "myco_db.csv", "esa_archives")))
})

test_that("Accessing specific SI from ESA archives has correct suffix for file", {
  skip_on_cran()
  skip_if_not_reachable()
  expect_identical(attr(suppdata("E093-059", "myco_db.csv", "esa_archives"),
                        "suffix"), "csv")
})

test_that("ESA archives fail with numeric SI info", {
    skip_if_not_reachable()
    skip_on_cran()
  expect_error(suppdata("E093-059", 999, "esa_archives"), "character SI info")
})

test_that("ESA data archives works", {
    skip_if_not_reachable()
    skip_on_cran()
  expect_true(file.exists(suppdata("E092-201", "MCDB_communities.csv",
                                   "esa_data_archives")))
})

test_that("ESA data archives fail with numeric SI info", {
    skip_if_not_reachable()
    skip_on_cran()
  expect_error(suppdata("E092-201", 999, "esa_data_archives"), "character SI info")
})
