#' @details The examples probably give the best indication of how to
#' use this function. In general, just specify the DOI of the article
#' you want to download data from, and the number of the supplement
#' you want to download (1, 5, etc.). Proceedings, and Science journals
#' need you to give the filename of the supplement to
#' download. The file extensions (suffixes) of files are returned as
#' \code{suffix} attributes (see first example), which may be useful
#' if you don't know the format of the file you're downloading.
#'
#' For any DOIs not recognised (and if asked) the European PubMed
#' Central API is used to look up articles. What this database calls a
#' supplementary file varies by publisher; often they will simply be
#' figures within articles, but we (obviously) have no way to check
#' this at run-time. I strongly recommend you run any EPMC calls with
#' \code{list=TRUE} the first time, to see the filenames that EPMC
#' gives supplements, as these also often vary from what the authors
#' gave them. This may actually be a 'feature', not a 'bug', if you're
#' trying to automate some sort of meta-analysis.
#'
#' Below is a list of all the publishers this supports, and examples
#' of journals from them.
#'
#' \describe{
#' \item{auto}{Default. Use a cross-ref search
#' (\code{\link[rcrossref:cr_works]{cr_works}}) on the DOI to
#' determine the publisher.}
#' \item{plos}{Public Library of Science journals (e.g., PLoS One;)}
#' \item{wiley}{Wiley journals (e.g., Ecology Letters)}
#' \item{science}{Science magazine (e.g., Science Advances)}
#' \item{proceedings}{Royal Society of London journals (e.g.,
#' Proceedings of the Royal Society of London B). Requires
#' \code{vol} and \code{issue} of the article.}
#' \item{figshare}{Figshare}
#' \item{biorxiv}{Load from bioRxiv} 
#' \item{epmc}{Look up an article on the Europe PubMed Central, and
#' then download the file using their supplementary materials API.
#' See comments above in 'notes' about EPMC.}
#' \item{peerj}{PeerJ journals (e.g., PeerJ Preprints).}
#' \item{copernicus}{Copernicus Publications journals (e.g., Biogeosciences).
#' Only one supplemental is supported, which can be a zip archive or a PDF file. 
#' A numeric \code{si} parameter must be \code{1} to download the 
#' whole archive, which is saved using Copernicus naming scheme
#' (<journalname>-<volume>-<firstpage>-<year>-supplement.zip)
#' and \code{save.name} is ignored, or to download the PDF.
#' If \code{si} matches the name of the supplemental archive (i.e. uses the
#' Copernicus naming scheme), then the suppdata archive is not unzipped.
#' \code{si} may be the name of a file in that 
#' archive, so only that file is extracted and saved to \code{save.name}.}
#' }
