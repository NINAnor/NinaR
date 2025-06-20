## Generic function to check that we are running on NINA servers
checkMachine <- function() {
  host <- NULL
  try(host <- system("hostname", intern = T))

  test <- grepl("ninrstudio", host) || grepl("ningis", host) || grepl("t2liprstudio", host) || grepl("lipgis", host)
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
