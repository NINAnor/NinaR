#' getGrassMonthlyPrecip
#'
#' Fetch monthly average precipitation from given points
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function retreives monthly temperature values from the GRASS database on NINSRV16. The data is distributed
#' by http://www.met.no, see ftp://ftp.met.no/projects/klimagrid/ for information.
#'
#'
#' @param points Data frame containing latitude and longitude in etrs89 / utm zone 33n (EPSG:25833). In practice, this is identical to UTM33n
#' The data frame should have columns named "x" and "y" for the coordinates and a column named "site" with unique integer values.
#' @param start_time Start time for data selection, in format "YYYY-MM-DD".
#' @param end_time End time for data selection, in format "YYYY-MM-DD".
#' @param where string of SQL that is interpreted as a "WHERE" clause. Typically used to specify a subset of the data, see example.
#' @param type Type of data aggregation.  "sum" and "avg" allowed, default is sum
#'
#' @return Returns a data frame containing "x", "y", "site", "start" = starting point of record, "end" = end point of record (in this case none), and
#' "value" containing the monthly precipitation values in requested aggregate form.
#' @author Stefan Blumentrath, Jens Astrom
#' @seealso \code{\link{getGrassMonthlyTemp}, \link{getGrassDailyPrecip}}
#' @examples
#' \dontrun{
#' connectGrass()
#' points <- data.frame("x" = 270877, "y" = 7039976, "site" = 1)
#' tmp <- getGrassMonthlyPrecip(points = points, start_time = "2014-01-01", end_time = "2014-12-31")
#'
#' ##Get data just for first 6 months
#' tmp2 <- getGrassMonthlyPrecip(points = points, start_time = "2014-01-01", end_time = "2014-12-31", where="strftime('%m', start_time) <= '06'")
#'
#' }
#' @export


getGrassMonthlyPrecip <- function(points, start_time, end_time, where=NULL, type=c("sum", "avg")){

  #Check that is is run on NINSRV16
  host<-NULL
  try(host <- system("hostname", intern = T))
  if(host != "NINSRV16"){
    stop("Must be run on Ninsrv16!")
  }


  if(!is.null(where)){
    time_cond <- paste("(start_time >='", start_time, "' AND start_time < '", end_time, "')" , " AND (", where," )", sep="")
  } else
    time_cond <- paste("start_time >='", start_time, "' AND start_time < '", end_time, "'" ,sep="")

  type <- match.arg(type)
  selection <- paste("precipitation_seNorge_1km_", type, "@gt_Meteorology_Norway_seNorge_precipitation_months", sep="")

  # Get bounding box of all points
  max_x <- max(points$x)
  max_y <- max(points$y)
  min_x <- min(points$x)
  min_y <- min(points$y)

  # set the computational region first to the raster map and extent of your points:
  execGRASS("g.region", align="dem_10m_nosefi@PERMANENT", n=as.character(max_y), s=as.character(min_y), e=as.character(max_x), w=as.character(min_x), flags = "p")

  # Add mapset containing time series data
  execGRASS("g.mapsets", operation = "add", mapset = "gt_Meteorology_Norway_seNorge_precipitation_months,gt_Meteorology_Norway_seNorge_temperature_months")

  # Query time series at vector points, transfer result into R
  execGRASS("t.connect", flags = "d")
  execGRASS("g.region", align="precipitation_1957_01_01@gt_Meteorology_Norway_seNorge_precipitation_days", n=as.character(max_y), s=as.character(min_y), e=as.character(max_x), w=as.character(min_x), flags = "p") # You can get the list of rasters in a time series using t.rast.list


  cat("This can take some time...")
  temp_monthly <- execGRASS("t.rast.what", flags=c("n", "i", "overwrite", "verbose"),
                          strds=selection,
                          where=time_cond, nprocs=10, Sys_input=paste(points$x, points$y, points$site, sep=' '), separator=',', intern=TRUE)

  con <- textConnection(temp_monthly)
  out <- read.csv(con, header=TRUE)
  return(out)
}
