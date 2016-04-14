#' addLogo
#'
#' # Adds a NINA logo to plot
#'
#' Colors conform to the 'NINA Grafisk handbok'
#'
#' @param Fill in
#' @return Fill in
#' @author Jens Astrom
#' @examples
#' plot((1:10)^2, 1:10, col=NinaPalette(), cex=4, pch=16, las=1, type="n")
#' addLogo()
#' points((1:10)^2, 1:10, col=NinaPalette(), cex=4, pch=16)
#' @export

addLogo <- function(x = 0.85, y = 0.1) {
xpos=x
ypos=y
require(grImport)
require(grid) ##Necessary?

#PostScriptTrace(system.file("img/logo.ps", package = "NinaR"))
logo <- readPicture(system.file("img/logo.ps.xml", package = "NinaR"))
pushViewport(plotViewport())
grid.picture(logo, width=0.2, x = unit(xpos, "npc"), y = unit(ypos, "npc"))
}

