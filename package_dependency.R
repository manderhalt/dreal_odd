install.packages("htmlwidgets")
install.packages("devtools")
library("htmlwidgets")
library("devtools")

devtools::install("./divwheel")
library(divwheel)
all_logos <- all_odd()
colors <- get_all_colors_from_list_odds(all_logos)
lgl <- integer(17)+2
divwheelnav(lgl, all_logos, colors)

# create package using devtools
#devtools::create("divwheel")  
#setwd("divwheel")  
#scaffoldWidget("divwheelnav", edit = FALSE)
#install()

#library(divwheel)
#divwheelnav("hello, world")
