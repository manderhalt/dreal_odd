setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

if (!require("htmlwidgets"))
  install.packages("htmlwidgets")
if (!require("devtools"))
  install.packages("devtools")
library("htmlwidgets")
library("devtools")

devtools::install("../divwheel")
library(divwheel)
reload(pkg="../divwheel")
all_logos <- all_odd()
title_alert <- replicate(17, "ODD1")
text_alert <- replicate(17, "Votre territoire a un taux d'emploi de 75 %, tandis que celui de votre département est de 60 %")
colors <- get_all_colors_from_list_odds(all_logos)
lgl <- integer(17)+2
divwheelnav(lgl, all_logos, colors, title_alert, text_alert)

# create package using devtools
#devtools::create("divwheel")  
#setwd("divwheel")  
#scaffoldWidget("divwheelnav", edit = FALSE)
#install()

#library(divwheel)
#divwheelnav("hello, world")
