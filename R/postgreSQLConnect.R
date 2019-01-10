#' postgreSQLConnect
#'
#' Connects to the PostgreSQL database gisdata-db.nina.no.
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function creates uses a Grass location based on the formula "u_USERNAME" where "USERNAME" is identified internally,
#' as the user that executes the function. This location is created if needed.
#'
#' @param Function accepts no params
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
                 password = password)
  assign("con", tmp, .GlobalEnv)

}
