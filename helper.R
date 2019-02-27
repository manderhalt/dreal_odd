source("data.R")
library(plotly)
packageVersion('plotly')
horiz_histo <- function(){
  barplot(c(QUIZZ_ODD_DEP$I_01_03_4[[1]], QUIZZ_ODD_EPCI$I_01_03_4[[1]]), main=QUESTION$Libel[[1]], horiz=TRUE,
          names.arg=c("Ain","EPCI"))
}
