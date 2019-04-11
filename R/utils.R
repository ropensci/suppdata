#' @importFrom rcrossref cr_works
.suppdata.pub <- function(x){
    if(!is.character(x))
        stop("'x' must be a character")

    #Doing the check here saves one internet call
    if(grepl("figshare", x))
        return("figshare")
    if(grepl("dryad", x))
        return("dryad")
    pub <- cr_works(x)$data

    if(is.null(pub))
        stop("Cannot find publisher for DOI: ", x)
    if(pub$prefix=="http://id.crossref.org/prefix/10.0000")
        stop("Cannot find publisher for DOI: ", x)
    
    return(.grep.text(pub$member, "[0-9]+"))
}

.suppdata.func <- function(x) {
    #Check by code, return if found
    output <- switch(x, 
                     "340" = .suppdata.plos,
                     "311" = .suppdata.wiley,
                     "221" = .suppdata.science,
                     "175" = .suppdata.proceedings,
                     "246" = .suppdata.biorxiv,
                     "4443" = .suppdata.peerj,
                     "3145" = .suppdata.copernicus,
                     "1968" = .suppdata.mdpi
                     )
    if(!is.null(output))
        return(output)

    #Check by letter code
    output <- switch(x, 
                     "plos" = .suppdata.plos,
                     "wiley" = .suppdata.wiley,
                     "science" = .suppdata.science,
                     "proceedings" = .suppdata.proceedings,
                     "figshare" = .suppdata.figshare,
                     "esa_data_archives" = .suppdata.esa_data_archives,
                     "esa_archives" = .suppdata.esa_archives,
                     "biorxiv" = .suppdata.biorxiv,
                     "epmc" = .suppdata.epmc,
                     "dryad" = .suppdata.dryad,
                     "peerj" = .suppdata.peerj,
                     "copernicus" = .suppdata.copernicus,
                     "mdpi" = .suppdata.mdpi
                     )
    #If all else fails, try EPMC
    if(is.null(output))
        output <- .suppdata.epmc
    return(output)
}

# Internal regexp functions
.grep.url <- function(url, regexp, which=1){
    html <- as.character(GET(url))
    return(.grep.text(html, regexp, which))
}
.grep.text <- function(text, regexp, which=1){
    links <- gregexpr(regexp, text)
    if(which > length(links[[1]]))
        stop(
            "SI number '", which, "' greater than number of detected SIs (",
            length(links[[1]]), ")"
        )
    pos <- as.numeric(links[[1]][which])
    return(substr(text, pos, pos+attr(links[[1]], "match.length")[which]-1))
}
.file.suffix <- function(text, max.length=4){
    suffix <- .grep.text(text, "[a-zA-Z]+$")
    if(nchar(suffix) <= max.length & nchar(suffix) > 0)
        return(suffix)
    return(NA)
}

# Internal download function
#' @importFrom utils download.file
.download <- function(url, dir, save.name, cache=TRUE, suffix=NULL, zip=FALSE){
    destination <- file.path(dir, save.name)
    if(is.null(suffix))
        suffix <- .file.suffix(url, 4)
    
    if(cache==TRUE & file.exists(destination)){
        if(!is.na(suffix))
            attr(destination, "suffix") <- suffix
        return(destination)
    }
    # Must download zips *manually* in binary mode, or Windows machines will error
    if(zip){
        result <- download.file(url, destination, quiet=TRUE, mode="wb")
    } else {
        result <- download.file(url, destination, quiet=TRUE)
    }
    if(result != 0)
        stop("Error code", result, " downloading file; file may not exist")
    
    if(!is.na(suffix))
        attr(destination, "suffix") <- suffix
    return(destination)
}

# Internal unzip function
#' @importFrom utils unzip
.unzip <- function(zip, dir, save.name, cache, si, list=FALSE){
    files <- unzip(zip, list=TRUE)
    if(list){
        cat("Files in ZIP:")
        print(files)
    }
    if(!si %in% files$Name)
        stop("Required file not in zipfile ", zip)
    file <- unzip(zip, si)
    file.rename(file, file.path(dir, save.name))
    return(file.path(dir, save.name))
}

# Internal URL 'redirect' function
.url.redir <- function(x)
    return(GET(x)$url)

.tmpdir <- function(dir){
    if(!is.na(dir)){
        if(!file.exists(dir))
            stop("'dir' must exist unless NA")
    } else dir <- tempdir()
    return(dir)
}
.save.name <- function(doi, save.name, file){
    if(is.na(save.name)){
        save.name <- paste(doi,file, sep="_")
        save.name <- gsub(.Platform$file.sep, "_", save.name, fixed=TRUE)
    }
    return(save.name)
}
#Expanding arguments when handling ft-classes
.fix.param <- function(x, param, name){
    if(length(x) != length(param)){
        if((length(x) %% length(param)) != 0)
            stop("length of ", "name (", length(param),
                 ") is incompatible with 'x' (", length(x), ")")
        param <- rep(param, length(x))
    }
    return(param)
}
