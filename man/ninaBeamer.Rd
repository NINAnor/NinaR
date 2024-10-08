% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ninaBeamer.R
\name{ninaBeamer}
\alias{ninaBeamer}
\title{NINA beamer format.}
\usage{
ninaBeamer(
  ...,
  keep_tex = TRUE,
  md_extensions = c("-autolink_bare_uris", "+header_attributes")
)
}
\arguments{
\item{...}{Additional arguments to \code{rmarkdown::beamer_presentation}}

\item{keep_tex}{Keep the intermediate tex file used in the conversion to PDF.
Note that this argument does not control whether to keep the auxiliary
files (e.g., \file{.aux}) generated by LaTeX when compiling \file{.tex} to
\file{.pdf}. To keep these files, you may set \code{options(tinytex.clean =
FALSE)}.}

\item{md_extensions}{Markdown extensions to be added or removed from the
default definition of R Markdown. See the \code{\link[rmarkdown]{rmarkdown_format}} for
additional details.}
}
\value{
R Markdown output format to pass to
  \code{\link[rmarkdown:render]{render}}
}
\description{
Provides an Rmarkdown template for creating a NINA presentation in PDF format, mimicking to
 the existing NINA Powerpoint template . The function is based on similar template functions
 in the package "rmarkdown" by RStudio, and uses their utility functions.
 Requires a working \code{LaTeX} installation. For Windows computers, install "MikTeX".
}
\details{
The resulting template can be processed most easily in Rstudio, but can be run
 in plain R using the \code{rmarkdown::render} function.
}
\examples{
\dontrun{
library(rmarkdown)
draft("MyArticle.Rmd", template = "ninaBeamer", package = "NinaR")
}

}
\seealso{
\url{http://miktex.or/download} for windows installation of LaTeX backbone.
}
