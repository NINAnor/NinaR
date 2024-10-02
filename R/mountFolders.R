#' mountFolders
#'
#' Mounts folders from the Nina Windows environment on ninrstudiox
#'
#' Only works when run on these Linux server, and stops if checks fail to identify the running machine as such.
#' Meant to be run on the Rstudio-server at ninrstudio03.nina.no
#'
#' The function calls the login script on the servers which mounts the folders:
#' \itemize{
#' \item Prosjekter (R:\\Prosjekter)
#' \item winhome (M:\\)
#' \item Kladd (R:\\Kladd)
#' \item grassdata (R:\\grassdata)
#' \item Maler (R:\\Maler)
#' }
#'
#' On ninrstudio03 the folders in R:\ is available through HOME\\Mounted or HOME\\Mounts
#'
#'
#'
#' @param The function takes no parameters but asks for the password in an interactive prompt
#' @return NULL
#' @author Jens Astrom
#' @examples
#' \dontrun{
#' mountFolders()
#' }
#' @export

mountFolders <- function() {
  # Ask for password
  passw <- .rs.askForPassword("Enter your Windows password:")

  # Try to reset credits
  try(system("/usr/bin/kinit", input = passw), silent = TRUE)

  # Delete password string (not sure is needed)
  rm(passw)
}
