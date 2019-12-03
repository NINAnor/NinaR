#' postgreSQLConnect
#'
#' Connects to the PostgreSQL database gisdata-db.nina.no.
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function creates uses a Grass location based on the formula "u_USERNAME" where "USERNAME" is identified internally,
#' as the user that executes the function. This location is created if needed.
#'
#' @param username Defaults to "postgjest"
#' @param password Defaunts to "gjestpost"
#' @param host Database server name (DNS). Defaults to gisdata-db.nina.no
#' @param dbname Database name. Defaults to gisdata.
#' @param ... Additional arguments passed to the RPostgres driver (dbConnect,PqDriver-method {RPostgres}). Use for example bigint = "integer" to avoid integer64 data types.
#' @return NULL
#' @author  Jens Astrom
#' @examples
#' \dontrun{
#' postgreSQLConnect()
#' }
#' @export


postgreSQLConnect <- function(username = "postgjest",
                              password = "gjestpost",
                              host = "gisdata-db.nina.no",
                              dbname = "gisdata",
                              ...){

  tmp <- DBI::dbConnect(RPostgres::Postgres(),
                 host = host,
                 dbname = dbname,
                 user = username,
                 password = password,
                 ...)
  assign("con", tmp, .GlobalEnv)

}
