#' mountFolders
#'
#' Mounts folders from the Nina Windows environment on Ninsrv16
#'
#' Only works when run on the Linux server, and stops if checks fail to identify the running machine as such.
#' The function calls the login script on NINSRV16, which mounts the folders:
#' \itemize{
#' \item Prosjekter (R:\\Prosjekter)
#' \item winhome (M:\\)
#' \item Kladd (R:\\Kladd)
#' \item grassdata (R:\\grassdata)
#' \item Maler (R:\\Maler)
#' }
#' This should enable you to reach these folders through Rstudio-server at Ninsrv16.
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

mountFolders <- function(){

  #Check that is is run on NINSRV16
  host<-NULL
  try(host <- system("hostname", intern = T))
  if(host != "NINSRV16"){
    stop("Must be run on Ninsrv16!")
  }


  #Ask for password
  passw <- .rs.askForPassword("Enter your Windows password:")

  #Run mount script
  system("/usr/bin/mount.sh", input = passw)

  #Delete password string (not sure is needed)
  rm(passw)

}
