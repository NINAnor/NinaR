#' addLogo
#'
#' Adds a NINA logo to plot
#'
#' Logo is based on Postscript version of logo, and is scalable
#' (vectorized). The function uses the package grImport. See
#' examples for usage.
#'
#' @param x x-position in percentage values (0-1) of
#' npc (Normalized parent coordinates)
#' @param y y-position in percentage values (0-1) of
#' npc (Normalized parent coordinates)
#' @param size size specified as width in percentage of original size (default 0.2).
#' Height is left unspecified to scale with width, retaining
#' original aspect ratio.
#'
#' @return Adds scalable logo on current device (opens new device if no current device exists)
#' @author Jens Astrom
#'
#' @import grImport
#' @import grid
#'
#' @examples
#' ## Add small logo to right bottom corner
#' plot((1:10)^2, 1:10, col=ninaPalette(), cex=4, pch=16, las=1)
#' addLogo()
#'
#' #Add large logo to background of plot
#' plot((1:10)^2, 1:10, col=ninaPalette(), cex=4, pch=16, las=1, type="n")
#' addLogo(x = 0.5, y = 0.5, size = 1)
#' grid.rect(gp = gpar(fill = rgb(1, 1, 1, .6)))
#' points((1:10)^2, 1:10, col=ninaPalette(), cex=4, pch=16)
#' @export

addLogo <- function(x = getOption("nina.logo.x.pos", 0.85),
                    y = getOption("nina.logo.y.pos", 0.1),
                    size = 0.2) {


logo <- grImport::readPicture(system.file("img/logo.ps.xml", package = "NinaR"))
grid::pushViewport(grid::plotViewport())
grImport::grid.picture(logo, width = size, x = unit(x, "npc"), y = unit(y, "npc"))
}

