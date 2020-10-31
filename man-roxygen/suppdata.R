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
#' of articles from them.
#'
#' \describe{
#' \item{auto}{Default. Use a cross-ref search
#' (\code{\link[rcrossref:cr_works]{cr_works}}) on the DOI to
#' determine the publisher.}
#' \item{plos}{Public Library of Science journals (e.g., PLoS One;
#' \url{https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0126524})}
#' \item{wiley}{Wiley journals (e.g.,
#' \url{https://onlinelibrary.wiley.com/doi/10.1111/ele.12289})}
#' \item{science}{Science magazine (e.g.,
#' \url{https://science.sciencemag.org/content/345/6200/1041/})}
#' \item{proceedings}{Royal Society of London journals (e.g.,
#' \url{https://royalsocietypublishing.org/doi/full/10.1098/rspb.2015.1215/}). Requires
#' \code{vol} and \code{issue} of the article.}
#' \item{figshare}{Figshare (e.g.,
#' \url{https://doi.org/10.6084/m9.figshare.979288.v1})}
#' \item{biorxiv}{Load from bioRxiv (e.g.,
#' \url{https://biorxiv.org/content/early/2015/09/11/026575})} 
#' \item{epmc}{Look up an article on the Europe PubMed Central, and
#' then download the file using their supplementary materials API
#' (\url{https://europepmc.org/restfulwebservice}). See comments above
#' in 'notes' about EPMC.}
#' \item{peerj}{PeerJ journals (e.g., \url{https://doi.org/10.7717/peerj.3006})
#' and PeerJ Preprints (e.g., \url{https://doi.org/10.7287/peerj.preprints.26561v1})}
#' \item{copernicus}{Copernicus Publications journals (e.g., 
#' \url{https://doi.org/10.5194/bg-14-1739-2017}), see
#' \url{https://publications.copernicus.org/open-access_journals/open_access_journals_a_z.html}
#' for a full list of journals. Only one supplemental is supported,
#' which can be a zip archive or a PDF file. 
#' A numeric \code{si} parameter must be \code{1} to download the 
#' whole archive, which is saved using Copernicus naming scheme
#' (<journalname>-<volume>-<firstpage>-<year>-supplement.zip)
#' and \code{save.name} is ignored, or to download the PDF.
#' If \code{si} matches the name of the supllemental archive (i.e. uses the
#' Copernics naming scheme), then the suppdata archive is not unzipped.
#' \code{si} may be the name of a file in that 
#' archive, so only that file is extracted and saved to \code{save.name}.}
#' }
