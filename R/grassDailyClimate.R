#' grassDailyClimate
#'
#' Fetch daily climate data for given points (coordinates)
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function retreives daily precipitation sums from the GRASS database on NINSRV16. The data is distributed
#' by http://www.met.no, see ftp://ftp.met.no/projects/klimagrid/ for information.
#'
#'
#' @param points Data frame containing latitude and longitude in etrs89 / utm zone 33n (EPSG:25833). In practice, this is identical to UTM33n
#' The data frame should have columns named "x" and "y" for the coordinates and a column named "site" with unique integer values.
#' @param variables One or more of the available climate variables, currently: Evapotranspiration, FreshSnow, FreshSnowDepth, GroundWaterCondition, Precipitation, RainOnSnow, Runoff, SnowAge, SnowAmount, SnowDepth, SnowFreeWaterContent, SnowMelt, Temperature, WaterCapacitySoil, WaterSaturationSoil.
#' @param start_time Start time for data selection, in format "YYYY-MM-DD".
#' @param end_time End time for data selection, in format "YYYY-MM-DD".
#' @param where string of SQL that is interpreted as a "WHERE" clause. Typically used to specify a subset of the data, see example.
#' @param nprocs Number of CPUs used for processing.
#'
#' @return Returns a data frame containing "x", "y", "site", "start" = starting point of record, "end" = end point of record (in this case none), and
#' "value" containing the daily precipitation.
#' @author Stefan Blumentrath, Jens Astrom
#' @seealso \code{\link{grassDailyTemp}}
#' @examples
#' \dontrun{
#' grassConnect()
#' points <- data.frame("x" = 270877, "y" = 7039976, "site" = 1)
#' tmp <- grassDailyClimate(points = points, start_time = "2014-01-01", end_time = "2014-12-31")
#'
#' tmp2 <- grassDailyClimate(
#'   points = points, start_time = "2013-01-01", end_time = "2014-12-31",
#'   where = "(strftime('%m', start_time) = '03' AND strftime('%d', start_time) >= '15') OR
#' (strftime('%m', start_time) = '04' AND strftime('%d', start_time) <= '15')"
#' )
#' }
#' @export


grassDailyClimate <- function(points, variables = c("Temperature", "Precipitation"), start_time, end_time, where = NULL, nprocs = 10) {
  # Check that is is run on Linux Server
  if (!checkMachine()) {
    stop("Must be run on NINA servers!")
  }

  location <- try(gmeta()$LOCATION_NAME, silent = TRUE)
  if (startsWith(as.character(location), "Error")) {
    stop("GRASS GIS does not seem to be running! Please init GRASS GIS using \"grassConnect()\" function.")
  } else {
    if (location != "ETRS_33N") {
      stop("Climate variables are only available in ETRS 33N location!")
    }
  }

  mapsets <- system("ls -1 /data/grass/ETRS_33N/ | grep gt_Meteorology_Norway_seNorge | grep days", intern = TRUE)
  all_variables <- unlist(lapply(1:length(mapsets), function(x) strsplit(mapsets, "_")[[x]][5]))

  for (variable in variables) {
    if (!(variable %in% all_variables)) {
      stop(paste0("Variable ", variable, "not available, available are: ", paste(all_variables, sep = ",")))
    }
  }

  if (!(is.null(where))) {
    time_cond <- paste("(start_time >='", start_time, "' AND start_time < '", end_time, "')", " AND (", where, " )", sep = "")
  } else {
    time_cond <- paste("start_time >='", start_time, "' AND start_time < '", end_time, "'", sep = "")
  }

  # Get bounding box of all points
  max_x <- max(points$x)
  max_y <- max(points$y)
  min_x <- min(points$x)
  min_y <- min(points$y)

  # set the computational region first to the raster map and extent of your points:
  rgrass::execGRASS("g.region",
    align = "precipitation_1957_01_01@gt_Meteorology_Norway_seNorge_Precipitation_days",
    n = as.character(max_y),
    s = as.character(min_y),
    e = as.character(max_x),
    w = as.character(min_x),
    flags = "p"
  )

  # Query time series at vector points, transfer result into R
  rgrass::execGRASS("t.connect", flags = "d")

  out <- list()

  for (v in variables) {
    # Add mapset containing time series data
    rgrass::execGRASS("g.mapsets", operation = "add", mapset = paste0("gt_Meteorology_Norway_seNorge_", v, "_days"))

    cat("This can take some time...")
    strds_var <- paste(tolower(substr(v, 1, 1)), substr(v, 2, nchar(v)), sep = "")
    variable_daily <- rgrass::execGRASS("t.rast.what",
      flags = c("n", "i", "overwrite", "verbose"),
      strds = paste0(strds_var, "_seNorge_1km_days@gt_Meteorology_Norway_seNorge_", v, "_days"),
      where = time_cond, nprocs = nprocs, Sys_input = paste(points$x, points$y, points$site, sep = " "), separator = ",", intern = TRUE
    )

    print(variable_daily)
    con <- textConnection(variable_daily)
    out[[v]] <- read.csv(con, header = TRUE)
  }
  return(out)
}
