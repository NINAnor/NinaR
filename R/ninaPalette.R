#' ninaPalette
#'
#' # Creates a NINA figure color palette
#'
#' Colors conform to the 'NINA Grafisk handbok'
#'
#' @param Function accepts no params
#' @return Returns 5 figure colors
#' @author Jens Astrom, Kari Sivertsen
#' @seealso \code{\link{NinaLogoPalette}}
#' @examples
#' set.seed(12345)
#' barplot(runif(5), col=ninaPalette())
#' @export


ninaPalette <- function() {
  c("#004F71", "#008C95", "#E57200","#93328E","#7A9A01")
}


