#' scale_fill_nina
#'
#' ggplot fill scale constructor for NINA colors
#'
#' Shamelessly taken from https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
#'
#' @param palette Character name of palette in ninaPalette, "main" and "logo" represents separate officially defined palettes. Others are various combinations of these colors, most usefull for continuous scales. See \link{ninaPalette}.
#' @param discrete Boolean indicating whether color aesthetic is discrete or not.
#' @param reverse Boolean indicating whether the palette should be reversed.
#' @param name The name of the legend. Defaults to waiver(), in which case the name of the scale is taken from the first mapping used for that aesthetic. If NULL, the legend title will be omitted.
#' @param ... Additional arguments passed to discrete_scale() or
#'            scale_fill_gradientn(), used respectively when discrete is TRUE or FALSE.
#'
#' @examples
#'
#' par(ask =T)
#'
#'  g <- ggplot(faithfuld, aes(waiting, eruptions))
#'  g + geom_raster(aes(fill = density)) +
#'    scale_fill_nina(discrete = F,
#'                    name = "Eruptions",
#'                    palette = "darkblue-green")
#'
#'  g <- ggplot(mpg, aes(class))
#'  g + geom_bar(aes(fill = drv)) +
#'    scale_fill_nina(palette = "logo")
#'
#' @export
#'
scale_fill_nina <- function(palette = "main",
                            discrete = TRUE,
                            reverse = FALSE,
                            name = waiver(),
                            ...) {

  palette <- match.arg(palette,
                       names(nina_palettes))

  pal <- ninaPaletteGgplot(palette = palette,
                           reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale("fill",
                   paste0("NINA", palette),
                   palette = pal,
                   name = name,
                   ...)
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256),
                         name = name,
                         ...)
  }
}
