#' ninaPalette
#'
#' Creates a NINA figure color palette
#'
#' Colors conform to the 'NINA Grafisk handbok'
#'
#' @param palette choose between "main" and "logo" palettes.
#' @return Returns the 5 or 3 NINA figure colors
#' @author Jens Astrom, Kari Sivertsens
#' @seealso \code{\link{ninaLogoPalette}}
#' @examples
#' set.seed(12345)
#' barplot(runif(5), col=ninaPalette())
#' @export

ninaPalette <- function(palette = "main", reverse = FALSE, ...) {

  palette <- match.arg(palette, c("main", "logo"))

  pal <- nina_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  pal
}


nina_palettes <- list(
  `main`  = ninaColors("dark blue", "blue", "orange", "purple", "green"),

  `logo`  = ninaColors("grey", "light blue", "yellow")
)


ninaPaletteGgplot <- function(palette = "main", reverse = FALSE, ...) {
  pal <- nina_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  colorRampPalette(pal, ...)
}


