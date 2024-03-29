#' Download supplementary materials from journals
#'
#' Put a call to this function where you would put a file-path - everything 
#' is cached by default, so you don't have to worry about multiple downloads 
#' in the same session.
#' 
#' @param x One of: vector of DOI(s) of article(s) (a
#'     \code{character}) or ESA-specific article code.
#' @param si number of the supplementary information (SI) to be
#'     downloaded (1, 2, 3, etc.), or (for ESA, Science, and
#'     Copernicus journals) the name of the supplement (e.g.,
#'     "S1_data.csv"). Can be a \code{character} or \code{numeric}.
#' @param from Publisher of article (\code{character}). The default
#'     (\code{auto}) uses crossref (\code{\link[rcrossref]{cr_works}})
#'     to detect the journal's publisher. Specifying the journal can
#'     somewhat speed up your download, or be used to force a download
#'     from EPMC (see details). You *must* specify if downloading from
#'     an ESA journal (\code{esa_data_archives},
#'     \code{esa_archives}). You can only use this argument if
#'     \code{x} is a vector of DOI(s). Must be one of: \code{auto}
#'     (i.e., auto-detect journal; default), \code{plos},
#'     \code{wiley}, \code{science}, \code{proceedings},
#'     \code{figshare}, \code{esa_data_archives}, \code{esa_archives},
#'     \code{biorxiv}, \code{epmc}, \code{peerj}, \code{copernicus},
#'     (Data)\code{dryad}), \code{mdpi}, or \code{jstatsoft}.
#' @param save.name a name for the file to download
#'     (\code{character}). If \code{NA} (default) this will be a
#'     combination of the DOI and SI number
#' @param dir directory to save file to (\code{character}). If
#'     \code{NA} (default) this will be a temporary directory created
#'     for your files
#' @param cache if \code{TRUE} (default), the file won't be downloaded
#'     again if it already exists (in a temporary directory creates,
#'     or your chosen \code{dir})
#' @param vol Article volume (Proceedings journals only;
#'     \code{numeric})
#' @param issue Article issue (Proceedings journals only;
#'     \code{numeric})
#' @param list if \code{TRUE}, print all files within a zip-file
#'     downloaded from EPMC (default: FALSE). This is *very* useful if
#'     using EPMC (see details)
#' @param timeout how long to wait for successful download (default 10
#'     seconds)
#' @param zip if \code{TRUE}, force download in binary format in order
#'     to ensure that zipped files will work on Windows (default
#'     FALSE).

#' @author Will Pearse (\email{will.pearse@usu.edu}) and Scott
#'     Chamberlain (\email{myrmecocystus@gmail.com})
#' @note Make sure that the article from which you're attempting to
#'     download supplementary materials *has* supplementary
#'     materials. 404 errors and 'file not found' errors can result
#'     from such cases.
#' @examples
#' # NOTE: The examples below are flagged as 'dontrun' to avoid
#' # running downloads repeatedly on CRAN servers
#' \dontrun{
#' #Put the function wherever you would put a file path
#' crabs <- read.csv(suppdata("10.6084/m9.figshare.979288", 2))
#'
#' epmc.fig <- suppdata("10.1371/journal.pone.0126524",
#'                        "pone.0126524.s002.jpg", "epmc")
#' #...note this 'SI' is not actually an SI, but rather an image from the paper.
#'
#' #View the suffix (file extension) of downloaded files
#' # - note that not all files are uploaded/stored with useful file extensions!
#' attr(epmc.fig, "suffix")
#' 
#' copernicus.csv <- suppdata("10.5194/bg-14-1739-2017",
#'                            "Table S1 v2 UFK FOR_PUBLICATION.csv",
#'                            save.name = "data.csv")
#' #...note this 'SI' is not an SI but the name of a file in the supplementary information archive.
#' }
#' # (examples not run on CRAN to avoid downloading files repeatedly)
#' @template suppdata
#' @export
#' @importFrom stats setNames
suppdata <- function(x, si,
                     from=c("auto","plos","wiley","science","proceedings",
                            "figshare","esa_data_archives","esa_archives",
                            "biorxiv","epmc", "peerj", "copernicus",
                            "jstatsoft"),
                     save.name=NA, dir=NA, cache=TRUE, vol=NA, issue=NA,
                     list=FALSE, timeout=10, zip=FALSE)
    UseMethod("suppdata")
#' @export
#' @rdname suppdata
suppdata.character <- function(x, si,
                               from=c("auto","plos","wiley","science",
                                      "proceedings","figshare",
                                      "esa_data_archives","esa_archives",
                                      "biorxiv","epmc","peerj", "copernicus",
                                      "jstatsoft"),
                               save.name=NA, dir=NA, cache=TRUE,
                               vol=NA, issue=NA, list=FALSE, timeout=10, zip=FALSE){
    #Basic argument handling
    if(length(x) == 0)
        stop("'x' must contain some data!")
    from <- match.arg(from)
    if(!(is.numeric(si) | is.character(si)))
        stop("'si' must be numeric or character")

    #Multiply argument lengths
    from <- .fix.param(x, from, "from")
    si <- .fix.param(x, si, "si")
    save.name <- .fix.param(x, save.name, "save.name")
    dir <- .fix.param(x, dir, "dir")
    vol <- .fix.param(x, vol, "vol")
    issue <- .fix.param(x, issue, "issue")
    cache <- .fix.param(x, cache, "cache")
    list <- .fix.param(x, list, "list")
    timeout <- .fix.param(x, timeout, "timeout")
    
    ############################
    #Recurse if needed
    # - can't use Recall because of potential argument length problems
    if(length(x) > 1)
        return(setNames(unlist(
            mapply(suppdata.character, x=x,si=si,from=from,save.name=save.name,
                   dir=dir,cache=cache,vol=vol,issue=issue,list=list,
                   timeout=timeout, zip=zip))
           ,x))
    ############################
    #...Do work

    #Setup output directory and filename
    if(!is.na(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NA")
    } else dir <- tempdir()
    if(is.na(save.name)){
        save.name <- paste(x,si, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Find publisher, download, and return
    if(from == "auto")
        from <- .suppdata.pub(x)
    func <- .suppdata.func(from)
    return(func(x, si, save.name=save.name, dir=dir, cache=cache,
                vol=vol, issue=issue, list=list, timeout=timeout, zip=zip))
}
