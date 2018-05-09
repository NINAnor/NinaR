#' grassDailyTemp
#'
#' Fetch daily average temperatures from given points
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function retreives daily temperature means from the GRASS database on NINSRV16. The data is distributed
#' by http://www.met.no, see ftp://ftp.met.no/projects/klimagrid/ for information.
#'
#'
#' @param points Data frame containing latitude and longitude in etrs89 / utm zone 33n (EPSG:25833). In practice, this is identical to UTM33n
#' The data frame should have columns named "x" and "y" for the coordinates and a column named "site" with unique integer values.
#' @param start_time Start time for data selection, in format "YYYY-MM-DD".
#' @param end_time End time for data selection, in format "YYYY-MM-DD".
#' @param where string of SQL that is interpreted as a "WHERE" clause. Typically used to specify a subset of the data, see example.
#'
#' @return Returns a data frame containing "x", "y", "site", "start" = starting point of record, "end" = end point of record (in this case none), and
#' "value" containing the daily average temperature.
#' @author Stefan Blumentrath, Jens Astrom
#' @seealso \code{\link{grassDailyPrecip}}
#' @examples
#' \dontrun{
#' connectGrass()
#' points <- data.frame("x" = 270877, "y" = 7039976, "site" = 1)
#' tmp <- grassDailyTemp(points = points, start_time = "2014-01-01", end_time = "2014-12-31")
#'
#' ##Get values from middle of march to middle of april for two years
#' tmp2 <- grassDailyTemp(points = points, start_time = "2013-01-01", end_time = "2014-12-31",
#'  where="(strftime('%m', start_time) = '03' AND strftime('%d', start_time) >= '15') OR
#'  (strftime('%m', start_time) = '04' AND strftime('%d', start_time) <= '15')")
#' }
#' @export


grassDailyTemp <- function(points, start_time, end_time, where=NULL){

  #Check that is is run on NINSRV16
  #Check that is is run on NINSRV16
  if(!checkMachine()){
    stop("Must be run on NINA servers!")
  }

  if(!is.null(where)){
    time_cond <- paste("(start_time >='", start_time, "' AND start_time < '", end_time, "')" , " AND (", where," )", sep="")
    } else
  time_cond <- paste("start_time >='", start_time, "' AND start_time < '", end_time, "'" ,sep="")

  # Get bounding box of all points
  max_x <- max(points$x)
  max_y <- max(points$y)
  min_x <- min(points$x)
  min_y <- min(points$y)

  # set the computational region first to the raster map and extent of your points:
  execGRASS("g.region", align="dem_10m_nosefi@PERMANENT", n=as.character(max_y), s=as.character(min_y), e=as.character(max_x), w=as.character(min_x), flags = "p")

  # Add mapset containing time series data
  execGRASS("g.mapsets", operation = "add", mapset = "gt_Meteorology_Norway_seNorge_precipitation_days,gt_Meteorology_Norway_seNorge_temperature_days")

  # Query time series at vector points, transfer result into R
  execGRASS("t.connect", flags = "d")
  execGRASS("g.region", align="precipitation_1957_01_01@gt_Meteorology_Norway_seNorge_precipitation_days", n=as.character(max_y), s=as.character(min_y), e=as.character(max_x), w=as.character(min_x), flags = "p") # You can get the list of rasters in a time series using t.rast.list


  cat("This can take some time...")
  temp_daily <- execGRASS("t.rast.what", flags=c("n", "i", "overwrite", "verbose"),
                          strds="temperature_seNorge_1km_days@gt_Meteorology_Norway_seNorge_temperature_days",
                          where=time_cond, nprocs=10, Sys_input=paste(points$x, points$y, points$site, sep=' '), separator=',', intern=TRUE)

  con <- textConnection(temp_daily)
  out <- read.csv(con, header=TRUE)
  return(out)
}
