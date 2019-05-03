#' scale_fill_nina
#'
#' ggplot fill scale constructor for NINA colors
#'
#' Shamelessly taken from https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
#'
#' @param palette Character name of palette in ninaPalette, see \link{ninaPalette}
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_fill_gradientn(), used respectively when discrete is TRUE or FALSE
#'
#' @examples
#'
#' par(ask =T)
#'
#'  g <- ggplot(faithfuld, aes(waiting, eruptions))
#'  g + geom_raster(aes(fill = density)) +
#'    scale_fill_nina(discrete = F)
#'
#'  g <- ggplot(mpg, aes(class))
#'  g + geom_bar(aes(fill = drv)) +
#'    scale_fill_nina(palette = "logo")
#'
#' @export
#'
scale_fill_nina <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {

  palette <- match.arg(palette, c("main", "logo"))

  pal <- ninaPaletteGgplot(palette = palette, reverse = reverse)

  if (discrete) {
    discrete_scale("fill", paste0("NINA", palette), palette = pal, ...)
  } else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}
