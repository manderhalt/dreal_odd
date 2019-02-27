source("data.R")
library(plotly)
packageVersion('plotly')

get_data <- function(departement_code, epci_code){
  departement_data <- DF_DEP[DF_DEP$CodeZone==departement_code,]
  epci_data <- DF_EPCI[DF_EPCI$CodeZone==epci_code,]
  list("departement_data"=departement_data, "epci_data"=epci_data)
}

horiz_histo <- function(departement_code, epci_code, question_code){
  data<- get_data(departement_code, epci_code)
  departement_data <- data$departement_data
  epci_data <- data$epci_data
  barplot(c(departement_data[[question_code]], epci_data[[question_code]]), main=QUESTION[QUESTION$Code_indicateur==question_code,]$Libel, horiz=TRUE,
          names.arg=c(departement_data$Zone,epci_data$Zone))
}