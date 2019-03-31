source("data.R")
library(ggplot2)
library(jpeg)
library(gridExtra)
library(grid)
sourceDir <- getSrcDirectory(function(dummy) {dummy})

# HISTO
get_data <- function(departement_code, epci_code){
  departement_data <- DF_DEP[DF_DEP$CodeZone==departement_code,]
  epci_data <- DF_EPCI[DF_EPCI$CodeZone==epci_code,]
  list("departement_data"=departement_data, "epci_data"=epci_data)
}

horiz_histo <- function(departement_code, epci_code, question_code){
  if (is.null(question_code)){
    return(NULL)
  }
  data<- get_data(departement_code, epci_code)
  departement_data <- data$departement_data
  epci_data <- data$epci_data
  c_values = c(departement_data[[question_code]], epci_data[[question_code]])
  return(c_values)
}

# QUESTIONS
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

get_correct_or_wrong_answer <- function(response_user, real_answer){
  if (response_user == "NO"){
    return (2)
  }
  if (response_user == real_answer){
    return(1)
  }
  else {
    return(0)
  }
}

# LOGOS 
logos_from_code_indic <- function(code_indicateur){
  odd = IND[IND$code_indicateur==code_indicateur,][["num_ODD"]]
  list_logo = strsplit(odd,";")[[1]]
  list_logo
}

number_from_code_indic <- function(code_indicateur){
  logos <- logos_from_code_indic(code_indicateur)
  list_number <-c()
  for (logo in logos){
    integer <- unlist(strsplit(logo, split='DD', fixed=TRUE))[2]
    integer <- as.integer(integer)
    list_number <- c(list_number, integer)
  }
  return (list_number)
}

get_all_logos_odd <- function(){
  all_logos = c()
  for (code_indicateur in QUESTION$Code_indicateur){
    new_logos <- logos_from_code_indic(code_indicateur)[[1]]
    all_logos <- c(all_logos, new_logos)
  }
  all_logos
}

all_odd <- function(){
  all_odd = c()
  for (i in (1:17)){
    cur_odd <- paste("ODD", i, sep="")
    all_odd <- c(all_odd, cur_odd)
  }
  return (all_odd)
}

get_all_colors_from_list_odds <- function(list_logos){
  all_colors <- c()
  for (logo in list_logos){
    cur_color <- COLORS[[logo]]
    all_colors <- c(all_colors, cur_color)
  }
  all_colors
}

get_code_indicateur_from_odd <- function(odd){
  list_code_indic <- c()
  for (row in 1:nrow(IND)){
    odd_cur_line <- IND[row, "num_ODD"]
    list_odd_line <- strsplit(odd_cur_line, ";")[[1]]
    if (is.element(odd, list_odd_line)){
      list_code_indic <- c(list_code_indic, IND[row, "code_indicateur"])
    }
  }
  list_code_indic
}
