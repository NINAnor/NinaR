% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ninaLogoPalette.R
\name{ninaLogoPalette}
\alias{ninaLogoPalette}
\title{ninaLogoPalette}
\usage{
ninaLogoPalette()
}
\arguments{
\item{Function}{accepts no params}
}
\value{
Returns 3 logo colors
}
\description{
Creates a NINA logo color palette
}
\details{
Colors conform to the 'NINA Grafisk handbok'
}
\examples{
set.seed(12345)
barplot(runif(3), col=ninaLogoPalette())
}
\author{
Jens Åström, Kari Sivertsen
}
\seealso{
\code{\link{NinaPalette}}
}
