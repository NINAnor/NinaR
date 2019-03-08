#' addAlpha
#'
#' Add an alpha value to a colour
#'
#' Code taken from Markus Gesmann http://www.magesblog.com/2013/04/how-to-change-alpha-value-of-colours-in.html
#'
#' @return Returns colors with modified alpha channel
#' @author Jens Astrom
#' @seealso \code{\link{ninaPalette}}
#' @examples
#' set.seed(12345)
#' barplot(runif(5), col=addAlpha(ninaPalette(), 0.4))
#' @export

addAlpha <- function(col, alpha=1){
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, grDevices::col2rgb)/255, 2,
   function(x)
    rgb(x[1], x[2], x[3], alpha = alpha))
}
