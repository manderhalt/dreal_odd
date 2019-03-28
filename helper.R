source("data.R")
library(ggplot2)
library(jpeg)
library(gridExtra)
library(grid)

# HISTO
get_data <- function(departement_code, epci_code){
  departement_data <- DF_DEP[DF_DEP$CodeZone==departement_code,]
  epci_data <- DF_EPCI[DF_EPCI$CodeZone==epci_code,]
  list("departement_data"=departement_data, "epci_data"=epci_data)
}

sourceDir <- getSrcDirectory(function(dummy) {dummy})
horiz_histo <- function(departement_code, epci_code, question_code){
  if (is.null(question_code)){
    return(NULL)
  }
  data<- get_data(departement_code, epci_code)
  departement_data <- data$departement_data
  epci_data <- data$epci_data
  dat <- data.frame(
    question_result = factor(c(departement_data$Zone,epci_data$Zone), levels=c(departement_data$Zone,epci_data$Zone)),
    c_values = c(departement_data[[question_code]], epci_data[[question_code]]))
  
  logos <- logos_from_code_indic(question_code)
  if (length(logos)>1){
    img_1 <- readJPEG(paste("./www/",logos[[1]], ".jpg", sep=""))
    img_2 <- readJPEG(paste("./www/",logos[[2]], ".jpg", sep=""))
    g_1 <- rasterGrob(img_1, interpolate=TRUE)
    g_2 <- rasterGrob(img_2, interpolate=TRUE)
    ggplot(data=dat, aes(x=question_result, y=c_values)) +
      geom_bar(stat="identity", fill=I("#56B4E9"), width = 0.5) +
      coord_flip() + theme_bw() + 
      annotation_custom(g_1, xmin = 1, xmax = 2, ymin = 0, ymax=max(dat$c_values)/2)+
      annotation_custom(g_2, xmin = 1, xmax = 2, ymin = max(dat$c_values)/2, ymax=Inf)+
      ggtitle(QUESTION[QUESTION$Code_indicateur==question_code,][["Libel"]]) +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), aspect.ratio = 1/3,
            panel.grid.minor = element_blank(), axis.title.x = element_blank(), axis.title.y = element_blank())
    
    
  }
  else {
    img <- readJPEG(paste("./www/",logos[[1]], ".jpg", sep=""))
    
    g <- rasterGrob(img, interpolate=TRUE)
    ggplot(data=dat, aes(x=question_result, y=c_values)) +
      geom_bar(stat="identity", fill=I("#56B4E9"), width = 0.5) +
      coord_flip() + theme_bw() + 
      annotation_custom(g, xmin = 1, xmax = 2, ymin = -Inf, ymax=Inf)+
      ggtitle(QUESTION[QUESTION$Code_indicateur==question_code,][["Libel"]]) +
      theme(panel.border = element_blank(), panel.grid.major = element_blank(), aspect.ratio = 1/3,
            panel.grid.minor = element_blank(), axis.title.x = element_blank(), axis.title.y = element_blank())
  }
  
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
    1
  }
  else {
    0
  }
}

logos_from_code_indic <- function(code_indicateur){
  odd = IND[IND$code_indicateur==code_indicateur,][["num_ODD"]]
  list_logo = strsplit(odd,";")[[1]]
  list_logo
}

get_all_logos_odd <- function(){
  all_logos = c()
  for (code_indicateur in QUESTION$Code_indicateur){
    new_logos <- logos_from_code_indic(code_indicateur)[[1]]
    all_logos <- c(all_logos, new_logos)
  }
  all_logos
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
