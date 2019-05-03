#' Color scale constructor for NINA colors
#'
#' ggplot2 color scales for NINA colors
#'
#' Shamelessly taken from https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
#'
#' @param palette Character name of palette in ninaPalette, see \link{ninaPalette}
#' @param discrete Boolean indicating whether color aesthetic is discrete or not
#' @param reverse Boolean indicating whether the palette should be reversed
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_color_gradientn(), used respectively when discrete is TRUE or FALSE
#'
#'
#' @examples
#'
#' ggplot(mpg, aes(cyl, hwy)) +
#' geom_point(aes(colour = drv)) +
#'   scale_color_nina(discrete = T)
#'
#'
#' @export
scale_color_nina <- function(palette = "main", discrete = TRUE, reverse = FALSE, ...) {

  palette <- match.arg(palette, c("main", "logo"))

  pal <- ninaPaletteGgplot(palette = palette, reverse = reverse)

  if (discrete) {
    discrete_scale("colour", paste0("NINA", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}
