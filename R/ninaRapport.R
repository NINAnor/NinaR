#' @title NINA Report format.
#'
#' @description
#'  Provides an Rmarkdown template for creating a NINA Report, conforming to the
#'  existing NINA word template. The template is available in Rstudio through `New File ->
#'  R Markdown -> From Template` but can also be retrieved as shown in the example below.
#'
#'  This template requires a working \code{LaTeX} installation. For Windows computers, install "MikTeX".
#'  For Mac, install "MacTex". Linux machines usually have \code{LaTeX} available through their repositories. "texlive"
#'  is the preferred version for Ubuntu, and is installed on the N16 server and therefore
#'  available through the Rstudio server there.
#'
#' @details
#'  Retreive an ISBN number and reportnumber from the NINA library and fill in the relevant fields in the
#'  resulting template. The resulting template can be processed most easily in Rstudio, but can also be run
#'  in plain R using the \code{rmarkdown::render} function. The function is based on similar template functions in
#'  the package "rticles" by RStudio, and uses their utility functions.
#'
#' @seealso \url{http://github.com/RStudio/rticles} for other templates, and
#' \url{http://miktex.or/download} for windows installation and
#' \url{https://tug.org/mactex/} for Mac installation of LaTeX backbone.
#'
#'
#' @inheritParams rmarkdown::pdf_document
#' @param ... Additional arguments to \code{rmarkdown::pdf_document}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' # initiate a template
#' library(rmarkdown)
#' draft("MyReport.Rmd", template = "nina_rapport", package = "NinaR")
#'
#' #render an article manually
#' render("MyReport.Rmd", ninaRrapport.R())
#'
#' }
#'
#' @export
ninaRapport <- function(...,
                             keep_tex = TRUE,
                             md_extensions = c("-autolink_bare_uris","+header_attributes")) {
  fmt <- inherit_pdf_document(...,
                       template = find_resource("nina_rapport", "template.tex"),
                       keep_tex = keep_tex,
                       md_extensions = md_extensions
                       )

  fmt$pandoc$args <- c(fmt$pandoc$args, "--csl", "nina.csl")

  fmt

}
