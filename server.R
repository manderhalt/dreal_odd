# Define server logic required to draw a histogram ----
source("data.R")
source("helper.R")
if (!require("dplyr"))
  install.packages("dplyr")
library(dplyr)
if (!require("rlist"))
  install.packages("rlist")
library("rlist")
max_img <- 7
max_plot <- 7
server <- function(input, output) {
  
  # PREMIERE PAGE
  # TITRE PARAGRAPHE D INTRO
  output$caption <-  renderText({ TITLE})
  output$intro_text <- renderText({INTRO_TEXT})
  output$catchphrase <- renderText({ CATCHPHRASE})
  output$image_dreal <- renderImage({
    list(
      src = "logo_fr_dreal.png",
      contentType = 'image/png',
      width = 250,
      height = 250
    )}, deleteFile = FALSE)
  
  # SELECTION DEPARTEMENT
  departement <- reactive({departement_number <- DF_DEP[DF_DEP$Zone == input$department,]})
  output$commune <- renderUI({
    selectInput(
      "commune_string",
      "Quelle est votre commune ?",
      choices = filter(DF_DEP_EPCI, dept == departement()$CodeZone)[["nom_membre"]]
    )
  })
  epci <-reactive({epci <-
    filter(
      filter(DF_DEP_EPCI, nom_membre == input$commune_string),
      dept == departement()$CodeZone
    )
  })
  output$epci_text <- renderText({paste("Votre EPCI est: ", epci()$raison_sociale)})
  
  # DIVWHEEL
  response_all <- integer(17)+3
  event_submit_button_wheel <- eventReactive(input$submitBtn, {
    
    lapply(1:nrow(QUESTION), function(question_number){
      current_question <- QUESTION[question_number,]
      question_input_id <- paste("question_",current_question$Num_question,sep='')
      bonne_reponse <- get_result_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_user <- input[[question_input_id]]
      cur_odd <- number_from_code_indic(current_question$Code_indicateur)[[1]]
      type_answer <- get_correct_or_wrong_answer(response_user, bonne_reponse)
      
      response_all[cur_odd] <<- type_answer
    })
    all_logos <- all_odd()
    
    divwheelnav(response_all, all_logos, get_all_colors_from_list_odds(all_logos), width="100%")
  })
  
  output$nav_output <- renderDivwheelnav(event_submit_button_wheel())
  
  # DEUXIEME PAGE
  # BOUTTONS LOGOS
  out <- reactiveVal("")
  lapply(1:17, function(i) {
    button <- paste("ODD_button_", i, sep="")
    odd_text <- paste("odd_", i, "_text", sep="")
    observeEvent(input[[button]], {
      out(ODD_TEXT[[odd_text]])
    })
  })
  output$text_odd <- renderText({out()})
  
  # TROISIEME PAGE
  # CHOIX DEPARTEMENT
  departement_2 <-reactive({departement_number <- DF_DEP[DF_DEP$Zone == input$department_2,]})
  output$commune_2 <- renderUI({
    selectInput(
      "commune_string_2",
      "Quelle est votre commune ?",
      choices = filter(DF_DEP_EPCI, dept == departement_2()$CodeZone)[["nom_membre"]]
    )
  })
  epci_2 <- reactive({
    epci_2 <-filter(filter(DF_DEP_EPCI, nom_membre == input$commune_string_2),
                    dept == departement_2()$CodeZone)
  })
  output$epci_text_2 <-renderText({paste("Votre EPCI est: ", epci_2()$raison_sociale)})
  
  # LOGOS
  outgraph <- reactiveVal()
  outtextgraph <- reactiveVal()
  sidetextgraph <- reactiveVal()
  rightoddimage <- reactiveVal(NULL)
  lapply(1:17, function(i) {
    button <- paste("ODD_button_graph", i, sep="")
    odd_text <- paste("odd_", i, "_text", sep="")
    odd <- paste("ODD", i, sep="")
    list_code_indic <- get_code_indicateur_from_odd(odd)
    list_image = c()
    for (i in list_code_indic){
      cur_logos <- logos_from_code_indic(i)
      for (logo in cur_logos){
        cur_img = paste("www/", logo, ".jpg", sep="")
        list_image <- c(list_image, cur_img)
      }
    }
    
    
    code_indic <- NULL
    if (length(list_code_indic)>1){
      code_indic <-  list_code_indic[[1]]
    }
    observeEvent(input[[button]], {
      print(list_image)
      list_images_to_plot = list()
      for (i in list_image){
        cur_img <- list(src=i, height=60)
        list_images_to_plot <- list.append(list_images_to_plot, cur_img)
      }
      
      print(list_images_to_plot)
      list_graph_values_to_plot = list()
      for (i in list_code_indic){
        cur_values <- horiz_histo(departement_2()$CodeZone,
                                  epci_2()$siren,
                                  i)
        list_graph_values_to_plot <- list.append(list_graph_values_to_plot, cur_values)
      }
      outgraph(list_graph_values_to_plot)
      outtextgraph(ODD_TEXT[[odd_text]])
      sidetextgraph(subset(IND, IND$code_indicateur %in% list_code_indic)$libel_court)
      rightoddimage(list_images_to_plot)
      
    })
  })
  output$text_graph <- renderText({outtextgraph()})
  
  # SIDE TEXT
  output$side_text_graph <- renderUI({
    side_text <- sidetextgraph()
    text_output_list <- lapply(1:length(side_text), function(cur_text){
      text_name <- paste("sidetext", i, sep="")
      cur_text
    })
    do.call(tagList, text_output_list)
  })
  for(l in 1:max_plot){
    local({
      my_l <- l
      textname <- paste("sidetext", my_l, sep="")
      output[[textname]] <- renderText({sidetextgraph()[[my_l]]})
    })
  }
  
  output$plot_graph <- renderUI({
    plot_values <- outgraph()
    plot_output_list <- lapply(1:length(plot_values), function(cur_value){
      plot_name <- paste("plotgraph", i, sep="")
      cur_value
    })
    do.call(tagList, plot_output_list)
  })
  for (j in 1:max_plot){
    local({
      my_j <- j
      plotname <- paste("plotgraph", my_j, sep="")
      output[[plotname]]<- renderPlot({barplot(outgraph()[[my_j]], horiz=TRUE,names.arg=c("Dep", "EPCI"), col="deepskyblue2")})
    })
  }
  # ODD IMAGE
  output$right_odd_image <- renderUI({
    right_images <- rightoddimage()
    img_output_list <- lapply(1:length(right_images), function(cur_image){
      img_name <- paste("rightimage", i , sep="")
      cur_image
    })
    do.call(tagList, img_output_list)
    })
  for (i in 1:max_img){
    local({
      my_i <- i
      imgname <- paste("rightimage", my_i, sep="")
      output[[imgname]] <- renderImage({rightoddimage()[[my_i]]}, deleteFile = FALSE)
    })
  }
}
