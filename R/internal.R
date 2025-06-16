## Generic function to check that we are running on NINA servers
checkMachine <- function() {
  host <- NULL
  try(host <- system("hostname", intern = T))

  test <- grepl("ninrstudio", host) || grepl("ningis", host) || grepl("t2liprstudio", host) || grepl("lipgis", host)
  return(test)
}
