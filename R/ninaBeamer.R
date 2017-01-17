#' @title NINA beamer format.
#'
#' @description
#'  Provides an Rmarkdown template for creating a NINA presentation in PDF format, mimicking to
#'  the existing NINA Powerpoint template . The function is based on similar template functions
#'  in the package "rmarkdown" by RStudio, and uses their utility functions.
#'  Requires a working \code{LaTeX} installation. For Windows computers, install "MikTeX".
#'
#' @details
#' The resulting template can be processed most easily in Rstudio, but can be run
#'  in plain R using the \code{rmarkdown::render} function.
#'
#' @seealso \url{http://miktex.or/download} for windows installation of LaTeX backbone.
#'
#'
#' @inheritParams rmarkdown::beamer_presentation
#' @param ... Additional arguments to \code{rmarkdown::beamer_presentation}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "ninaBeamer", package = "NinaR")
#' }
#'
#' @export
ninaBeamer <- function(...,
                             keep_tex = TRUE,
                             md_extensions = c("-autolink_bare_uris","+header_attributes")) {
  inherit_beamer(...,
                       template = find_resource("nina_beamer", "template.tex"),
                       keep_tex = keep_tex,
                       md_extensions = md_extensions,
                       latex_engine = "xelatex")

}
