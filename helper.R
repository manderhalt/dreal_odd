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
  dat <- data.frame(
    question_result = factor(c(departement_data$Zone,epci_data$Zone), levels=c(departement_data$Zone,epci_data$Zone)),
    c_values = c(departement_data[[question_code]], epci_data[[question_code]]))
  ggplot(data=dat, aes(x=question_result, y=c_values)) +
    geom_bar(stat="identity", fill=I("#56B4E9"), width = 0.5) +
    coord_flip() + theme_bw() + 
    ggtitle(QUESTION[QUESTION$Code_indicateur==question_code,][["Libel"]]) +
    theme(panel.border = element_blank(), panel.grid.major = element_blank(), aspect.ratio = 1/3,
                                      panel.grid.minor = element_blank(), axis.title.x = element_blank(), axis.title.y = element_blank())
  
}


get_result_from_question <- function(question, epci, dep){
  # code indicateur de la question, code zone, numéro de dep
  line_epci <- DF_EPCI[DF_EPCI$CodeZone == epci,]
  line_dep <- DF_DEP[DF_DEP$CodeZone == dep,]
  answer_epci <- line_epci[[question]]
  answer_dep <- line_dep[[question]]
  if (answer_epci> answer_dep) {
    1
  }
  else {
    0
  }
}

get_correct_result_from_form <- function(questions, epci, dep){
  result <- c()
  for (question in questions){
    result <- c(result, get_result_from_question(question, epci, dep))
  }
  result
}

get_correct_or_wrong_answer <- function(reponse_user, real_answer){
  if (reponse_user == real_answer){
    "Bonne réponse"
  }
  else {
    "Mauvaise réponse"
  }
}
