#' grassConnect
#'
#' Connects to GRASS on the Linux servers at NINA.
#'
#' Only works when run on the Linux servers, and stops if checks fail to identify the running machine as such.
#' The function creates uses a Grass location based on the formula "u_USERNAME" where "USERNAME" is identified internally,
#' as the user that executes the function. This location is created if needed.
#'
#' @param Function accepts no params
#' @return NULL
#' @author Stefan Blumentrath, Jens Astrom, Bernardo Niebuhr
#' @seealso \code{\link{grassDailyTemp}}
#' @examples
#' \dontrun{
#' grassConnect()
#' }
#' @export

grassConnect <- function(location = "ETRS_33N", mapset = "user") {
  host <- NULL
  try(host <- system("hostname", intern = T))
  if (grepl("lipvdi|lipgis|liprstudio", host)) {
    gisDbase <- "/data/grass"
    # location <- "ETRS_33N"
    if (mapset == "user") {
      user <- Sys.info()["user"]
      mapset <- paste("u_", user, sep = "")
    }
    if (TRUE %in% startsWith(mapset, c("u_", "p_", "g_", "gt_"))) {
      wd <- paste(gisDbase, location, mapset, sep = "/")
      try(system(paste("grass -text -c -e", wd)))
      grasslib <- try(system("grass --config path", intern = TRUE))
      rgrass::initGRASS(
        gisBase = grasslib, location = location,
        mapset = mapset, gisDbase = gisDbase, override = TRUE
      )
    } else {
      stop("Mapset name does not follow naming convention! Please check: http://web.nina.no/giswiki/doku.php?id=ninsrv16:grassgisbase")
    }
  } else {
    stop("Must be run on one of NINAs Linux servers!")
  }
}
