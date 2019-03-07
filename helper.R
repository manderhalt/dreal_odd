source("data.R")
library(ggplot2)
library(jpeg)
library(gridExtra)
library(grid)


get_data <- function(departement_code, epci_code){
  departement_data <- DF_DEP[DF_DEP$CodeZone==departement_code,]
  epci_data <- DF_EPCI[DF_EPCI$CodeZone==epci_code,]
  list("departement_data"=departement_data, "epci_data"=epci_data)
}
sourceDir <- getSrcDirectory(function(dummy) {dummy})
horiz_histo <- function(departement_code, epci_code, question_code){
  data<- get_data(departement_code, epci_code)
  departement_data <- data$departement_data
  epci_data <- data$epci_data
  dat <- data.frame(
    question_result = factor(c(departement_data$Zone,epci_data$Zone), levels=c(departement_data$Zone,epci_data$Zone)),
    c_values = c(departement_data[[question_code]], epci_data[[question_code]]))
  
  img <- readJPEG("./www/ODD_1.jpg")
  g <- rasterGrob(img, interpolate=TRUE)
  
  ggplot(data=dat, aes(x=question_result, y=c_values)) +
    geom_bar(stat="identity", fill=I("#56B4E9"), width = 0.5) +
    coord_flip() + theme_bw() + 
    annotation_custom(g, xmin=1, xmax=2, ymin=0, ymax=Inf)+
    ggtitle(QUESTION[QUESTION$Code_indicateur==question_code,][["Libel"]]) +
    theme(panel.border = element_blank(), panel.grid.major = element_blank(), aspect.ratio = 1/3,
                                      panel.grid.minor = element_blank(), axis.title.x = element_blank(), axis.title.y = element_blank())
  
  
  #annotation_custom(rasterGrob(img))
  
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

logos_from_code_indic <- function(code_indicateur){
  img = readPNG(system.file("img", "Rlogo.png", package="png"))
  
  gg = gg + 
    annotation_custom(rasterGrob(img), 
                      xmin=0.95*min(mtcars$mpg)-1, xmax=0.95*min(mtcars$mpg)+1, 
                      ymin=0.62*min(mtcars$wt)-0.5, ymax=0.62*min(mtcars$wt)+0.5)
}
