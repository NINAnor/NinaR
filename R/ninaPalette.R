#' ninaPalette
#'
#' Creates a NINA figure color palette
#'
#' Colors conform to the 'NINA Grafisk handbok'
#'
#' @param palette choose between "main" and "logo" palettes, or some combinations of the colors in `ninaColors()`. See \link{nina_palettes}.
#' @return Returns the 5 or 3 NINA figure colors
#' @author Jens Astrom, Kari Sivertsens
#' @seealso \code{\link{ninaLogoPalette}}
#' @examples
#' set.seed(12345)
#' barplot(runif(5), col=ninaPalette())
#' @export

ninaPalette <- function(palette = "main", reverse = FALSE, ...) {

  palette <- match.arg(palette, names(nina_palettes))

  pal <- nina_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  pal
}

#' @export
nina_palettes <- list(
  `main`  = ninaColors("dark blue", "blue", "orange", "purple", "green"),

  `logo`  = ninaColors("grey", "light blue", "yellow"),

  `darkblue-blue` = ninaColors("dark blue", "blue"),

  `darkblue-orange` = ninaColors("dark blue", "orange"),

  `blue-orange` =  ninaColors("blue", "orange"),

  `orange-purple` =  ninaColors("orange", "purple"),

  `purple-green` =  ninaColors("purple", "green"),

  `darkblue-orange` = ninaColors("dark blue", "orange"),

  `darkblue-green` = ninaColors("dark blue", "green"),

  `orange-green` = ninaColors("orange", "green"),

  `grey-yellow` = ninaColors("grey", "yellow"),

  `lightblue-yellow` = ninaColors("light blue", "yellow")

)


ninaPaletteGgplot <- function(palette = "main", reverse = FALSE, ...) {
  pal <- nina_palettes[[palette]]

  if (reverse) pal <- rev(pal)

  colorRampPalette(pal, ...)
}


