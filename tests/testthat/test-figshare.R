if(require("suppdata") & require("testthat")){
    
    context("Figshare")

    test_that("Figshare works with minimal input", {
        skip_on_cran()
        expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", 1)))
    })

}
