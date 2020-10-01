.suppdata.plos <- function(doi, si, save.name=NA, dir=NA, cache=TRUE, ...){
    #Argument handling
    if(!is.numeric(si))
        stop("PLoS download requires numeric SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)
    
    #Find journal from DOI
    journals <- setNames(c("plosone", "plosbiology", "plosmedicine",
                           "plosgenetics", "ploscompbiol", "plospathogens",
                           "plosntds"),
                         c("pone", "pbio", "pmed", "pgen", "pcbi",
                           "ppat", "pntd"))
    
    journal <- gsub("[0-9\\.\\/]*", "", doi)
    journal <- gsub("journal", "", journal)
    if(sum(journal %in% names(journals)) != 1)
        stop("Unrecognised PLoS journal in DOI ", doi)
    journal <- journals[journal]

    # Download and return
    url <- paste0("https://journals.plos.org/", journal,
                  "/article/asset?unique&id=info:doi/", doi, ".s",
                  formatC(si, width=3, flag="0"))
    return(.download(url, dir, save.name, cache))
}

#' @importFrom httr timeout GET
#' @importFrom xml2 read_html xml_attr xml_find_all
.suppdata.wiley <- function(doi, si, save.name=NA, dir=NA,
                            cache=TRUE, timeout=10, ...){
    #Argument handling
    if(!is.numeric(si))
        stop("Wiley download requires numeric SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)

    # Download SI HTML page and find SI link
    html <- tryCatch(as.character(
        GET(paste0("https://onlinelibrary.wiley.com/doi/full/", doi),
            httr::timeout(timeout))), silent=TRUE, error = function(x) NA)
    
    links <- gregexpr('downloadSupplement\\?doi=[0-9a-zA-Z\\%;=\\.&-]+', html)
    # Check to see if we've failed (likely because it's a weird data journal)
    if(links[[1]][1] == -1){
        html <- tryCatch(as.character(
            GET(paste0("https://onlinelibrary.wiley.com/doi/abs/", doi),
                httr::timeout(timeout))), silent=TRUE, error = function(x) NA)
        links <- gregexpr('downloadSupplement\\?doi=[0-9a-zA-Z\\%;=\\.&-]+', html)
        if(links[[1]][1] == -1)
            stop("Cannot find SI for this article")
    }
    links <- substring(html, as.numeric(links[[1]]),
                       links[[1]]+attr(links[[1]],"match.length")-1)
    links <- paste0("https://onlinelibrary.wiley.com/action/", links)

    if(si > length(links))
        stop("SI number '", si, "' greater than number of detected SIs (",
             length(links), ")")
    url <- links[si]
    
    #Download and return
    return(.download(url, dir, save.name, cache))
}

#' @importFrom jsonlite fromJSON
#' @importFrom xml2 xml_text xml_find_first
#' @importFrom httr content
.suppdata.figshare <- function(doi, si, save.name=NA, dir=NA,
                               cache=TRUE, ...){
    #Argument handling
    if(!is.numeric(si))
        stop("FigShare download requires numeric SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)
    
    #Find, download, and return
    result <- .grep.url(paste0("https://doi.org/", doi), "https://ndownloader.figshare.com/files/[0-9]*", si)
    return(.download(result, dir, save.name, cache, suffix=NULL))
}

.suppdata.esa_data_archives <- function(esa, si, save.name=NA, dir=NA,
                                        cache=TRUE, ...){
    #Argument handling
    if(!is.character(si))
        stop("ESA Data Archives download requires character SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(esa, save.name, si)

    #Download, and return
    esa <- gsub("-", "/", esa, fixed=TRUE)
    return(.download(paste0("http://esapubs.org/archive/ecol/", esa, "/data",
                            "/", si), dir, save.name, cache))
}
.suppdata.esa_archives <- function(esa, si, save.name=NA, dir=NA,
                                   cache=TRUE, ...){
    #Argument handling
    if(!is.character(si))
        stop("ESA Archives download requires character SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(esa, save.name, si)

    #Download, and return
    esa <- gsub("-", "/", esa, fixed=TRUE)
    return(.download(paste0("http://esapubs.org/archive/ecol/",esa,"/",si),
                     dir, save.name, cache))
}

.suppdata.science <- function(doi, si, save.name=NA, dir=NA,
                              cache=TRUE, ...){
    #Argument handling
    if(!is.character(si))
        stop("Science download requires character SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)

    #Find, download, and return
    url <- paste0("https://www.sciencemag.org",
                  .grep.url(paste0("https://www.sciencemag.org/lookup/doi/",doi),
                            "(/content/)[0-9/]*"), "/suppl/DC1")
    url <- paste0("https://www.sciencemag.org",
                  .grep.url(url, "(/content/suppl/)[A-Z0-9/\\.]*"))
    return(.download(url, dir, save.name, cache))
}

.suppdata.proceedings <- function(doi, si, vol, issue, save.name=NA, dir=NA,
                                  cache=TRUE, ...){
    #Argument handling
    if(!is.numeric(si))
        stop("Proceedings download requires numeric SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)
    
    #Find, download, and return
    journal <- .grep.text(doi, "(rsp)[a-z]")
    tail <- gsub(".", "", .grep.text(doi, "[0-9]+\\.[0-9]*", 2), fixed=TRUE)
    url <- paste0("https://", journal, ".royalsocietypublishing.org/content/",
                  vol, "/", issue, "/", tail, ".figures-only")
    url <- paste0("https://rspb.royalsocietypublishing.org/",
                  .grep.url(url, "(highwire/filestream)[a-zA-Z0-9_/\\.]*"))
    return(.download(url, dir, save.name))
}

#' @importFrom xml2 xml_text xml_find_first read_xml
.suppdata.epmc <- function(doi, si, save.name=NA, dir=NA,
                           cache=TRUE, list=FALSE, ...){
    #Argument handling
    if(!is.character(si))
        stop("EPMC download requires character SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)
    zip.save.name <- .save.name(doi, NA, "raw_zip.zip")
    
    #Find, download, and return
    pmc.id <- xml2::xml_text(xml2::xml_find_first(xml2::read_xml(
        paste0("https://www.ebi.ac.uk/europepmc/webservices/rest/search/query=",
               doi)), ".//pmcid"))
    url <- paste0("https://www.ebi.ac.uk/europepmc/webservices/rest/",
                  pmc.id[[1]], "/supplementaryFiles")
    zip <- tryCatch(.download(url,dir,zip.save.name,cache,zip=TRUE),
                    error=function(x)
                        stop("Cannot find SI for EPMC article ID ",pmc.id[[1]]))
    return(.unzip(zip, dir, save.name, cache, si, list))
}

.suppdata.biorxiv <- function(doi, si, save.name=NA, dir=NA,
                              cache=TRUE, ...){
    #Argument handling
    if(!is.numeric(si))
        stop("bioRxiv download requires numeric SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)
    
    #Find, download, and return
    url <- paste0(.url.redir(paste0("https://doi.org/", doi)), ".figures-only")
    file <- .grep.url(url, "/highwire/filestream/[a-z0-9A-Z\\./_-]*", si)
    return(.download(.url.redir(paste0("https://biorxiv.org",file)),
                     dir, save.name, cache))
}

#' @importFrom utils URLencode
.suppdata.dryad <- function(doi, si, save.name=NA, dir=NA,
                            cache=TRUE, ...){
    #Argument handling
    if(!is.character(si))
        stop("DataDRYAD download requires character SI info")
    dir <- .tmpdir(dir)
    save.name <- .save.name(doi, save.name, si)
    
    #Find, download, and return
    html <- xml2::read_html(content(GET(paste0("https://doi.org/", doi)), "text"))
    url <- paste0("https://datadryad.org",
                  xml_attr(xml_find_first(html, paste0("//a[@title='",si,"']")), "href")
                  )
    return(.download(url, dir, save.name, cache))
}

#' @importFrom xml2 xml_text xml_find_all xml_find_first read_xml
#' @importFrom rcrossref cr_works
.suppdata.peerj <- function(doi, si, save.name=NA, dir=NA,
                              cache=TRUE, ...){
  si_id <- "supp-1"
  #Argument handling
  if (is.character(si) && startsWith(si, "supp-"))
    si_id <- si
  else if (is.numeric(si))
    si_id <- paste0("supp-", si)
  else stop("PeerJ download requires numeric SI info or character starting with 'supp-'.")
  
  dir <- .tmpdir(dir)
  save.name <- .save.name(doi, save.name, si_id)
  
  #Get XML metadata of article
  crossref_links <- rcrossref::cr_works(dois = doi)$data$link[[1]]
  xml_url <- crossref_links[which(crossref_links$content.type == "application/xml"),1]$URL
  xml_metadata <- xml2::read_xml(xml_url)
  peerj_id <- xml2::xml_text(xml2::xml_find_first(xml_metadata, paste0(".//article-id[@pub-id-type='publisher-id']")))
  
  #Find download URL
  xml_si <- xml2::xml_find_first(xml_metadata, paste0(".//supplementary-material[@id='", si_id, "']"))
  si_url <- xml2::xml_attr(xml_si, "href")
  
  # Download and return
  tryCatch(return(.download(url = si_url,
                            dir = dir,
                            save.name = save.name,
                            cache = cache
                            # leave suffix detection to .download
                            )),
                  error = function(x) {
                    stop("Cannot download SI for Peerj ", peerj_id, ": ", x)
                    })
}

#' @importFrom xml2 read_html xml_find_first
.suppdata.copernicus <- function(doi, si=1, save.name=NA, dir=NA,
                           cache=TRUE, list=FALSE, ...){
  # Copernicus supports one supplemental file, a zip archive or a PDF
  # If si is numeric, the full archive is downloaded and unzipped, unless si is the supplement archive name. 
  # If si is a character, it must be the name of a file in the suppdata archive.
  
  #Argument handling
  if (is.numeric(si) && si != 1)
    stop("Copernicus only supports one supplemental archive, a numeric si must be '1'")
  save.name <- .save.name(doi, save.name, si)
  zip.save.name <- paste0(unlist(strsplit(x = doi,
                                          split = "/"))[[2]],
                          "-supplement.zip")
  dir <- .tmpdir(dir)
  
  #Find link in the HTML, download, unzip if a zip and not asking to leave it, and return
  #(alternatively could parse DOI and construct a well-known URL, but then we would not 
  #check for existence of a supplement)
  cop_landing_page <- xml2::read_html(x = paste0("https://doi.org/", doi))
  url <- xml2::xml_attr(x = xml2::xml_find_first(x = cop_landing_page, xpath = ".//a[text()='Supplement']"),
                   attr = "href")
  if (is.na(url))
    stop("No supplement found for article ", doi)
  
  # distinguish pdf or zip via URL suffix
  if (endsWith(x = url, suffix = "zip")) {
    zip <- tryCatch(.download(url, dir, zip.save.name, cache, zip=TRUE),
                    error = function(x)
                      stop("Cannot download supplemental zip for article ", doi))
    
    if (is.numeric(si)) {
      # unpack zip
      output_dir <- file.path(dir, tools::file_path_sans_ext(save.name))
      files <- unzip(zipfile = zip, exdir = output_dir)
      if (list) {
        cat("Files in ZIP:")
        print(files)
      }
      return(file.path(output_dir))
    }
    else if (si == zip.save.name) {
      # return only zip file path
      return(file.path(dir, zip.save.name))
    }
    else {
      # return only one file from the archive
      return(.unzip(zip, dir, save.name, cache, si, list))
    }
  }
  else if (endsWith(x = url, suffix = "pdf")) {
    tryCatch(return(.download(url = url,
                              dir = dir,
                              save.name = save.name,
                              cache = cache
                              # leave suffix detection to .download
    )),
    error = function(x) {
      stop("Cannot download pdf for Copernicus using ", url, " : ", x)
    })
  }
  else {
    stop("Unsupported file extension in URL, only zip and pdf are supported but have ", url)
  }
}

#' @importFrom xml2 read_html xml_find_first xml_parent xml_text
#' @importFrom rcrossref cr_works
.suppdata.mdpi <- function(doi, si=1, save.name=NA, dir=NA,
                            cache=TRUE, ...){
  si_id <- "s1"
  if (is.character(si))
    stop("MDPI only supports numeric SI info.")
  else if (is.numeric(si))
    si_id <- paste0("s", si)
  
  dir <- .tmpdir(dir)
  save.name <- .save.name(doi, save.name, si_id)
  
  crossref_links <- rcrossref::cr_works(dois = doi)$data$link[[1]]
  pdf_url <- crossref_links[which(endsWith(crossref_links$URL, "/pdf")),1]$URL
  base_url <- substr(pdf_url, 0, nchar(pdf_url) - 3)
  si_url <- paste0(base_url, si_id)
  
  # get file type from HTML
  article_landing_page <- xml2::read_html(x = base_url)
  si_relative_href <- paste0("/", httr::parse_url(si_url)$path)
  si_paragraph <- xml2::xml_parent(
    xml2::xml_find_first(x = article_landing_page, xpath = paste0(".//a[@href='", si_relative_href, "']"))
  )
  
  if (is.na(si_paragraph))
    stop("No SI with id ", si, " found with URL ", si_url)
  
  # match content within bracket before , in the text in the paragraph
  paragraph_text <- regmatches(x = xml2::xml_text(si_paragraph),
                               m = regexpr(pattern = "\\((.*),",
                                           text = xml2::xml_text(si_paragraph)))
  # strip matched ( and ,
  si_type <- tolower(substr(x = paragraph_text, start = 2, stop = nchar(paragraph_text) - 1))
  
  # Download and return
  tryCatch(return(.download(url = si_url,
                            dir = dir,
                            save.name = save.name,
                            cache = cache,
                            suffix = si_type
  )),
  error = function(x) {
    stop("Cannot download SI for MDPI ", doi, " using ", si_url, " : ", x)
  })
}

#' @importFrom xml2 read_html xml_find_first
.suppdata.jstatsoft <- function(doi, si=1, save.name=NA, dir=NA,
                                 cache=TRUE, list=FALSE, ...){
  # If si is numeric, the number es ordered on the website is used. 
  # If si is a character, it must be the name of a supplement file
  
  #Find supplement table in the HTML and create list of file names and download links
  article_page <- xml2::read_html(x = paste0("https://doi.org/", doi))
  supplement_table_rows <- xml2::xml_find_all(x = article_page, xpath = ".//table[contains(@class, 'supplementfiles')]/tr")
  supplements <- sapply(X = supplement_table_rows, FUN = function(row) {
    supplement <- xml2::xml_contents(xml2::xml_children(row))
    url <- xml2::xml_attr(x = supplement[3], attr = "href")
    names(url) <- strsplit(x = xml2::xml_text(supplement[[1]]), split = ":")[[1]][[1]]
    url
  })
  
  url <- NA
  if (is.numeric(si) || is.character(si)) {
    url <- supplements[si]
  }
  
  if (is.na(url))
    stop("No supplement found for article ", doi)
  
  if (save.name == .save.name(doi, NA, si))
    save.name <- .save.name(doi, names(url), si)
  dir <- .tmpdir(dir)
  
  tryCatch(return(.download(url = url,
                            dir = dir,
                            save.name = save.name,
                            cache = cache
  )),
  error = function(x) {
    stop("Cannot download pdf for Copernicus using ", url, " : ", x)
  })
}

