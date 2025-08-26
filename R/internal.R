## Generic function to check that we are running on NINA servers
checkMachine <- function() {
  host <- NULL
  try(host <- system("hostname", intern = T))

  test <- grepl("lipvdi|lipgis|liprstudio", host)
  return(test)
}


checkCon <- function() {
  if (!exists("con")) {
    stop("No connection, run postgreSQLConnect()")
  } else {
    if (class(con) != "PqConnection") {
      stop("\"con\" is not of class \"PqConnection\". Have you run postgreSQLConnect()?")
    }
    if (!DBI::dbIsValid(con)) {
      stop("No connection, run postgreSQLConnect()")
    }
  }
}


get_column_names <- function(layer,
                             schema) {
  column_query <- paste0(
    "
  SELECT column_name
  FROM information_schema.columns
  WHERE table_schema = '",
    schema,
    "'
  AND table_name = '",
    layer,
    "';
  "
  )

  res <- DBI::dbGetQuery(
    con,
    column_query
  )
  return(res)
}


##Arealdekke

ar5_colors <- rbind(
  c("Jordbruk_fulldyrka", 255, 209, 110),
  c("Jordbruk_overflatedyrka", 255, 255, 76),
  c("Jordbruk_innmarksbeite_uspes", 255, 255, 173),
  c("Skog", 158, 204, 115),
  c("Myr_aapen", 209, 209, 255),
  c("Myr_tresatt", 209, 209, 255),
  c("Snaumark_uspesifisert", 217, 217, 217),
  c("Ferskvann", 145, 231, 255),
  c("Hav", 204, 254, 254),
  c("Snøisbre", 230, 255, 255),
  c("Bebygd", 252, 219, 214),
  c("Samferdsel", 179, 120, 76),
  c("Ikke kartlagt", 255, 255, 255)
)

colnames(ar5_colors) <- c("arealtype", "red", "green", "blue")

ar5_colors <- ar5_colors |>
  as_tibble() |>
  dplyr::mutate(color = rgb(red,
                            green,
                            blue,
                            maxColorValue = 255)
  )

arealdekke_colors_vect <- ar5_colors %>%
  dplyr::select(color) %>%
  dplyr::pull()

names(arealdekke_colors_vect) <- ar5_colors$arealtype

#' scale_fill_arealdekke
#' @import dplyr
#' @noRd
#' @export
scale_fill_arealdekke <- function (...){
  scale_fill_manual(values = arealdekke_colors_vect, ...)
}

#okosystemtype_1

okosystemtype_colors_vect <- c("Coastal beaches, dunes and wetlands" = "#dcdcdc",
                               "Cropland" = "#ffd16e",
                               "Forest and woodlands" = "#9ecc73",
                               "Grassland" = "#ffffad",
                               "Heathland and shrub" = "#e1c790",
                               "Inland wetlands" = "#c9b0ec",
                               "Lakes and reservoirs" = "#6baed6",
                               "Marine ecosystems" = "#3182bd",
                               "Rivers and canals" = "#08519c",
                               "Settlements and other artificial areas" = "#e86474",
                               "Sparsely vegetated ecosystems" = "#ffe8c2"
)

#' scale_fill_okosystemtype_1
#' @import dplyr
#' @noRd
#' @export
scale_fill_okosystemtype_1 <- function (...){
  scale_fill_manual(values = okosystemtype_colors_vect, ...)
}
