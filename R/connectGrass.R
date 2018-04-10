#' connectGrass
#'
#' Connects to GRASS on the Linux server at NINA.
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function creates uses a Grass location based on the formula "u_USERNAME" where "USERNAME" is identified internally,
#' as the user that executes the function. This location is created if needed.
#'
#' @param Function accepts no params
#' @return NULL
#' @author Stefan Blumentrath, Jens Astrom
#' @seealso \code{\link{getGrassDailyTemp}}
#' @examples
#' \dontrun{
#' connectGrass()
#' }
#' @export


connectGrass <- function(){
    host <- NULL
    try(host <- system("hostname", intern = T))
    if (grepl("ninrstudio", host)) {
      require(rgrass7)
      user <- Sys.info()["user"]
      gisDbase <- "/data/grass"
      location <- "ETRS_33N"
      mapset <- paste("u_", user, sep = "")
      wd <- paste(gisDbase, location, mapset, sep = "/")
      try(system(paste("grass -text -c -e", wd)))
      grasslib <- try(system('grass --config', intern=TRUE))[4]
      initGRASS(gisBase = grasslib, location = location,
                mapset = mapset, gisDbase = gisDbase, override = TRUE)
    } else
      if (host == "NINSRV16") {
        require(rgrass7)
        user <- Sys.info()["user"]
        gisDbase <- "/data/grassdata"
        location <- "ETRS_33N"
        mapset <- paste("u_", user, sep = "")
        wd <- paste(gisDbase, location, mapset, sep = "/")
        try(system(paste("grass72 -text -c -e", wd)))
        initGRASS(gisBase = "/usr/local/grass-7.2.1svn/", location = location,
                  mapset = mapset, gisDbase = gisDbase, override = TRUE)
      } else stop("Must be run on Ninsrv16 or Ninrstudio01!")
}




