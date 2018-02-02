## Loading SUPPlementary DATA into R
[![Build Status](https://travis-ci.org/willpearse/suppdata.svg)](https://travis-ci.org/willpearse/suppdata)
============================================
William D. Pearse and Scott Chamberlain

## Overview 

The aim of this package is to aid downloading data from published
papers, and to provide some wrappers for APIs that are missing from R
(e.g., Xeno-Canto). To download the supplementary data from a PLoS
paper, for example, you would simply type:

```
library(suppdata)
suppdata("10.1371/journal.pone.0127900", 1)
```

...and this would download the first SI from the paper.

This sort of thing is very useful if you're doing meta-analyses, or
just want to make sure that you know where all your data came from and
want a completely reproducible "audit trail" of what you've done.

## How to contribute to the package

*Thank you* for helping out! Before making a pull request, make sure
 that you:
* Discuss what you want to do in the 'issues' section on GitHub. That
  way no one duplicates effort; I keep a track of all the things I
  want to do there (including the journals in need of download scripts)
* Please use the internal functions I've written (in ```utils.R```)
  for downloading, findng URLs, etc. By all means write a new internal
  function or improve on something that's in there :D
* I won't accept a pull request that doesn't contain unit tests for
  the code you've written. I realise I don't always write tests as I
  go, but you have to :p

Again - *thank you*! If you've contributed a non-trivial improvement
to the package (i.e., you've written a function longer than two lines)
I'll add you to the authors list. Do tell me how you want your name
spelt etc.
