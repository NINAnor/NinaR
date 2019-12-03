#' Color scale constructor for NINA colors
#'
#' ggplot2 color scales for NINA colors
#'
#' Shamelessly taken from https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
#'
#' @param palette Character name of palette in ninaPalette, "main" and "logo" represents separate officially defined palettes. Others are various combinations of these colors, most usefull for continuous scales. See \link{ninaPalette}.
#' @param discrete Boolean indicating whether color aesthetic is discrete or not.
#' @param reverse Boolean indicating whether the palette should be reversed.
#' @param name The name of the legend. Defaults to waiver(), in which case the name of the scale is taken from the first mapping used for that aesthetic. If NULL, the legend title will be omitted.
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_color_gradientn(), used respectively when discrete is TRUE or FALSE.
#'
#'
#' @examples
#'
#' ggplot(mpg, aes(cyl, hwy)) +
#' geom_point(aes(colour = drv)) +
#'   scale_color_nina(discrete = T)
#'
#'
#' ggplot(mpg, aes(cyl, hwy)) +
#' geom_point(aes(colour = year)) +
#'   scale_color_nina(discrete = F,
#'                    palette = "lightblue-yellow",
#'                    name = "Year of make") +
#'  ylab("Highway miles per gallon") +
#'  xlab("Number of cylinders")
#'
#' @export
scale_color_nina <- function(palette = "main",
                             discrete = TRUE,
                             reverse = FALSE,
                             name = waiver(),
                             ...) {

  palette <- match.arg(palette, names(nina_palettes))

  pal <- ninaPaletteGgplot(palette = palette, reverse = reverse)

  if (discrete) {
    discrete_scale("colour",
                   paste0("NINA", palette),
                   palette = pal,
                   name = name,
                   ...)
  } else {
    scale_color_gradientn(colours = pal(256),
                          name = name,
                          ...)
  }
}
