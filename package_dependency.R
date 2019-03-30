install.packages("htmlwidgets")
install.packages("devtools")
library("htmlwidgets")
library("devtools")

devtools::install("./divwheel")
library(divwheel)
colors_odds <-  c("#E81F2D", "#3DAE4A", "#2B9B4A", "#C42738", "#ED422B", "#972E47", "#972E47", "#2B9B4A")
divwheelnav(c(1,0,0,0,1,1,1,1,2,0,0,2,1,1,1,1,0,1), c("ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1","ODD1"), colors_odds)

# create package using devtools
#devtools::create("divwheel")  
#setwd("divwheel")  
#scaffoldWidget("divwheelnav", edit = FALSE)
#install()

#library(divwheel)
#divwheelnav("hello, world")
