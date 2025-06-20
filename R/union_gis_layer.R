#' union_gis_layer Union (aggregate / combine) geometries of similar type
#'
#' This function combines separate geometries together, that share some common type. This is done separately for different areas, if provided, using an id_column.
#'
#' @param layer An sf-layer to union / combine
#' @param column_to_join_on Character vector of column name to join on
#' @param id_column Optional character vector that specifies the identifying column, that you want to keep separate.
#'
#' @return An sf-object
#' @export
#'
#' @examples
#' \dontrun{
#' #' NinaR::postgreSQLConnect()
#'
#' small_sf <- tibble(locality = c("Semi-nat_99", "Semi-nat_100"), geom = c("POLYGON ((1082500 7775000, 1082500 7775500, 1083000 7775500, 1083000 7775000, 1082500 7775000))", "POLYGON ((1019000 7842500, 1019000 7843000, 1019500 7843000, 1019500 7842500, 1019000 7842500))")) |>
#'   st_as_sf(wkt = "geom", crs = 25833)
#'
#' small_sf_grunnkart <- clip_gis_layer(small_sf)
#'
#' unioned_grunnkart <- union_gis_layer(small_sf_grunnkart)
#' }
union_gis_layer <- function(layer,
                            column_to_join_on,
                            id_column = NULL) {
  checkMachine()
  checkCon()

  if (!("sf" %in% class(layer))) stop("Masking layer needs to be an simple feature object (sf)")


  if (is.null(id_column)) {
    id_to_use <- names(layer)[1]
  } else {
    id_to_use <- id_column
  }

  groups <- c(id_to_use, column_to_join_on)

  unioned <- layer |>
    group_by(across(all_of(groups))) |>
    summarize(geom = sf::st_union(geom)) |>
    ungroup()

  return(unioned)
}
