#' getViewshed
#'
#' Calculate a viewshed from a given point based on a 10m DEM
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function returns (optional) an SP class dataframe with a viewshed, i.e. area visible from a point.
#'
#' @param xycoords data frame containing columns "x" and "y" containint longitude and latitude in EPSG:25833
#' @param return logical. Indicating whether the map should be returned instead of just created (default=TRUE)
#' @param dist numerical.
#' @param observer_elevation numerical. Sets the height of the observer above the dem.
#' @param target_elevation numerical. The user can change this using option target_elevation to determine
#' if objects of a given height would be visible.
#'
#' @return NULL
#' @author  Jens Astrom
#' @examples
#' \dontrun{
#' hm <- getViewshed(xycoords = data.frame("x" = 310400, "y" = 6991600), dist=1000)
#' plot(hm)
#' }
#' @export




getViewshed <- function(xycoords, return = TRUE, dist = 100, observer_elevation = 1.75, target_elevation = 0){

  #Check that is is run on NINSRV16
  #Check that is is run on NINSRV16
  if(!checkMachine()){
    stop("Must be run on NINA servers!")
  }

  require(rgrass7)

  ##Check if grassconnection is up, otherwise connect
  op <- options(warn=2)
  tt <- try(gmeta())
  if(is(tt,"try-error")){
    NinaR::connectGrass()
    }
  options(op)

  ##Calculate suitable boundary
  my_point = xycoords
  max_x <- my_point$x + 1.1*dist
  max_y <- my_point$y + 1.1*dist
  min_x <- my_point$x - 1.1*dist
  min_y <- my_point$y - 1.1*dist

  ##Set g.region
  execGRASS("g.region", align = "dem_10m_nosefi@PERMANENT",
            n = as.character(max_y), s = as.character(min_y), e = as.character(max_x),
            w = as.character(min_x))
  ##Get viewshed
  execGRASS("r.viewshed", parameters = list(input = "dem_10m_nosefi@PERMANENT", output = "viewshed_raster",
                                            coordinates = c(my_point$x, my_point$y),
                                            observer_elevation = observer_elevation,
                                            target_elevation = target_elevation,
                                            max_distance = dist),
                                            flags = c("b", "c","overwrite"))

  execGRASS("r.to.vect", parameters = list(input = "viewshed_raster", output = "viewshed_vector", type = "area"),
            flags = c("overwrite"))

  if(return==T){
  out <- readVECT("viewshed_vector")
  return(out)
  }

}






