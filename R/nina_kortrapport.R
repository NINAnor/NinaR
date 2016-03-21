#' @title NINA kortrapport format.
#'
#' @description
#'  Provides an Rmarkdown template for creating a NINA "kortrapport", conforming to existing NINA
#'  word template . The function is based on similar template functions in the package "rticles" by
#'  RStudio, and uses their utility functions.
#'  Requires a working \code{LaTeX} installation. For Windows computers, install "MikTeX".
#'
#' @details
#'  Retreive an ISBN number and reportnumber from the NINA library and fill in the relevant fields in the
#'  resulting template. The resulting template can be processed most easily in Rstudio, but can be run
#'  in plain R using the \code{rmarkdown::render} function.
#'
#' @seealso \url{http://github.com/RStudio/rticles} for other templates, and
#' \url{http://miktex.or/download} for windows installation of LaTeX backbone.
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
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "nina_kortrapport", package = "NinaR")
#' }
#'
#' @export
nina_kortrapport <- function(...,
                             keep_tex = TRUE,
                             md_extensions = c("-autolink_bare_uris")) {
  inherit_pdf_document(...,
                       template = find_resource("nina_kortrapport", "template.tex"),
                       keep_tex = keep_tex,
                       md_extensions = md_extensions,
                       latex_engine = "xelatex")
}
