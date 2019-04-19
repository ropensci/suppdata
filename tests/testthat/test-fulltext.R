library("suppdata")
library("testthat")
library("fulltext")

context("Package 'fulltext'")

# Code to skip a random fraction of tests (only on CRAN) to avoid data
# servers rate-throttling the tests and making them fail. Note that
# this does *not* affect tests on Travis-CI or OpenCPU, that are
# reported at https://github.com/ropensci/suppdata, becuase these
# tests are run only once (not several times on different builds as at
# CRAN)
skip.these.tests <- sample(c(FALSE, TRUE), size=1, prob=c(.2,.8))

test_that("fulltext::ft_search's output as input works", {
    skip_if_not_installed("fulltext")
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata(fulltext::ft_search("beyond the edge with edam", limit = 1), 1)))
})

test_that("Multiple results from fulltext::ft_search is handled gracefully", {
    skip_if_not_installed("fulltext")
    if(skip.these.tests)
        skip_on_cran()
    expect_error(suppdata(fulltext::ft_search("beyond the edge with edam"), 1), "More than one DOI")
})

test_that("No results from fulltext::ft_search is handled gracefully", {
    skip_if_not_installed("fulltext")
    if(skip.these.tests)
        skip_on_cran()
    expect_warning(
        expect_error(
            suppdata(fulltext::ft_search("complete ghibberish", limit = 1), 1),
            "No DOI found in fulltext search")
    )
})

test_that("fulltext::ft_get's output as input works for single DOI", {
    skip_if_not_installed("fulltext")
    if(skip.these.tests)
        skip_on_cran()
    expect_true(file.exists(suppdata(fulltext::ft_get("10.1371/journal.pone.0126524"), 1)))
})

test_that("Multiple DOIs with fulltext::ft_get give error", {
    skip_if_not_installed("fulltext")
    if(skip.these.tests)
        skip_on_cran()
    expect_error(
        suppdata(fulltext::ft_get(c("10.1371/journal.pone.0126524","10.1371/journal.pone.0126524")), 1),
        "More than one DOI")
})
