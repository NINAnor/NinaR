
## Generic function to check that we are running on NINA servers
checkMachine <- function(){
  host<-NULL
  try(host <- system("hostname", intern = T))

  test <- grepl("ninrstudio", host) || grepl("NINSRV16", host)
  return(test)
}
