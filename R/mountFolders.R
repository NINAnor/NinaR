#' mountFolders
#'
#' Mounts folders from the Nina Windows environment on Ninsrv16 or ninrstudio03
#'
#' Only works when run on these Linux server, and stops if checks fail to identify the running machine as such.
#' Meant to be run on the Rstudio-server at http://ninsrv16:8787 or ninrstudio03.nina.no
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
#' On ninrstudio03 the folders in R:\ is available through HOME\Mounted or HOME\Mounts
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

mountFolders <- function(){

  #Check that is is run on NINSRV16 or ninrstudio03
  host<-NULL
  try(host <- system("hostname", intern = T))

  if(host != "NINSRV16" & host != "ninrstudio03"){
    stop("Must be run on Ninsrv16 or ninrstudio03!")
  }

    #Ask for password
  passw <- .rs.askForPassword("Enter your Windows password:")

  if(host == "NINSRV16"){
  #Run mount script
  system("/usr/bin/mount.sh", input = passw)
  } else system("/usr/bin/kinit", input = passw)

  #Delete password string (not sure is needed)
  rm(passw)



}
