---
title: 'Suppdata: Downloading Supplementary Data from Published Manuscripts'
tags:
- supplementary materials
- supplemental information
- open data
- meta-analysis
- DOI
authors:
- name: William D Pearse
  orcid: 0000-0002-6241-3164
  affiliation: 1
- name: Scott A Chamberlain
  orcid: 0000-0003-1444-9135
  affiliation: 2
affiliations:
- name: Department of Biology & Ecology Center, Utah State University, Logan, Utah, USA
  index: 1
- name:  rOpenSci
  index: 2
date: 2 May 2017
bibliography: paper.bib
---

# Summary

`suppdata` is an R [@R2018] package to provide easy, reproducible
access to supplemental materials within R. Thus `suppdata` facilitates
open, reproducible research workflows: scientists re-analyzing
published datasets can work with them as easily as if they were stored
on their own computer, and others can track their analysis workflow
painlessly.

For example, imagine you were conducting an analysis of the evolution
of body mass in mammals. Without `suppdata`, such an analysis would
require manually downloading body mass and phylogenetic data from
published manuscripts. This is time-consuming, difficult (if not
impossible) to make truly reproducible without re-distributing the
data, and hard to follow. With `suppdata`, such an analysis is
straightforward, reproducible, and the sources of the data
[@Fritz2009,@Jones2009] are clear because their DOIs are embedded
within the code:

```{R}
# Load phylogenetics packages
library(ape)
library(caper)
library(phytools)

# Load suppdata
library(suppdata)

# Load two published datasets
tree <- read.nexus(suppdata("10.1111/j.1461-0248.2009.01307.x", 1))[[1]]
traits <- read.delim(suppdata("E090-184", "PanTHERIA_1-0_WR05_Aug2008.txt", "esa_archives"))

# Merge datasets
traits <- with(traits, data.frame(body.mass = log10(X5.1_AdultBodyMass_g), species=gsub(" ","_",MSW05_Binomial)))
c.data <- comparative.data(tree, traits, species)

# Calculate phylogenetic signal
phylosig(c.data$phy, c.data$data$body.mass)
```

The above example makes use of code from the packages `ape`
[@Paradis2004], `caper` [@Orme2013], and `phytools` [@Revell2012].

As `suppdata` was, originally, part of `fulltext` [@Chamberlain2016],
it is already being used in a number of research projects. One such
project is `natdb`, a package that builds a database of functional
traits from published sources. The software is currently available on
GitHub (https://github.com/willpearse/suppdata), and we plan to
distribute it through ROpenSci and CRAN.

# References