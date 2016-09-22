#' ninaLogoPalette
#'
#' Creates a NINA logo color palette
#'
#' Colors conform to the 'NINA Grafisk handbok'
#'
#' @param Function accepts no params
#' @return Returns 3 logo colors
#' @author Jens Åström, Kari Sivertsen
#' @seealso \code{\link{ninaPalette}}
#' @examples
#' set.seed(12345)
#' barplot(runif(3), col=ninaLogoPalette())
#' @export


ninaLogoPalette <- function() {
  c("#A2AAAD", "#2DCCD3", "#FFB25B")
}
