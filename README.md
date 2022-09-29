
<!-- README.md is generated from README.Rmd. Please edit that file -->

# NinaR <img src="https://github.com/NINAnor/NinaR/blob/master/inst/img/NinaR_logo.png" align="right" width="160px"/>

<!-- badges: start -->

[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![](https://img.shields.io/badge/devel%20version-0.2.2.6-blue.svg)](https://github.com/NINAnor/NinaR)
[![](https://www.r-pkg.org/badges/version/NinaR)](https://cran.r-project.org/package=NinaR)
[![](https://img.shields.io/github/languages/code-size/NINAnor/NinaR.svg)](https://github.com/NINAnor/NinaR)
<!-- badges: end -->

This is an R package that provides Rmarkdown templates and various
practical functions for R users in NINA. NINA-employees, please
contribute with R functions that you think would be useful to others.

Currently, the package contains the functions:

-   addAlpha
-   addLogo
-   checkWorkload
-   grassConnect
-   grassDailyPrecip
-   grassDailyTemp
-   grassMonthlyPrecip
-   grassMonthlyTemp
-   grassViewshed
-   jensAnalysis
-   mountFolders
-   ninaBeamer
-   ninaColors
-   ninaLogoPalette
-   ninaPalette
-   ninaRapport
-   ninaSlidy
-   nina_colors
-   postgreSQLConnect
-   scale_color_nina
-   scale_fill_nina
-   tidyScandinavian


# NOTE!

At the moment, some functions have not been updated from using the old
server (ninsrv16) to the new one (ninrstudio03). So some grass functions
might not work.

# To-do

I have added a NINA report template (similar to the old
ninaKortrapport), but this is untested in a real case. Please test it
and you are most welcome to contribute if you know your way around
LaTeX.

# Installation

Install from github.

``` r
devtools::install_github("NINAnor/NinaR")
```

To enable a simple vignette of current graphic functions (and install
the suggested knitr package), do instead:

``` r
devtools::install_github("NINAnor/NinaR", build_vignettes = TRUE)

vignette("Nina-figures")
```

Alternatively, it might be a good idea not to use the network drive to
store your R-packages. To switch to using a local folder, create a
folder on C:/, for example C:/R-packages. Then let R know where you want
to put your packages by going to Control panel -> User accounts ->
Change my environment variables, and make or update the environmental
variable “R_LIBS_USER” to say C:/R-packages. After a restart, R should
now use this folder for package installation. This might solve
installation issues with other packages as well.

To list all the available documentation:

``` r
help(package="NinaR")
```

# Template usage

Once installed and using Rstudio, Nina templates appear in the
`New file>Rmarkdown` menu. Alternatively, they could be retreived by

``` r
rmarkdown::draft("title", template="nina_slidy", package="NinaR")
#and
rmarkdown::draft("title", template="nina_rapport", package="NinaR")
```

For further use, see the package rmarkdown, rticles or the templates
themselves.

Questions and suggestions can be added on this site (issues) or to
**Jens Åström (jens.astrom)**
