# Overview

Thank you for your interest in contributing to `suppdata`! The most important contribution you can make to `suppdata` is to add code to download data from another publisher's journals. There are five steps you have to go through to do that; I go through them in detail below, but briefly, they are:

1. Write a download function for a publisher
2. Modify the DOI lookup function so it knows about your download function
3. Modify the documentation for `suppdata` so the user knows what you've done
4. Write a brief unit test checking your function works
5. Submit a pull request

If you want to make a small change to `suppdata` (i.e., changing <= 5 lines of code) fork the repo, make the change, and then make a pull request with the suggestion. If you want to make a more sweeping change (i.e., > 5 lines of code) then _before writing any code_ make an issue and discuss it with @willpearse. The purpose of this is to make maximal use of everyone's time: small code changes are better off "just done" and then we can talk about it; larger changes require discussion before implementation. You're quite welcome to do whatever you wish with the code (within the boundaries of the license, of course), but please be aware that the maintainers of the package are not obligate to accept all pull requests. Of course, the ROpenSci maintainer rules apply, so we'll always be polite and we'll always let you know why we make any decision! :D

When making version changes, please follow the standards set by CRAN, so the next version after "1.2-9" would be "1.2-10". Package versions numbers are not decimal, so something like "1.2.9.5" won't pass CRAN's checks ([see the R extension guide](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#The-DESCRIPTION-file))

## (1) Write a download function for a publisher

All `suppdata` download functions start off with, at a minimum, something like:

```{R}
.suppdata.nameofpublisher <- function(doi, si, save.name=NA, dir=NA, cache=TRUE, ...)
```

...where `nameofpublisher` is replaced with the name of the publisher you're loading data from. This should then be followed with something like:

```{R}
#Argument handling
if(!is.numeric(si))
    stop("nameofpublisher download requires numeric SI info")
dir <- .tmpdir(dir)
save.name <- .save.name(doi, save.name, si)
```

Note the name of the section (`#Argument handling`), and how we're making sure the user gives us a supplement number if we need that, or using `is.character` if we're expecting some `character SI info`. We have a few internal functions that should make your life easier (...well, they should...); `.tmp.dir` will make a temporary directory to save files out to for you, and `.save.name` will generate a sensible name to save files out to as well. It's quite important that you use those functions, since they make the `cache` behaviour of the package work.

Next comes the hard work, where you get the data out of the publisher's website. [This is a lot of regular expression kung-foo](https://xkcd.com/208/); you may find the functions `.grep.url`, `.grep.text`, `.url.redir`, and all the other functions in [`utils.R`](https://github.com/willpearse/suppdata/blob/master/R/utils.R) useful. Please do have a poke around in there, and feel free to add any functions you think are missing (using the `.name.function.` convention for non-user-facing functions). If there's something you think would be useful to have, and you don't know how to write it, then just make an issue, tag me (@willpearse), and I'll see what I can do.

Finally, you need to return to the user a location of the file they want. Something like:

```{R}
destination <- file.path(dir, save.name)
return(.download(url, dir, save.name, cache))
```

...should suffice. Notice how we're using `R`'s `file.path` to make a sensible path on all distributions, and we're using the internal `.download` to download the file, and so guaranteeing that we'll obey all the `cache` instructions etc. We're also ensuring that the user will get sensible filename information ("oooh, this looks like a .csv file") as an attribute by using `.download`.

Save your function in [`journals.R`](https://github.com/willpearse/suppdata/blob/master/R/journals.R). There are plenty of examples in there if you get stuck. There is also a list of functions to be written sitting in the issues section on GitHub.

There is a 'hit list' of publishers that it would be great to write wrappers for up in the issues page - [click this link to see it](https://github.com/willpearse/suppdata/issues/2).

## (2) Modify the DOI lookup function so it knows about your download function

We're nearly there now, I promise! `suppdata` uses `rcrossref` to look up articles' publishers, so to hook your download function into the package you're going to have to figure out your journal's code. Take a paper's DOI that you know works, and run the following on it (replacing the DOI below with the DOI you're checking):

```{R}
library(rcrossref)
cr_works("10.1111/j.1461-0248.2009.01307.x")$data$member
```

...that number is your publisher's code. Modify the first `switch` statement in `suppdata.func` in [`utils.R`](https://github.com/willpearse/suppdata/blob/master/R/utils.R) to add your journal's number (as a character string) and then match it with the name of your download function. If that sounds complicated, once you open the function it will become obvious.

Next, modify the second (and last) `switch` in the same function to work if your publisher is known by name. This should match onto your function's name. So, for example, if your publishing company were called _Pearse Publishing_, and you'd called your function `.suppdata.pearse`, then you would add an entry like:

```{R}
"pearse" = .suppdata.pearse
```

Please remember that `case` statements are separated by commas; add a comma to the previous entry to keep the code syntactically correct!

## (3) Modify the documentation for `suppdata` so the user knows what you've done

Modify the `roxygen` documentation [here](https://github.com/willpearse/suppdata/blob/master/R/suppdata.R#L17) and [here](https://github.com/willpearse/suppdata/blob/master/man-roxygen/suppdata.R#L27) to give the user information about what your function expects (`numeric` vs. `character` SI information). Re-build the documentation when you're done by running something like:

```{R}
library(roxygen2)
roxygenize("path/to/suppdata")
```

...if you're an RStudio person there's a button for this in the "Build" tab ("More" > "Document"). If you're an emacs person like me, there are several and you probably have a strong opinion about which is best :p

## (4) Write a brief unit test checking your function works

Add tests to [`tests/testthat/`](https://github.com/willpearse/suppdata/blob/master/tests/testthat/) with a file of the format `test-<name of publisher>.R` (see existing tests to get started) to give the maintainers and the continuous integration services something to check that the publisher works.

## (5) Add publisher to list in README

Add the newly supported publisher to the alphabetically ordered list in `README.md`.

## (6) Submit a pull request

Commit your changes, then make a pull request to the `master` branch of `suppdata`. If you need help figuring out how to do that, [take a look at this website](https://help.github.com/articles/creating-a-pull-request/).

## (optional) Bask in glory

Thank you for helping make `suppdata` better!!!

## (side-note) History of the package

I always think a little history is useful when contributing to a package, so let me tell you how the code here came to be. Originally, this package was called `grabr` (this repo is the same repo, the name alone changed), which was then merged into [`fulltext`](https://github.com/ropensci/fulltext/). At that time, the structure was changed to match that of `fulltext`, but this code was then pulled back _out_ of `fulltext`. So if you ever find yourself wondering "why does it do that?", the answer is probably "because `fulltext` does".
