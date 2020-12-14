if(require("suppdata") & require("testthat")){
    
    context("PLOS")

    test_that("PLOS works with minimal input", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1)))
    })

    test_that("PLOS works specifying 'from'", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1, "plos")))
    })

    test_that("PLOS fails with character SI info", {    
        skip_on_cran()
        expect_error(suppdata("10.1371/journal.pone.0127900", "999"), "numeric SI info")
    })

    test_that("PLOS fails with unknown journal SI info", {    
        skip_on_cran()
        expect_error(suppdata:::.suppdata.plos("10.1111/ele.12437", 1), "Unrecognised PLoS journal")
    })

}
