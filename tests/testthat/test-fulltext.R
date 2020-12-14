if(require("suppdata") & require("testthat") & require("fulltext")){

    context("Package 'fulltext'")

    test_that("fulltext::ft_search's output as input works", {
        skip_if_not_installed("fulltext")
        skip_on_cran()
        expect_true(file.exists(suppdata(fulltext::ft_search("beyond the edge with edam", limit = 1), 1)))
    })

    test_that("Multiple results from fulltext::ft_search is handled gracefully", {
        skip_if_not_installed("fulltext")
        skip_on_cran()
        expect_error(suppdata(fulltext::ft_search("beyond the edge with edam"), 1), "More than one DOI")
    })

    test_that("No results from fulltext::ft_search is handled gracefully", {
        skip_if_not_installed("fulltext")
        skip_on_cran()
        expect_error(
            suppdata(fulltext::ft_search("complete ghibberish", limit = 1), 1),
            "No DOI found in fulltext search")
    })

    test_that("fulltext::ft_get's output as input works for single DOI", {
        skip_if_not_installed("fulltext")
        skip_on_cran()
        expect_true(file.exists(suppdata(fulltext::ft_get("10.1371/journal.pone.0126524"), 1)))
    })

    test_that("Multiple DOIs with fulltext::ft_get give error", {
        skip_if_not_installed("fulltext")
        skip_on_cran()
        expect_error(
            suppdata(fulltext::ft_get(c("10.1371/journal.pone.0126524","10.1371/journal.pone.0080278")), 1),
            "More than one DOI")
    })

}
