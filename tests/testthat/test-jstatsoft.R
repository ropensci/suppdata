if(require("suppdata") & require("testthat")){
    
    context("JStatSoft")

    test_that("JStatSoft works with numeric SI", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.18637/jss.v063.i02", si = 1)))
    })

    test_that("JStatSoft works with numeric SI and setting the file name", {    
        skip_on_cran()
        filename <- "test_supp.tar.gz"
        supplement <- suppdata("10.18637/jss.v063.i02", si = 1, save.name = filename)
        expect_true(file.exists(supplement))
        expect_equal(basename(supplement), filename)
        expect_equal(attr(supplement, "suffix")[[1]], "gz")
        expect_equal(names(attr(supplement, "suffix")), "micromap_1.9.1.tar.gz")
    })

    test_that("JStatSoft returns error on non-existing numeric SI", {    
        skip_on_cran()
        expect_error(suppdata("10.18637/jss.v063.i02", si = 99), "No supplement")
    })

    test_that("JStatSoft returns error on non-existing character SI", {    
        skip_on_cran()
        expect_error(suppdata("10.18637/jss.v063.i02", si = "wrongfilename"), "No supplement")
    })

    test_that("JStatSoft works with character SI", {    
        skip_on_cran()
        expect_true(file.exists(suppdata("10.18637/jss.v063.i02", si = "v63i02.RData")))
    })

    test_that("JStatSoft with multiple DOIs works using numeric SI", {    
        skip_on_cran()
        supplements <- suppdata(c("10.18637/jss.v088.i05",
                                  "10.18637/jss.v063.i05"),
                                si = 1)
        expect_length(supplements, 2)
        expect_true(all(file.exists(supplements)))
    })

    test_that("Accessing specific SI from JStatSoft has correct suffix for file", {    
        skip_on_cran()
        supplement <- suppdata("10.18637/jss.v063.i02", si = 3)
        file.exists(supplement)
        expect_equal(attr(supplement, which = "suffix")[[1]], "RData")
    })

    test_that("Accessing SI from JStatSoft has correct suffix for file", {    
        skip_on_cran()
        expect_equal(attr(suppdata("10.18637/jss.v063.c01", si = 1), which = "suffix")[[1]], "zip")
    })

}
