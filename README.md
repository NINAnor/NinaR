# NinaR
This is an R package that provides Rmarkdown templates practical functions for R users in NINA. Please contribute with R functions that you think is useful to other employees.

# Installation

Install from github.
```r
devtools::install_github("NINAnor/NinaR")
```

# Template usage
Once installed and using Rstudio, Nina templates appear in the `New file>Rmarkdown` menu. Alternatively, they could be retreived by 
```r 
rmarkdown::draft("title", template="nina_slidy", package="NinaR")
#and
rmarkdown::draft("title", template="nina_kortrapport", package="NinaR")
``` 
For further use, see the package rmarkdown and rticles.
