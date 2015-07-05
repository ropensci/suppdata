
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

    #Download
    destination <- file.path(dir, save.name)
    url <- paste0("http://journals.plos.org/", journal, "/article/asset?unique&id=info:doi/", doi, ".s", formatC(si.no, width=3, flag="0"))
    result <- download.file(url, destination, quiet=TRUE)
    if(result != 0)
        stop("Error code", result, " downloading file; file may not exist")
    return(destination)
}
