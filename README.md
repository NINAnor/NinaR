# NinaR
This is an R package that provides Rmarkdown templates and various practical functions for R users in NINA. NINA-employees, please contribute with R functions that you think would be useful to others. 

Currently, the package contains the functions:

* addAlpha
* addLogo
* ninaLogoPalette
* ninaPalette
* ninaKortrapport
* ninaSlidy
* ninaBeamer
* mountFolders
* connectGrass
* getGrassDailyTemp
* getGrassDailyPrecip

# To-do
Given time and requests (particularly with resources), I would like to add a NINA report template (similar to the ninaKortrapport). Please contribute if you know your way around LaTeX.

# Installation

Install from github.
```r
devtools::install_github("NINAnor/NinaR")
```
To enable a simple vignette of current graphic functions (and install the suggested knitr package), do instead:
```r
devtools::install_github("NINAnor/NinaR", build_vignettes = TRUE)

vignette("Nina-figures")
```

To list all the available documentation:
```r
help(package="NinaR")
```


# Template usage
Once installed and using Rstudio, Nina templates appear in the `New file>Rmarkdown` menu. Alternatively, they could be retreived by 
```r 
rmarkdown::draft("title", template="nina_slidy", package="NinaR")
#and
rmarkdown::draft("title", template="nina_kortrapport", package="NinaR")
``` 
For further use, see the package rmarkdown, rticles or the templates themselves.

Questions and suggestions can be added on this site (issues) or to **Jens Åström (jens.astrom)**
