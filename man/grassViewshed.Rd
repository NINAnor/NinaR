% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grassViewshed.R
\name{grassViewshed}
\alias{grassViewshed}
\title{grassViewshed}
\usage{
grassViewshed(
  xycoords,
  return = TRUE,
  dist = 100,
  observer_elevation = 1.75,
  target_elevation = 0
)
}
\arguments{
\item{xycoords}{data frame containing columns "x" and "y" containint longitude and latitude in EPSG:25833}

\item{return}{logical. Indicating whether the map should be returned instead of just created (default=TRUE)}

\item{dist}{numerical.}

\item{observer_elevation}{numerical. Sets the height of the observer above the dem.}

\item{target_elevation}{numerical. The user can change this using option target_elevation to determine
if objects of a given height would be visible.}
}
\value{
A SpatVector object (terra)
}
\description{
Calculate a viewshed from a given point based on a 10m DEM
}
\details{
Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
The function returns (optional) an SP class dataframe with a viewshed, i.e. area visible from a point.
}
\examples{
\dontrun{
test_view <- grassViewshed(
  xycoords = data.frame(
    "x" = 310400,
    "y" = 6991600
  ),
  dist = 1000
)


terra::plot(test_view)

test_view_sf <- sf::st_as_sf(test_view)
ggplot(test_view_sf) +
  geom_sf(aes(fill = value)) +
  scale_fill_nina(discrete = FALSE)
}
}
\author{
Jens Åström
}
