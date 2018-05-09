#' Convert unicoe hestring characters to Scandinavian letters
#'
#' This is a convenience function that translates Scandinavian hestringadecimal characters into proper letters.
#'
#'
#' @author Diana Bowler, Jens Åström
#'
#' @examples
#' #to use
#' myData <- data.frame("locations" = c(1, 2, 3),
#'                      "messyNames" = c("Tr\xf8ndelag",
#'                                   "\xf6stersund",
#'                                   "G\xe6len"))
#'
#' myData$tidyName <- tidyScandinavian(myData$messyNames)
#'

tidyScandinavian <- function(string) {

  string <- as.character(string)
  string <- gsub("\xb0", "°", string)
  string <- gsub("\xf8", "ø", string)
  string <- gsub("\xe1", "á", string)
  string <- gsub("\xe6", "æ", string)
  string <- gsub("\xe5", "å", string)
  string <- gsub("\xd8", "Ø", string)
  string <- gsub("\xc5", "Å", string)
  string <- gsub("\xf6", "Ö", string)

  return(string)

}

