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

  #Check that is is run on NINSRV16
  host<-NULL
  try(host <- system("hostname", intern = T))
    if(host != "NINSRV16"){
    stop("Must be run on Ninsrv16!")
  }

  require(rgrass7)

  # Define GRASS working environment
  user <- Sys.info()['user']
  gisDbase <- '/data/grassdata'
  location <- 'ETRS_33N'
  mapset <- paste('u_', user, sep='')

  # Full path to mapset
  wd <- paste(gisDbase, location, mapset, sep='/')

  # Create mapset if it does not exist
  try(system( paste("grass72 -text -c -e", wd)))

  # Initialize GRASS session
  initGRASS(gisBase ='/usr/local/grass-7.2.1svn/', location = location, mapset = mapset, gisDbase = gisDbase, override = TRUE)

}


