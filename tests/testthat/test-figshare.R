library("suppdata")
library("testthat")

context("Figshare")

test_that("Figshare works with minimal input", {
  expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", 1)))
})

test_that("Accessing specific SI from Figshare works", {
  skip_on_cran()
  expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", "analysis.R")))
})

test_that("Accessing specific SI from Figshare has correct suffix for file", {
  skip_on_cran()
  expect_identical(attr(suppdata("10.6084/m9.figshare.979288", 1),"suffix"),"R")
})