library(suppdata)
library(testthat)
library(fulltext)

context("suppdata")

test_that("PLOS works", {
  expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1)))
  expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1, "plos")))
})

test_that("Figshare works", {
  expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", 1)))
  expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", "analysis.R")))
  expect_identical(attr(suppdata("10.6084/m9.figshare.979288", 1),"suffix"),"R")
})

test_that("ESA archives works", {
  expect_true(file.exists(suppdata("E093-059", "myco_db.csv", "esa_archives")))
  expect_identical(attr(suppdata("E093-059", "myco_db.csv", "esa_archives"),
                        "suffix"), "csv")
  })

test_that("ESA data archives works", {
  expect_true(file.exists(suppdata("E092-201", "MCDB_communities.csv",
                                   "esa_data_archives")))
})

test_that("Science works", {
  expect_true(file.exists(suppdata("10.1126/science.1255768",
                                   "Appendix_BanksLeite_etal.txt")))
})

test_that("'Proceedings of the royal society Biology' (RSBP) works", {
  expect_true(file.exists(suppdata("10.1098/rspb.2015.0338", vol=282,
                                   issue=1811, 1)))
})

test_that("'bioRxiv works", {
  expect_true(file.exists(suppdata("10.1101/016386", 1)))
})

test_that("'EPMC works", {
  expect_true(file.exists(suppdata("10.1371/journal.pone.0126524",
                                   "pone.0126524.g005.jpg", "epmc")))
})

test_that("DRYAD works", {
  expect_error(file <- suppdata("10.5061/dryad.34m6j", "datafile.csv"), NA)
  expect_error(data <- read.csv(file), NA)
  expect_equal(dim(data), c(145,49))
  expect_error(file <- suppdata("10.5061/dryad.55610", "Data (revised).txt"),
               NA)
  expect_error(data <- read.delim(file), NA)
  expect_equal(dim(data), c(740,25))
})

test_that("Wiley works", {
  expect_true(file.exists(suppdata("10.1111/ele.12437", si=1)))
  expect_true(file.exists(suppdata("10.1111/ele.12437", si=2)))
  expect_true(file.exists(suppdata("10.1002/ece3.1679", si=2)))
  expect_error(suppdata('10.1111/ele.12437', si=3))
})

test_that("multiple downloads and ft_data are handled well", {
  expect_true(all(file.exists(suppdata(c("10.1101/016386", "10.1111/ele.12437"),
                                       si=1))))
  expect_true(all(file.exists(suppdata(c("10.1101/016386", "10.1111/ele.12437"),
                                       si=2:1))))
  expect_true(all(file.exists(suppdata(c("10.1101/016386", "10.1111/ele.12437"),
                                       si=1))))
  expect_true(file.exists(suppdata(ft_search("beyond the edge with edam", limit=1),1)))
  expect_error(suppdata(ft_search("beyond the edge with edam"),1))
  expect_error(suppdata(
      ft_get(c("10.1371/journal.pone.0126524","10.1371/journal.pone.0126524")),
      1))
  expect_true(file.exists(suppdata(ft_get("10.1371/journal.pone.0126524"),1)))
})

test_that("PeerJ works", {
  expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                         "10.7717/peerj.3006"),
                                       si = 1))))
  expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                         "10.7717/peerj.3006"),
                                       si = "supp-2"))))
  expect_equal(attr(suppdata("10.7717/peerj.3006", si = 1), which = "suffix"), "docx")
  expect_equal(attr(suppdata("10.7287/peerj.preprints.26561", si = 1), which = "suffix"), "csv")
})

test_that("Copernicus works", {
  cop_unzipped_files <- suppdata("10.5194/bg-14-1739-2017", si = 1)
  expect_true(dir.exists(cop_unzipped_files))
  expect_length(list.files(cop_unzipped_files), 8)
  cop_zipfile_only <- suppdata("10.5194/bg-14-1739-2017", si = "bg-14-1739-2017-supplement.zip")
  expect_true(file.exists(cop_zipfile_only))
  expect_false(dir.exists(cop_zipfile_only))
  cop_unzip_dir <- suppdata("10.5194/bg-14-1739-2017", si = 1, save.name = "target-directory")
  expect_true(file.exists(file.path(cop_unzip_dir, "bg-14-1739-2017-supplement-title-page.pdf")))
  expect_match(cop_unzip_dir, "/target-directory$")
  
  csv_file <- suppdata("10.5194/bg-14-1739-2017", si = "Table S1 v2 UFK FOR_PUBLICATION.csv")
  expect_true(file.exists(csv_file))
  csv_data <- read.csv(file = csv_file, skip = 3)
  expect_equal(names(csv_data)[2:3], c("YEAR", "NAD83_X"))
  expect_true(file.exists(suppdata("10.5194/bg-14-1739-2017", si = "Table S1 v2 UFK FOR_PUBLICATION.csv", save.name = "data.csv")))
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = 2), "one supplemental archive")
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = "1"), "file not in zipfile")
  
  cop_pdf_file <- suppdata("10.5194/acp-2016-189", si = 1)
  expect_true(file.exists(cop_pdf_file))
  expect_equal(attr(cop_pdf_file, which = "suffix"), "pdf")
})

test_that("suppdata fails well", {
  expect_error(expect_warning(suppdata('nonsense', 1), "404"), "nonsense")
  expect_error(suppdata('10.6084/m9.figshare.979288', 20))
  expect_error(suppdata('10.6084/m9.figshare.979288', "does_exist.csv"))
  expect_error(suppdata("10.7717/peerj.3006", si = 99))
  expect_error(suppdata("10.7717/peerj.3006", si = "si_1"))
  expect_error(suppdata("10.5194/bg-15-3625-2018", si = 1), "No supplement found")
  expect_warning(expect_error(suppdata("10.5194/bg-15-3625-xxxx", si = 1), "Cannot find publisher"), "404")
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = "not a file.csv"), "file not in zipfile")
})

test_that("file name can be set", {
  filename <- "myfile.R"
  saved_file <- suppdata("10.6084/m9.figshare.979288", "analysis.R", save.name = filename)
  expect_true(file.exists(saved_file))
  expect_equal(basename(saved_file), filename)
})

test_that("output dir can be set", {
  testdir <- file.path(tempdir(), "testdir")
  dir.create(testdir)
  saved_file <- suppdata("10.6084/m9.figshare.979288", "analysis.R", dir = testdir)
  expect_true(file.exists(file.path(testdir, "10.6084_m9.figshare.979288_analysis.R")))
  unlink(testdir)
})

test_that("zipfile contents can be listed", {
  expect_output(suppdata(x = "10.1038/nbt.1883", si = "41598_2018_19799_Fig1_HTML.jpg", list = TRUE), "Files in ZIP")
  expect_error(expect_output(suppdata(x = "10.1038/nbt.1883", si = "1", list = TRUE), "41598_2018_19799_MOESM1_ESM.pdf"))
  expect_equal(capture_output(suppdata(x = "10.1038/nbt.1883", si = "41598_2018_19799_Fig1_HTML.jpg")), "")
  expect_equal(capture_output(suppdata(x = "10.1038/nbt.1883", si = "41598_2018_19799_Fig1_HTML.jpg", list = FALSE)), "")
})
