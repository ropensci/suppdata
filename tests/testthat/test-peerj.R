library("suppdata")
library("testthat")

context("PeerJ and PeerJ Preprints")

test_that("PeerJ Preprints works with numeric SI", {
  expect_true(file.exists(suppdata("10.7287/peerj.preprints.26561v1", si = 1)))
})

test_that("PeerJ Preprints works with character SI", {
  skip_on_cran()
  expect_true(file.exists(suppdata("10.7287/peerj.preprints.26561v1", si = "supp-2")))
})

test_that("PeerJ works with numeric SI", {
      skip_on_cran()
  expect_true(file.exists(suppdata("10.7717/peerj.3006", si = 1)))
})

test_that("PeerJ works with character SI", {
  skip_on_cran()
  expect_true(file.exists(suppdata("10.7717/peerj.3006", si = "supp-2")))
})

test_that("PeerJ with multiple DOIs work using numeric SI", {
  skip_on_cran()
  expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                         "10.7717/peerj.3006"),
                                       si = 1))))
})

test_that("PeerJ with multiple DOIs work using character SI", {
  skip_on_cran()
  expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                         "10.7717/peerj.3006"),
                                       si = "supp-2"))))
})

test_that("Accessing specific SI from PeerJ has correct suffix for file", {
  skip_on_cran()
  expect_equal(attr(suppdata("10.7717/peerj.3006", si = 1), which = "suffix"), "docx")
})

test_that("Accessing specific SI from PeerJ Preprints has correct suffix for file", {
  skip_on_cran()
  expect_equal(attr(suppdata("10.7287/peerj.preprints.26561", si = 1), which = "suffix"), "csv")
})
