library(suppdata)
library(testthat)
library(fulltext)

context("suppdata")

test_that("suppdata returns...", {

  #Each journal/publisher combo works well
  expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1)))
  expect_true(file.exists(suppdata("10.1371/journal.pone.0127900", 1, "plos")))
  expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", 1)))
  expect_true(file.exists(suppdata("10.6084/m9.figshare.979288", "analysis.R")))
  expect_identical(attr(suppdata("10.6084/m9.figshare.979288", 1),"suffix"),"R")
  expect_true(file.exists(suppdata("E093-059", "myco_db.csv", "esa_archives")))
  expect_identical(attr(suppdata("E093-059", "myco_db.csv", "esa_archives"),
                        "suffix"), "csv")
  expect_true(file.exists(suppdata("E092-201", "MCDB_communities.csv",
                                   "esa_data_archives")))
  expect_true(file.exists(suppdata("10.1126/science.1255768",
                                   "Appendix_BanksLeite_etal.txt")))
  expect_true(file.exists(suppdata("10.1098/rspb.2015.0338", vol=282,
                                   issue=1811, 1)))
  expect_true(file.exists(suppdata("10.1101/016386", 1)))
  expect_true(file.exists(suppdata("10.1371/journal.pone.0126524",
                                   "pone.0126524.g005.jpg", "epmc")))
  
  #DRYAD
  expect_error(file <- suppdata("10.5061/dryad.34m6j", "datafile.csv"), NA)
  expect_error(data <- read.csv(file), NA)
  expect_equal(dim(data), c(145,49))
  expect_error(file <- suppdata("10.5061/dryad.55610", "Data (revised).txt"),
               NA)
  expect_error(data <- read.delim(file), NA)
  expect_equal(dim(data), c(740,25))
    
  
  #Extra checks for Wiley
  expect_true(file.exists(suppdata("10.1111/ele.12437", si=1)))
  expect_true(file.exists(suppdata("10.1111/ele.12437", si=2)))
  expect_true(file.exists(suppdata("10.1002/ece3.1679", si=2)))
  expect_error(suppdata('10.1111/ele.12437', si=3))
  
  #Multiple downloads and ft_data are handled well
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
  
  
  #Extra checks for PeerJ
  expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                         "10.7717/peerj.3006"),
                                       si = 1))))
  expect_true(all(file.exists(suppdata(c("10.7287/peerj.preprints.26561v1",
                                         "10.7717/peerj.3006"),
                                       si = "supp-2"))))
  expect_equal(attr(suppdata("10.7717/peerj.3006", si = 1), which = "suffix"), "docx")
  expect_equal(attr(suppdata("10.7287/peerj.preprints.26561", si = 1), which = "suffix"), "csv")
  
  #Checks for Copernicus
  cop_unzipped_files <- suppdata("10.5194/bg-14-1739-2017", si = 1)
  expect_true(dir.exists(cop_unzipped_files))
  expect_length(list.files(cop_unzipped_files), 8)
  cop_zipfile_only <- suppdata("10.5194/bg-14-1739-2017", si = 1, unzip.after.download = FALSE)
  expect_true(file.exists(cop_zipfile_only))
  expect_false(dir.exists(cop_zipfile_only))
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = 2), "one supplemental archive")
  expect_error(suppdata("10.5194/bg-14-1739-2017", si = "1"), "one supplemental archive")
})

test_that("suppdata fails well", {
  expect_error(suppdata('nonsense', 1)) #warning?
  expect_error(suppdata('10.6084/m9.figshare.979288', 20))
  expect_error(suppdata('10.6084/m9.figshare.979288', "does_exist.csv"))
  expect_error(suppdata("10.7717/peerj.3006", si = 99))
  expect_error(suppdata("10.7717/peerj.3006", si = "si_1"))
  expect_error(suppdata("10.5194/bg-15-3625-2018", si = 1), "No supplement found")
  expect_error(suppdata("10.5194/bg-15-3625-xxxx", si = 1), "Cannot find publisher")
})
