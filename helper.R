# DIVWHEEL
get_divwheel_text_from_question_numbers <- function(question, numbers){
  first_part <- paste(gsub(":", " de", question$Libel), numbers[[1]], "%")
  det <- substr(question$Libel, start=1, stop=2)
  if (grepl("a", det)){
    second_part <- paste(", tandis que celle de votre département est de", numbers[[2]], "%.")
  }
  else {
  second_part <- paste(", tandis que celui de votre département est de", numbers[[2]], "%.")
  }
  final <- paste(first_part, second_part)
  return (final)
}

get_numbers_from_question <- function(question, epci, dep) {
  line_epci <- DF_EPCI[DF_EPCI$CodeZone == epci,]
  line_dep <- DF_DEP[DF_DEP$CodeZone == dep,]
  answer_epci <- round(line_epci[[question]],digits = 1)
  answer_dep <- round(line_dep[[question]], digits = 1)
  return (c(answer_epci, answer_dep))
}

# HISTO
get_data <- function(departement_code, epci_code){
  region_code <- DEP_TO_REGION[DEP_TO_REGION$DEP==departement_code, ]$REGION
  
  departement_data <- DF_DEP[DF_DEP$CodeZone==departement_code,]
  epci_data <- DF_EPCI[DF_EPCI$CodeZone==epci_code,]
  region_data <- DF_REG[DF_REG$CodeZone==region_code,]
  list("departement_data"=departement_data, "epci_data"=epci_data, "region_data"=region_data, "fm_data"=DF_FR)
}

get_region_name_from_dep <- function(departement){
  region_code <- DEP_TO_REGION[DEP_TO_REGION$DEP==departement, ]$REGION
  region <- DF_REG[DF_REG$CodeZone==region_code, ]$Zone
  return(region)
}

horiz_histo <- function(departement_code, epci_code, question_code){
  if (is.null(question_code)){
    return(NULL)
  }
  data<- get_data(departement_code, epci_code)
  departement_data <- data$departement_data
  epci_data <- data$epci_data
  region_data <- data$region_data
  fm_data <- data$fm_data
  
  
  c_values = c(epci_data[[question_code]], departement_data[[question_code]], region_data[[question_code]], fm_data[[question_code]])
  return(c_values)
}

# QUESTIONS
get_choices_labels_from_question<- function(question_libel){
  det <- substr(question_libel, start=1, stop=2)
  if (grepl("a", det)){
    return (c("Inférieure", "Supérieure", "Je ne sais pas"))
  }
  else{
    return (c("Inférieur", "Supérieur", "Je ne sais pas"))
  }
}
get_colored_names <- function(choice_names, type_answer, bonne_reponse){
  if (type_answer == 2){
    if (bonne_reponse==1){
      choice_names[[2]] = tags$span(style = "color:green", choice_names[[2]])
    }
    else if (bonne_reponse==0){
      choice_names[[1]] = tags$span(style = "color:green", choice_names[[1]])
    }
  }
  else if (type_answer==1){
    if (bonne_reponse==1){
      choice_names[[2]] = tags$span(style = "color:green", choice_names[[2]])
    }
    else if (bonne_reponse==0){
      choice_names[[1]] = tags$span(style = "color:green", choice_names[[1]])
    }
  }
  else if (type_answer==0){
    if (bonne_reponse==1){
      choice_names[[1]] = tags$span(style = "color:red", choice_names[[1]])
      choice_names[[2]] = tags$span(style = "color:green", choice_names[[2]])
    }
    else if (bonne_reponse==0){
      choice_names[[1]] = tags$span(style = "color:green", choice_names[[1]])
      choice_names[[2]] = tags$span(style = "color:red", choice_names[[2]])
    }
  }
  return (choice_names)
}

get_under_over_from_question <- function(question, epci, dep){
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

get_result_from_question <- function(question, epci, dep){
  # code indicateur de la question, code zone, numéro de dep
  line_epci <- DF_EPCI[DF_EPCI$CodeZone == epci,]
  line_dep <- DF_DEP[DF_DEP$CodeZone == dep,]
  answer_epci <- line_epci[[question]]
  answer_dep <- line_dep[[question]]
  ind <- IND[IND$code_indicateur==question,]
  if (ind$Objectif_EPCI_vs_DEP == "plus"){
    if (answer_epci> answer_dep) {
      return (1)
    }
    else {
      return (0)
    }
  }
  if (ind$Objectif_EPCI_vs_DEP == "moins"){
    if (answer_epci< answer_dep) {
      return (1)
    }
    else {
      return (0)
    }
  }
  if (ind$Objectif_EPCI_vs_DEP=="50-50") {
    if (abs(50-answer_epci)< abs(50-answer_dep)) {
      return (1)
    }
    else {
      return (0)
    }
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
  if (is.null(response_user)){
    return (2)
  }
  if (response_user == 3){
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

get_all_colors_from_list_odds <- function(){
  list_logos <- all_odd()
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

get_graph <- function(values, names, unit){
  scale <- max(values)
  list_to_keep <- c()
  for (i in 1:4){
    if (values[[i]]!=0){
      list_to_keep <- c(list_to_keep, i)
    }
  }
  colors2 <-c('#A9D0F5', '#F2F2F2', '#F2F2F2', '#F2F2F2')
  values <- values[list_to_keep]
  colors2 <- colors2[list_to_keep]
  names <- names[list_to_keep]
  ax <- list(
    title = "",
    zeroline = FALSE,
    showline = FALSE,
    showticklabels = FALSE,
    showgrid = FALSE,
    categoryorder = "array",
    categoryarray = rev(names)
  )
  plotbar <-plot_ly(type="bar", x=values, y=names, showlegend=FALSE, hoverinfo = 'none',
                    marker= list(color=colors2))%>%
    layout(xaxis = ax, yaxis = ax)%>%
    config(displayModeBar = F) %>% 
  
    add_annotations(text = names,
                    x = values/2,
                    y = names,
                    xref = "x",
                    yref = "y",
                    font = list(family = 'Roboto',
                                size = 16,
                                color = 'black'),
                    showarrow = FALSE)%>%
    add_annotations(x = max(values)+0.25*max(values),  y = names,
                    text = paste(round(values, 2), unit),
                    font = list(family = 'Arial', size = 12),
                    showarrow = FALSE)%>%
    layout(plot_bgcolor='transparent') %>% 
    layout(paper_bgcolor='transparent') %>%
    add_annotations(x = max(values)/2, y=1.5, valign="middle", text=stri_dup("-",20), showarrow=FALSE)
  return (plotbar)
}
