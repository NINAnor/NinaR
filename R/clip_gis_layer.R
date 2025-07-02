#' clip_gis_layer Get an intersection from an existing PostGIS layer and a provided sf layer
#'
#' This function is meant to return the Grunnkart for Arealregnskap for a single or set of polygons you provide. Input polygons are provided as an sf object, with a column that identifies your polygons / buffers. Ouput is a similar sf object but with the clipped geometry and ecosystem type from the Grunnkart. Other layers can be clipped by naming the layers to clip
#'
#' @param mask A simple feature (sf) object with an id column and a geometry. Typically a polygon or a set of polygons.
#' @param layer_to_clip The PostGIS layer to clip from. Default is the Grunnkart for arealregnskap.
#' @param clip_geometries Should the returned geometries be clipped to the masking layer? If true, the first column of the masking layer is returned as row IDs, and the clipped geometries of the layer_to_clip are returned. If false, the ids in the layer_to_clip is returned as well the first column in the masking layer, together with the whole geometries in layer_to_clip that intersects at some point with the masking layer.  Default is TRUE.
#' @param recalculate_area Should the column "areal_m2" be recalculated after clipping the geometries? Only in effect if clip_geometries is true. Default true.
#' @param host host machine for the database. Default is gisdata-db.nina.no
#' @param dbname host database name. Default is gisdata
#'
#' @return An sf object with your initial vector column and the intersecting geometry of
#' @export
#'
#' @examples
#' \dontrun{
#' NinaR::postgreSQLConnect()
#'
#' small_sf <- tibble(locality = c("Semi-nat_99", "Semi-nat_100"), geom = c("POLYGON ((1082500 7775000, 1082500 7775500, 1083000 7775500, 1083000 7775000, 1082500 7775000))", "POLYGON ((1019000 7842500, 1019000 7843000, 1019500 7843000, 1019500 7842500, 1019000 7842500))")) |>
#'   st_as_sf(wkt = "geom", crs = 25833)
#'
#' small_sf_grunnkart <- clip_gis_layer(small_sf)
#' }
#'


clip_gis_layer <- function(mask = NULL,
                           layer_to_clip = "grunnkart_arealregnskap",
                           schema = "LandCover",
                           clip_geometries = TRUE,
                           recalculate_area = TRUE) {
  checkMachine()
  checkCon()

  if (!("sf" %in% class(mask))) stop("Masking layer needs to be an simple feature object (sf)")

  orig_id_name <- names(mask)[1]

  mask_to_clip <- mask |>
    select(1) |>
    rename(id = 1)

  suppressMessages({
    DBI::dbWriteTable(
      conn = con,
      name = "temp_mask_to_intersect",
      value = mask_to_clip,
      temporary = TRUE,
      overwrite = TRUE
    )
  })


  columns_in_layer <- NinaR:::get_column_names(
    layer = layer_to_clip,
    schema = schema
  )

  columns_to_get_raw <- columns_in_layer |>
    filter(!(column_name %in% c("id", "geom", "geom_valid", "geom_is_valid"))) |>
    paste(collapse = ",")

  columns_to_get <- gsub("^c\\(|\\)$", "", columns_to_get_raw)


  if (clip_geometries) {
    sql_intersection_query <- paste0("
    SELECT tt.id as mask_id, ", columns_to_get, ",
    ST_Intersection(t.geom_valid, tt.geom) as geom
    FROM \"", schema, "\".\"", layer_to_clip, "\" AS t,
    temp_mask_to_intersect as tt
    WHERE ST_Intersects(t.geom_valid, tt.geom);
    ")
  } else {

    sql_intersection_query <- paste0("
    SELECT t.id, ", columns_to_get, ", t.geom_valid as geom,  tt.id as mask_id
    FROM \"", schema, "\".\"", layer_to_clip, "\" AS t,
    temp_mask_to_intersect as tt
    WHERE ST_Intersects(t.geom_valid, tt.geom);
    ")
  }

  intersecting_features_df <- DBI::dbGetQuery(con, sql_intersection_query) |>
    rename(!!orig_id_name := mask_id) |>
    as_tibble()

  intersecting_features_df$geom <- sf::st_as_sfc(intersecting_features_df$geom, wkb = "geom", EWKB = TRUE)
  intersecting_features_df <- sf::st_as_sf(intersecting_features_df)

  if(recalculate_area & clip_geometries){
    intersecting_features_df <- intersecting_features_df |>
      mutate(areal_m2 = st_area(geom))
  }

  return(intersecting_features_df)
}
