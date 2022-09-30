#' add_logo Add a NINA-logo to ggplots
#'
#' This is a ggplot version of addLogo. It inserts a svg version of the NINA logo in a ggplot. You have to tinker a bit with the xmin, xmax, ymin, ymax values, and the stroke_scale a bit to get it to fit your particular plot. So far, no alpha capabilities.
#'
#' @param logo_type black or white logo? defaults to "black"
#' @param xmin start position of logo along x-axis
#' @param xmax end position of logo along x-axis
#' @param ymin start position of logo along y-axis
#' @param ymax end position of logo along y-axis
#'
#' @return adds a NINA logo in vector formats to ggplots
#' @export
#'
#'
#' @examples
#'
#'
#' p <- ggplot(tibble(x = (1:10)^2, y = 1:10), aes(x = x, y = y)) +
# add_logo(xmin = 75, ymax = 2.5, ymin = 1, stroke_scale = 0.3) +
#  geom_point()
# p
#'
#'
#'
#'
add_logo <- function(logo_type = "black",
                     xmin = -Inf,
                     xmax = Inf,
                     ymin = -Inf,
                     ymax = Inf,
                     stroke_scale = 1) {

  logo_type <- match.arg(logo_type, choices = c("black", "white"))

  if(logo_type == "white"){
    grob <- svgparser::read_svg(system.file("img/logo_white.svg", package = "NinaR"),
                                stroke_scale = stroke_scale)
  } else {
    grob <- svgparser::read_svg(system.file("img/logo_black.svg", package = "NinaR"),
                                stroke_scale = stroke_scale)
  }


  ggplot2::layer(data = ggplot2:::dummy_data(),
                 stat = ggplot2:::StatIdentity,
                 position = ggplot2:::PositionIdentity,
                 geom = ggplot2:::GeomCustomAnn,
                 inherit.aes = FALSE,
                 params = list(grob = grob,
                               xmin = xmin,
                               xmax = xmax,
                               ymin = ymin,
                               ymax = ymax))
}
