# NinaR
This is an R package that provides Rmarkdown templates and various practical functions for R users in NINA. NINA-employees, please contribute with R functions that you think would be useful to others. 

Currently, the package contains the functions:

* addAlpha	
* addLogo	
* grassConnect	
* grassDailyPrecip	
* grassDailyTemp	
* grassMonthlyPrecip	
* grassMonthlyTemp	
* grassViewshed	
* jensAnalysis	
* mountFolders	
* ninaBeamer	
* ninaLogoPalette	
* ninaPalette	
* ninaRapport	
* ninaSlidy
* postgreSQLConnect	
* tidyScandinavian

# NOTE!
At the moment, some functions have not been updated from using the old server (ninsrv16) to the new one (ninrstudio03). So some grass functions doesn't work currently. s

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

The github installation procedure might not work if you install your packages to a network mapped drive (e.g. M:/). You can then download the latest build from the `releases` tab and install through: (adapt path to suit the downloaded file)

```r
install.packages("NinaR_0.1.7.zip", repos=NULL)
```
Alternatively, it might be a good idea not to use the network drive to store your R-packages. To switch to using a local folder, create a folder on C:/, for example C:/R-packages. Then let R know where you want to put your packages by going to Control panel -> User accounts -> Change my environment variables, and make or update the environmental variable "R_LIBS_USER" to say C:/R-packages. After a restart, R should now use this folder for package installation. This might solve installation issues with other packages as well.


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
