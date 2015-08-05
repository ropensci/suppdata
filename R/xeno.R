#' Xeno-Canto meta-data download wrapper
#'
#' Parameters and meanings are described in Xeno-Canto API
#' documentation (http://www.xeno-canto.org/article/153). This is a
#' very light wrapper! You can download the next page of data using
#' the 'page' parameter; I've yet to write a 'continue downloading'
#' wrapper, in part for fear of over-using the API.
#' @param params named vector of parameters to search Xeno-Canto
#' with. Names should be the parameter type, and values should be the
#' values for those searches.
#' @param verbose whether to print what page (of how many) is being
#' downloaded (default: TRUE)
#' @param types categories of meta-data to return about
#' calls. Defaults are intended to be everything everything; for space
#' reasons you might not want everything.
#' @examples
#' xeno.canto.meta(setNames(c("bearded bellbird", "A"), c("species", "q")))
#' @author Will Pearse
#' @importFrom RCurl getURL
#' @importFrom rjson fromJSON
#' @export
xeno.canto.meta <- function(params, verbose=TRUE, types=c("id","gen","sp","ssp","en","rec","cnt","loc","lat","lng","type","file","lic","url","q")){
    #Argument handling
    if(!is.character(params) | !"names" %in% names(attributes(setNames(letters, letters))))
        stop("'params' must be a named character vector")
    if(!is.character(types))
        stop("'types' must be a character vector")
    
    #Download raw data
    url <- paste(names(params), params, sep=":", collapse="&")
    url <- URLencode(gsub("species:", "", url, fixed=TRUE))
    url <- paste0("http://www.xeno-canto.org/api/2/recordings?query=", url)

    #Parse and return
    results <- fromJSON(getURL(url))
    if(verbose)
        cat("Downloading page ", results$page, " of ", results$numPages, "\n")
    output <- data.frame(t(sapply(results$recordings, function(x) unlist(x)[types])))
    return(output)
}

#' Xeno-Canto data download wrapper
#'
#' Parameters and meanings are described in Xeno-Canto API
#' documentation (http://www.xeno-canto.org/article/153). This is a
#' very light wrapper! You can download the next page of data using
#' the 'page' parameter; I've yet to write a 'continue downloading'
#' wrapper, in part for fear of over-using the API.
#' @param ids vector of ids (*not* URLs), probably taken from
#' \code{\link{xeno.canto.meta}}
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @examples
#' xeno.canto.download(xeno.canto.meta(setNames(c("bearded bellbird",
#'     "A"), c("species", "q")))$id[1])
#' xeno.canto.download("247117")
#' xeno.canto.download(247117:247120)
#' @author Will Pearse
#' @importFrom RCurl getURL
#' @importFrom rjson fromJSON
#' @export
xeno.canto.download <- function(ids, save.name=NULL, dir=NULL){
    #Internal wrapper
    .dwn <- function(x)
        .download(paste0("http://www.xeno-canto.org/",x), dir, paste(save.name, x, sep="_"))

                  #Argument handling
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name))
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    
    #Download and return
    output <- sapply(ids, .dwn)
    return(output)
}
