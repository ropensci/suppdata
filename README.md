[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://api.travis-ci.org/ropensci/suppdata.svg)](https://travis-ci.org/ropensci/suppdata)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00721/status.svg)](https://doi.org/10.21105/joss.00721)
[![](https://badges.ropensci.org/195_status.svg)](https://github.com/ropensci/onboarding/issues/195)
[![codecov](https://codecov.io/gh/ropensci/suppdata/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/suppdata)

# Loading SUPPlementary DATA into R

William D. Pearse and Scott Chamberlain

# Overview

The aim of this package is to aid downloading data from published
papers. To download the supplementary data from a PLoS paper, for
example, you would simply type:

```
library(suppdata)
suppdata("10.1371/journal.pone.0127900", 1)
```

...and this would download the first supplementary information (SI) from the paper.

This sort of thing is very useful if you're doing meta-analyses, or
just want to make sure that you know where all your data came from and
want a completely reproducible "audit trail" of what you've done.
It uses [`rcrossref`](https://cran.r-project.org/package=rcrossref) to lookup which journal the article is in.

# How to install and load this development version

```
library(devtools)
install_github("ropensci/suppdata")
library(suppdata)
```

This package depends on the packages `httr`, `xml2`,
`jsonlite`, and `rcrossref`.

# Supported publishers and repositories

- [bioRxiv](https://www.biorxiv.org/) (`biorxiv`)
- [Copernicus Publications](https://publications.copernicus.org/) (`copernicus`)
- [DRYAD](https://datadryad.org/) (`dryad`)
- [Ecological Society of Ameria - Ecological Archives](http://esapubs.org/archive/) (`esa_archives` and `esa_data_archives`)
- [Europe PMC](https://europepmc.org/) (`epmc`, multiple publishers from life-sciences upported including BMJ Journals, eLife, F1000Research, Wellcome Open Research, Gates Open Research)
- [figshare](https://figshare.com/) (`figshare`)
- [PeerJ](https://peerj.com/) (`peerj`)
- [PLOS | Public Library of Science](https://www.plos.org/) (`plos`)
- [Proceedings of the royal society Biology (RSBP)](http://rspb.royalsocietypublishing.org/) (`proceedings`)
- [Science](https://www.sciencemag.org/) (`science`)
- [Wiley](https://onlinelibrary.wiley.com/) (`wiley`)

See a list of potential sources at [#2](https://github.com/ropensci/suppdata/issues/2) - requests welcome!

# Contributing

[For more details on how to contribute to the package, check out the
guide in `CONTRIBUTING.MD`](CONTRIBUTING.md).

# A more detailed set of motivations for `suppdata`

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

# A guided walk through `suppdata`

The aim of `suppdata` is to make it as easy as possible for you to write reproducible analysis scripts that make use of published data. So let's start with that first, simplest case: how to make use of published data in an analysis.

## Learning by example
Below is an example of an analysis run using `suppdata`. Read through it first, and then we'll go through what all the parts mean.

```{R}
# Load phylogenetics packages
library(ape)
library(caper)
library(phytools)

###############################
# LOAD TWO PUBLISHED DATASETS #
#       USING SUPPDATA        #
###############################
library(suppdata)
tree <- read.nexus(suppdata("10.1111/j.1461-0248.2009.01307.x", 1))[[1]]
traits <- read.delim(suppdata("E090-184", "PanTHERIA_1-0_WR05_Aug2008.txt", "esa_archives"))

# Merge datasets
traits <- with(traits, data.frame(body.mass = log10(X5.1_AdultBodyMass_g), species=gsub(" ","_",MSW05_Binomial)))
c.data <- comparative.data(tree, traits, species)

# Calculate phylogenetic signal
phylosig(c.data$phy, c.data$data$body.mass)
```

This short script loads some `R` packages focused on modelling the evolution of species' traits, then it gets to the "good stuff": using `suppdata`. First, we load the `suppdata` package using `library(suppdata)`. The next line uses a function called `read.nexus`, which loads something called a phylogeny (you might be familiar with this if you're a biologist). Normally, this function would take the location of a file on our hard-drive as a single argument, but now we're giving it the output from a call to the `suppdata` function.

`suppdata` is going to the website of the article whose DOI is _10.1111/j.1461-0248.2009.01307.x_ ([it's this paper by Fritz et al.](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1461-0248.2009.01307.x)), and then taking the first (`1`) supplement from that article. It saves that to a temporary location on your hard-drive, and then gives that location to `read.nexus`. _This works with any function that expects a file at a location on your hard-drive_. What particularly neat is that `suppdata` remembers that it has downloaded that file already (see below for more details), such that you only have to download something once per `R` session.

The second call to `suppdata`, which makes use of `read.delim`, shows two of the potential complexities of `suppdata`. First of all, because some journal publishers store their supplementary materials using numbers and others using specific file-names, `suppdata` takes either a number (like in the first example), or a name (like in the second example) depending on the journal publisher you're taking data from. If you look in the help file for `suppdata`, there is a table outlining those options. Sorry, you've just got to read up on it :-( Secondly, if you're an ecologist you might be familiar with the Ecological Society of America's data archives section. While they've moved over to a new way of storing data more recently, if you're hoping to load an older dataset from that journal you need to give the ESA data archive reference and specify that you're downloading from ESA (as in this example). If you're not an ecologist, don't worry about it, as this doesn't apply to you :D

That's it! You now know all you need to in order to use `suppdata`! The rest of the lines of code merge these datasets together, and then calculate something called _phylogenetic signal_ in these datasets. If you're an evolutionary biologist, those lines might be interesting to you. If you're not, then don't worry about them.

## Caching and saving to a specific directory

Sometimes, you will want to use `suppdata` to build a store of files on your hard-drive. If so, you should know that `suppdata` takes three optional arguments: `cache`, `dir`, and `save.name`. If you specify `cache=FALSE`, it will turn off `suppdata`'s caching of files: this will force it to download your data again. This is mostly useful if you somehow make `suppdata` foul itself up (maybe you hit control-c or stop during a download) and so `suppdata` has only half-downloaded a file, and so thinks it's cached something when it hasn't. If you get an error when using `suppdata`, this is a good thing to try setting.

`dir` specifies a directory where `suppdata` should store files, and `save.name` specifies the name that the file should be saved under when saved. This is useful if you want to make a folder on your computer that contains certain files you use a lot: `suppdata` will cache from this folder if you tell it to, and so you can build up a reproducible selection of data to use inbetween `R` sessions.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

