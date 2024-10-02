#' ninaColors
#'
#' Specification for NINA coorporate colors
#'
#' Shamelessly taken from https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2
#'
#'
#'
#'
#' @param ... Character names of ninaColors
#' @export

nina_colors <- c(
  `dark blue` = "#004F71",
  `blue` = "#008C95",
  `orange` = "#E57200",
  `purple` = "#93328E",
  `green` = "#7A9A01",
  `grey` = "#A2AAAD",
  `light blue` = "#2DCCD3",
  `yellow` = "#FFB25B"
)

#' @export

ninaColors <- function(...) {
  cols <- c(...)

  if (is.null(cols)) {
    return(nina_colors)
  }

  nina_colors[cols]
}
