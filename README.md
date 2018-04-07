[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://api.travis-ci.org/willpearse/suppdata.svg)](https://travis-ci.org/willpearse/suppdata)
[![DOI](https://zenodo.org/badge/38581632.svg)](https://zenodo.org/badge/latestdoi/38581632)
[![](https://badges.ropensci.org/195_status.svg)](https://github.com/ropensci/onboarding/issues/195)
[![Coverage status](https://codecov.io/gh/willpearse/suppdata/branch/master/graph/badge.svg)](https://codecov.io/github/willpearse/suppdata?branch=master)
## Loading SUPPlementary DATA into R

William D. Pearse and Scott Chamberlain

## Overview

The aim of this package is to aid downloading data from published
papers. To download the supplementary data from a PLoS paper, for
example, you would simply type:

```
library(suppdata)
suppdata("10.1371/journal.pone.0127900", 1)
```

...and this would download the first SI from the paper.

This sort of thing is very useful if you're doing meta-analyses, or
just want to make sure that you know where all your data came from and
want a completely reproducible "audit trail" of what you've done. It
uses `rcrossref` to lookup which journal the article is in.

## How to install and load this development version

```
library(devtools)
install_github("willpearse/suppdata")
library(suppdata)
```

This package depends on the packages `httr`, `httr`, `xml2`,
`jsonlite`, and `rcrossref`.


## For more information, read the wiki!

[For more details on how to use the package, check out the wiki page
by clicking this
link](https://github.com/willpearse/suppdata/wiki/Using-suppdata).

[For more details on how to contribute to the package, check out the
wiki page by clicking this
link](https://github.com/willpearse/suppdata/wiki/Contributing-to-suppdata).

## A more detailed set of motivations for `suppdata`

`suppdata` is an R package to provide easy, reproducible
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
straightforward, reproducible, and the sources of the data are clear
because their DOIs are embedded within the code:

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
