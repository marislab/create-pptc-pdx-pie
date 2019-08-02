####install required packages
if(!require(tidyr)){
  install.packages("tidyr", repos='http://cran.us.r-project.org')
  library(tidyr)
  
}
if(!require(dplyr)){
  install.packages("dplyr", repos='http://cran.us.r-project.org')
  library(dplyr)
}
if(!require(devtools)){
  install.packages("devtools", repos='http://cran.us.r-project.org')
  library(devtools)
}
if(!require(sunburstR)){
  devtools::install_github("timelyportfolio/sunburstR")
  library(sunburstR)
  
}
if(!require(htmltools)){
  install.packages("htmltools", repos='http://cran.us.r-project.org')
  library(htmltools)
}
if(!require(d3r)){
  install.packages("d3r", repos='http://cran.us.r-project.org')
  library(d3r)
}
if(!require(treemap)){
  install.packages("treemap", repos='http://cran.us.r-project.org')
  library(treemap)
}
if(!require(mapview)){
  devtools::install_github("r-spatial/mapview")
  library(mapview)
}
