#' Downloads supplementary materials from PLoS journals
#' @param doi DOI of article
#' @param si.no which supplement (first, second, etc.) as printed in
#' the article, to download. Note that "Fig S1" is not valid; this
#' should be a number
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @author Will Pearse
#' @examples
#' plos("10.1371/journal.pone.0127900", 1)
#' plos("10.1371/journal.pbio.1002177", 1)
#' plos("10.1371/journal.pmed.1001847", 1)
#' plos("10.1371/journal.pgen.1005291", 1)
#' plos("10.1371/journal.pcbi.1004327", 1)
#' plos("10.1371/journal.ppat.1005005", 1)
#' plos("10.1371/journal.pntd.0003824", 1)
#' @export
plos <- function(doi, si.no, save.name=NULL, dir=NULL){
    #Argument handling
    if(!is.numeric(si.no))
        stop("'si.no' must be numeric")    
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name)){
        save.name <- paste(doi,si.no, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Find journal from DOI
    journals <- setNames(c("plosone", "plosbiology", "plosmedicine", "plosgenetics", "ploscompbiol", "plospathogens", "plosntds"), c("pone", "pbio", "pmed", "pgen", "pcbi", "ppat", "pntd"))
    journal <- gsub("[0-9\\.\\/]*", "", doi)
    journal <- gsub("journal", "", journal)
    if(sum(journal %in% names(journals)) != 1)
        stop("Unrecognised journal in DOI")
    journal <- journals[journal]

    #Download and return
    destination <- file.path(dir, save.name)
    url <- paste0("http://journals.plos.org/", journal, "/article/asset?unique&id=info:doi/", doi, ".s", formatC(si.no, width=3, flag="0"))
    result <- download.file(url, destination, quiet=TRUE)
    if(result != 0)
        stop("Error code", result, " downloading file; file may not exist")
    return(destination)
}

#' Downloads supplementary materials from Wiley journals
#' @param doi DOI of article
#' @param si.no which supplement (first, second, etc.) as printed in
#' the article, to download. Note that "Fig S1" is not valid; this
#' should be a number
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @author Will Pearse
#' @importFrom RCurl getURL
#' @examples
#' wiley("10.1111/ele.12437", 1)
#' @export
wiley <- function(doi, si.no, save.name=NULL, dir=NULL){
    #Argument handling
    if(!is.numeric(si.no))
        stop("'si.no' must be numeric")    
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name)){
        save.name <- paste(doi,si.no, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Download SI HTML page and find SI link
    html <- getURL(paste0("http://onlinelibrary.wiley.com/doi/", doi, "/suppinfo"))
    links <- gregexpr("(asset/supinfo/)[-0-9a-zA-Z\\.\\?\\=\\&\\,\\;]*", as.character(html), useBytes=FALSE)
    pos <- as.numeric(links[[si.no]])
    link <- substr(html, pos, pos+attr(links[[si.no]], "match.length")-1)
    url <- paste0("http://onlinelibrary.wiley.com/store/", doi, "/", link)

    #Download and return
    destination <- file.path(dir, save.name)
    result <- download.file(url, destination, quiet=TRUE)
    if(result != 0)
        stop("Error code", result, " downloading file; file may not exist")
    return(destination)
}

#' Downloads supplementary materials from FigShare
#' @param doi DOI of article
#' @param si.no which supplement (first, second, etc.) as printed in
#' the article, to download. Note that "Fig S1" is not valid; this
#' should be a number
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @author Will Pearse
#' @examples
#' figshare("10.6084/m9.figshare.979288", 1)
#' @export
figshare <- function(doi, si.no, save.name=NULL, dir=NULL){
    #Argument handling
    if(!is.numeric(si.no))
        stop("'si.no' must be numeric")    
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name)){
        save.name <- paste(doi,si.no, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Find, download, and return
    url <- .grep.url(paste0("http://dx.doi.org/", doi), "(http://figshare.com/articles/)[A-Za-z0-9_/]*")
    url <- .grep.url(url, "(http://files\\.figshare\\.com/)[-a-zA-Z0-9\\_/\\.]*", si.no)
    return(.download(url, dir, save.name))
}

#' Downloads supplementary materials from Ecological Archives
#' @param esa ESA code for the article (just below the title in the
#' manuscript)
#' @param si.name *name* of the file to be downloaded
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @author Will Pearse
#' @examples
#' esa.archives("E093-059", "myco_db.csv")
#' @export
esa.archives <- function(esa, si.name, save.name=NULL, dir=NULL){
    #Argument handling
    if(!is.character(si.name))
        stop("'si.no' must be a character")    
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name)){
        save.name <- paste(esa,si.name, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Download, and return
    esa <- gsub("-", "/", esa, fixed=TRUE)
    return(.download(paste0("http://esapubs.org/archive/ecol/", esa, "/", si.name), dir, save.name))
}

#' Downloads supplementary materials from Science
#' @param doi DOI of article
#' @param si.name *name* of the file to be downloaded
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @author Will Pearse
#' @examples
#' science("10.1126/science.1255768", "Appendix_BanksLeite_etal.txt")
#' @export
science <- function(doi, si.name, save.name=NULL, dir=NULL){
    #Argument handling
    if(!is.character(si.name))
        stop("'si.name' must be a character")    
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name)){
        save.name <- paste(doi,si.name, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Find, download, and return
    url <- paste0("http://www.sciencemag.org", .grep.url(paste0("http://www.sciencemag.org/lookup/doi/", doi), "(/content/)[0-9/]*"), "/suppl/DC1")
    url <- paste0("http://www.sciencemag.org", .grep.url(url, "(/content/suppl/)[A-Z0-9/\\.]*(Appendix_BanksLeite_etal.txt)"))
    return(.download(url, dir, save.name))
}

#' Downloads supplementary materials from Proceedings journals
#' @param doi DOI of article
#' @param vol volume of article
#' @param issue issue of article
#' @param si.no which supplement (first, second, etc.) as printed in
#' the article, to download. Note that "Fig S1" is not valid; this
#' should be a number
#' @param save.name a name for the file to download. If \code{NULL}
#' (default) this will be a combination of the DOI and SI number
#' @param dir directory to save file to. If \code{NULL} (default) this
#' will be a temporary directory created for your files
#' @author Will Pearse
#' @importFrom RCurl getURL
#' @examples
#' proceedings("10.1098/rspb.2015.0338", 282, 1811, 1)
#' @export
proceedings <- function(doi, si.no, vol, issue, save.name=NULL, dir=NULL){
    #Argument handling
    if(!is.numeric(si.no))
        stop("'si.no' must be numeric")    
    if(!is.null(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NULL")
    } else dir <- tempdir()
    if(is.null(save.name)){
        save.name <- paste(doi,si.no, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }

    #Find, download, and return
    journal <- .grep.text(doi, "(rsp)[a-z]")
    tail <- gsub(".", "", .grep.text(doi, "[0-9]+\\.[0-9]*", 2), fixed=TRUE)
    url <- paste0("http://", journal, ".royalsocietypublishing.org/content/", vol, "/", issue, "/", tail, ".figures-only")
    url <- paste0("http://rspb.royalsocietypublishing.org/", .grep.url(url, "(highwire/filestream)[a-zA-Z0-9_/\\.]*"))
    return(.download(url, dir, save.name))
}

#PNAS doesn't seem to have SI other than PDFs, so ignored
#url <- paste0("http://www.pnas.org",.grep.url(paste0("http://www.pnas.org/lookup/doi/",doi), "(/content/)[0-9/]*"),".abstract")
#nature
#frontiers
#cell (TREE)
#arXiv
