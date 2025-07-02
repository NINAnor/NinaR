#' rasterize_gis_layer Make a raster brick of ve
#'
#' @param gis_layer An sf layer to rasterize. Typically made by clip_gis_layer().
#' @param id_layer Optional id column that identifies separate areas to rasterize, e.g. localities. If none is provided, the first column of the input layer will be used.
#' @param feature_column What column to use as values. Character values will be made into numerical values by as.numeric(as.factor())
#' @param raster_template Optional raster layer to use as template. Must be a of 'SpatRaster' class (from package terra)
#' @param resolution Set the spatial resolution of the raster if no raster template is provided. The origin of the raster will then be the left bottom origin of the border of the input vector layer.
#'
#' @return A list of rasters for every value in id_layer (e.g. a list of rasters for each locality)
#' @export
#'
#' @examples
#' \dontrun{
#'
#' #' small_sf <- tibble(locality = c("Semi-nat_99", "Semi-nat_100"), geom = c("POLYGON ((1082500 7775000, 1082500 7775500, 1083000 7775500, 1083000 7775000, 1082500 7775000))", "POLYGON ((1019000 7842500, 1019000 7843000, 1019500 7843000, 1019500 7842500, 1019000 7842500))")) |>
#' st_as_sf(wkt = "geom", crs = 25833)
#'
#' small_sf_grunnkart <- clip_gis_layer(small_sf)
#'
#' raster_grunnkart <- rasterize_gis_layer(small_sf_grunnkart,
#'   feature_column = "okosystemtype_1"
#' )
#' }
#'
#'

rasterize_gis_layer <- function(gis_layer,
                                id_column = NULL,
                                feature_column = NULL,
                                raster_template = NULL,
                                resolution = 10) {
  input <- gis_layer

  if (is.null(id_column)) {
    id_column <- names(input)[[1]]

    ids <- input |>
      st_drop_geometry() |>
      select(all_of(id_column)) |>
      distinct() |>
      pull()
  } else {
    ids <- input |>
      st_drop_geometry() |>
      select(all_of(id_column)) |>
      distinct() |>
      pull()
  }

  feature_column <- enquo(feature_column)

  input <- input |>
    mutate(feature_column_factor = as.factor(get({{ feature_column }})))

  out <- list()

  for (i in ids) {
    index <- dplyr::enquo(i)

    if (is.null(raster_template)) {
      r <- input |>
        filter(get({{ id_column }}) == !!i) |>
        terra::rast(
          resolution = resolution
        )
    } else {
      if (!("SpatRaster" %in% class(raster_template))) stop("raster template must be of SpatRaster class")
      r <- raster_template
    }

    vect <- input |>
      filter(get({{ id_column }}) == !!i)

    out[[i]] <- terra::rasterize(
      x = vect,
      y = r,
      field = "feature_column_factor"
    )
  }

  return(out)
}
