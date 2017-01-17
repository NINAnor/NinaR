# NinaR
This is an R package that provides Rmarkdown templates practical functions for R users in NINA. Please contribute with R functions that you think is useful to other employees.

# Installation

Install from github.
```r
devtools::install_github("NINAnor/NinaR")
```
If you'd like the simple vignette of graphic functions (and suggested knitr package), do instead:

```r
devtools::install_github("NINAnor/NinaR", build_vignettes = TRUE)
```


# Template usage
Once installed and using Rstudio, Nina templates appear in the `New file>Rmarkdown` menu. Alternatively, they could be retreived by 
```r 
rmarkdown::draft("title", template="nina_slidy", package="NinaR")
#and
rmarkdown::draft("title", template="nina_kortrapport", package="NinaR")
``` 
For further use, see the package rmarkdown, rticles or the templates themselves.
