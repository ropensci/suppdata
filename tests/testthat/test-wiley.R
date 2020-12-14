if(require("suppdata") & require("testthat")){
    
    context("Figshare")

    test_that("Wiley works", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.1111/ele.12437", si = 1)))
    })

    test_that("Wiley works (accessing different SI)", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.1111/ele.12437", si = 2)))
    })

    test_that("Wiley works (yet another DOI)", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.1002/ece3.1679", si = 2)))
    })

    test_that("Non-existing SI number is handled for Wiley", {    
        skip_on_cran()
        expect_error(suppdata('10.1111/ele.12437', si = 3), "greater than number of detected SIs")
    })

    test_that("Wiley fails with character SI info)", {    
        skip_on_cran()
        expect_error(suppdata("10.1111/ele.12437", "999"), "numeric SI info")
    })

}
