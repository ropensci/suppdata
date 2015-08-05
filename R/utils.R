#' Internal regexp functions
.grep.url <- function(url, regexp, which=1){
    html <- getURL(url)
    return(.grep.text(html, regexp, which))
}
.grep.text <- function(text, regexp, which=1){
    links <- gregexpr(regexp, text)
    pos <- as.numeric(links[[1]][which])
    return(substr(text, pos, pos+attr(links[[1]], "match.length")[which]-1))
}

#' Internal download function
.download <- function(url, dir, save.name, cache=TRUE){
    destination <- file.path(dir, save.name)
    if(cache==TRUE & file.exists(destination))
        return(destination)
    result <- download.file(url, destination, quiet=TRUE)
    if(result != 0)
        stop("Error code", result, " downloading file; file may not exist")
    return(destination)
}
