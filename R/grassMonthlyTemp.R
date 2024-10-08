#' grassMonthlyTemp
#'
#' Fetch monthly average temperatures from given points
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
#' @param type Type of data aggregation. "mean", "min", "max", "range", default is mean.
#'
#' @return Returns a data frame containing "x", "y", "site", "start" = starting point of record, "end" = end point of record (in this case none), and
#' "value" containing the monthly temperature values in requested aggregate form.
#' @author Stefan Blumentrath, Jens Astrom
#' @seealso \code{\link{grassMonthlyPrecip}, \link{grassDailyTemp}}
#' @examples
#' \dontrun{
#' grassConnect()
#' points <- data.frame("x" = 270877, "y" = 7039976, "site" = 1)
#' tmp <- grassMonthlyTemp(points = points, start_time = "2014-01-01", end_time = "2014-12-31")
#'
#' ## Get data just for first 6 months
#' tmp2 <- grassMonthlyTemp(points = points, start_time = "2014-01-01", end_time = "2014-12-31", where = "strftime('%m', start_time) <= '06'")
#' }
#' @export


grassMonthlyTemp <- function(points,
                             start_time,
                             end_time,
                             where = NULL,
                             type = c(
                               "mean",
                               "min",
                               "max",
                               "range"
                             )) {
  # Check that is is run on NINSRV16
  if (!checkMachine()) {
    stop("Must be run on NINA servers!")
  }

  if (!is.null(where)) {
    time_cond <- paste("(start_time >='",
      start_time,
      "' AND start_time < '",
      end_time,
      "')",
      " AND (",
      where,
      " )",
      sep = ""
    )
  } else {
    time_cond <- paste("start_time >='",
      start_time,
      "' AND start_time < '",
      end_time, "'",
      sep = ""
    )
  }

  type <- match.arg(type)
  selection <- paste("temperature_seNorge_1km_months_",
    type,
    "@gt_Meteorology_Norway_seNorge_temperature_months",
    sep = ""
  )

  # Get bounding box of all points
  max_x <- max(points$x)
  max_y <- max(points$y)
  min_x <- min(points$x)
  min_y <- min(points$y)
  dem <- "dem_10m_nosefi@g_Elevation_Fenoscandia"

  # set the computational region first to the raster map and extent of your points:
  rgrass::execGRASS("g.region",
    align = dem,
    n = as.character(max_y),
    s = as.character(min_y),
    e = as.character(max_x),
    w = as.character(min_x),
    flags = "p"
  )

  # Add mapset containing time series data
  rgrass::execGRASS("g.mapsets",
    operation = "add",
    mapset = "gt_Meteorology_Norway_seNorge_precipitation_months,gt_Meteorology_Norway_seNorge_temperature_months"
  )

  # Query time series at vector points, transfer result into R
  rgrass::execGRASS("t.connect", flags = "d")
  rgrass::execGRASS("g.region",
    align = "precipitation_1957_01_01@gt_Meteorology_Norway_seNorge_precipitation_days",
    n = as.character(max_y),
    s = as.character(min_y),
    e = as.character(max_x),
    w = as.character(min_x),
    flags = "p"
  ) # You can get the list of rasters in a time series using t.rast.list


  cat("This can take some time...")
  temp_monthly <- rgrass::execGRASS("t.rast.what",
    flags = c("n", "i", "overwrite", "verbose"),
    strds = selection,
    where = time_cond,
    nprocs = 10,
    Sys_input = paste(points$x, points$y, points$site, sep = " "),
    separator = ",",
    intern = TRUE
  )

  con <- textConnection(temp_monthly)
  out <- read.csv(con,
    header = TRUE
  )
  return(out)
}
