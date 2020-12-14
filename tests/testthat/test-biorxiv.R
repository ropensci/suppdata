if(require("suppdata") & require("testthat")){
    
    context("bioRxiv")

    test_that("bioRxiv works", {
        skip_on_cran()
        expect_true(file.exists(suppdata("10.1101/016386", 1)))
    })

    test_that("bioRxiv fails with character SI info", {
        skip_on_cran()
        expect_error(suppdata("10.1101/016386", si = "999"), "numeric SI info")
    })

}
