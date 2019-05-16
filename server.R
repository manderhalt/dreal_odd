# Define server logic required to draw a histogram ----
source("data.R")
source("helper.R")
source("data_connect.R")
if (!require("dplyr"))
  install.packages("dplyr")
library(dplyr)
if (!require("rlist"))
  install.packages("rlist")
library("rlist")

max_img <- 7
max_plot <- 7

server <- function(input, output, session) {
  
  # PREMIERE PAGE
  # TITRE PARAGRAPHE D INTRO
  output$caption <-  renderText({ TITLE})
  output$intro_text <- renderText({INTRO_TEXT})
  output$catchphrase <- renderText({ CATCHPHRASE})
  output$image_dreal <- renderImage({
    list(
      src = "logo_fr_dreal.png",
      contentType = 'image/png',
      width = "100%"
    )}, deleteFile = FALSE)
  
  # SELECTION DEPARTEMENT
  output$departement <- renderUI({
    selectInput("departement", 
                "Quel est votre département ?",
                DF_DEP[order(DF_DEP$Zone),]$Zone)
    })
  
  departement <- reactive({departement_number <- DF_DEP[DF_DEP$Zone == input$departement,]})
  
  output$commune <- renderUI({
    list_communes <- filter(DF_DEP_EPCI, dept == departement()$CodeZone)[["nom_membre"]]
    list_communes <- list_communes[order(list_communes)]
    selectInput(
      "commune_string",
      "Quelle est votre commune ?",
      choices = list_communes
    )
  })
  
  epci <-reactive({epci <-
    filter(
      filter(DF_DEP_EPCI, nom_membre == input$commune_string),
      dept == departement()$CodeZone
    )
  })
  output$epci_text <- renderText({paste("Votre territoire (EPCI) est: ", epci()$raison_sociale)})
  
  #FORM
  
  output$plots_and_radios <- renderUI({
    plot_and_radio_output_list <- lapply(1:length(QUESTION$Libel), function(question_number){
    current_question <- QUESTION[question_number,]
    cur_libel <- current_question$Libel
    logos <- logos_from_code_indic(current_question$Code_indicateur)
    if (length(logos)>1){
      img_file_1 = paste(logos[[1]],".png", sep="")
      img_file_2 = paste(logos[[2]],".png", sep="")
      list(
        radioButtons(inputId=paste("question_",current_question$Num_question,sep=''), 
                     label=cur_libel, inline=TRUE, selected = character(0),
                     choiceNames=get_choices_labels_from_question(cur_libel), choiceValues=CHOICEVALUES
        ),
        img(src=img_file_1, width = 50), img(src=img_file_2, width = 50))
    }
    else {
      img_file = paste(logos[[1]],".png", sep="")
      list(
        radioButtons(inputId=paste("question_",current_question$Num_question,sep=''), 
                     label=current_question$Libel, 
                     choiceNames=get_choices_labels_from_question(cur_libel), 
                     choiceValues=CHOICEVALUES, 
                     inline=TRUE, selected = character(0)),
        img(src=img_file, width = 50))
    }
  })
    do.call(tagList, unlist(plot_and_radio_output_list, recursive=FALSE))
  })
  
  observeEvent(input$submitBtn, {
    
    lapply(1:length(QUESTION$Libel), function(question_number){
      current_question <- QUESTION[question_number,]
      cur_libel <- current_question$Libel
      input_id <- paste("question_",current_question$Num_question,sep='')
      bonne_reponse <- get_result_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_user <- input[[input_id]]
      type_answer <- get_correct_or_wrong_answer(response_user, bonne_reponse)
      choice_names <- as.list(get_choices_labels_from_question(cur_libel))
      choice_names <- get_colored_names(choice_names, type_answer, bonne_reponse)
      marker_to_select = 3
      if (!is.null(input[[input_id]])){
        marker_to_select = input[[input_id]]
      }
     updateRadioButtons(session, 
                        inputId=input_id,
                        label=current_question$Libel,
                        inline=TRUE,
                        choiceNames=choice_names, choiceValues = CHOICEVALUES, selected = marker_to_select) 
    })
  })
  
  
  # DIVWHEEL
  observeEvent(input$refresh, {session$reload()})
  response_all <- integer(17)+3
  text_alert_all <- replicate(17, "")
  all_logos <- replicate(17, "")
  event_submit_button_wheel <- eventReactive(input$submitBtn, {
    
    lapply(1:nrow(QUESTION), function(question_number){
      current_question <- QUESTION[question_number,]
      question_input_id <- paste("question_",current_question$Num_question,sep='')
      bonne_reponse <- get_result_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_user <- input[[question_input_id]]
      cur_odd <- number_from_code_indic(current_question$Code_indicateur)[[1]]
      type_answer <- get_correct_or_wrong_answer(response_user, bonne_reponse)
      numbers <- get_numbers_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_all[cur_odd] <<- bonne_reponse
      all_logos[cur_odd] <<- paste("ODD", cur_odd, sep="")
      text_alert_all[cur_odd] <<- get_divwheel_text_from_question_numbers(question = current_question, numbers = numbers)
    })
    title_alert <- all_logos
    
    divwheelnav(response_all, all_logos, get_all_colors_from_list_odds(), title_alert, text_alert_all, width="100%")

  })
  
  wheel_title <- reactiveVal("")
  wheel_legend <- reactiveVal("")
  observeEvent(input$submitBtn, {
    wheel_title(WHEEL_TITLE)
    wheel_legend(WHEEL_LEGEND)
  })
  output$wheel_title <- renderText(wheel_title())
  output$wheel_legend <- renderText(wheel_legend())
  output$nav_output <- renderDivwheelnav(event_submit_button_wheel())
  
  # DEUXIEME PAGE
  # CHOIX DEPARTEMENT
  output$departement_2 <- renderUI({
    selectInput("departement_2", 
                "Quel est votre département ?",
                DF_DEP[order(DF_DEP$Zone),]$Zone, 
                selected = input$departement)
    })
  
  departement_2 <-reactive({departement_number <- DF_DEP[DF_DEP$Zone == input$departement_2,]})
  output$commune_2 <- renderUI({
    list_communes_2 <- filter(DF_DEP_EPCI, dept == departement_2()$CodeZone)[["nom_membre"]]
    list_communes_2 <- list_communes_2[order(list_communes_2)]
    selectInput(
      "commune_string_2",
      "Quelle est votre commune ?",
      choices = list_communes_2, selected = input$commune_string
    )
  })
  
  epci_2 <- reactive({
    epci_2 <-filter(filter(DF_DEP_EPCI, nom_membre == input$commune_string_2),
                    dept == departement_2()$CodeZone)
  })
  
  output$epci_text_2 <-renderText({paste("Votre territoire est: ", epci_2()$raison_sociale)})
  
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
    list_image_all <- list()
    for (i in list_code_indic){
      list_image <- c()
      cur_logos <- logos_from_code_indic(i)
      for (logo in cur_logos){
        list_image <- NULL
        if (logo != odd){
          cur_img = paste("www/", logo, ".png", sep="")
          list_image <- c(list_image, cur_img)
        }
        else {
          list_image <- c(list_image, "")
        }
      }
      list_image_all <- c(list_image_all, list(list_image))
    }
    
    observeEvent(input[[button]], {
      list_images_to_plot = list()
      for (i in list_image_all){
        cur_img <- NULL
        for (j in i){
          if (j !=""){
            cur_img <- list(src=j, height=60)
          }
        }
        list_images_to_plot <- list.append(list_images_to_plot, cur_img)
        
      }
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
      output[[plotname]]<- renderPlotly({get_graph(
        outgraph()[[my_j]],
        c("Votre territoire", input$departement_2, "Votre région", "National")
        )})
      # output[[plotname]]<- renderPlot({barplot(outgraph()[[my_j]], horiz=TRUE,names.arg=c("Dep", "EPCI"), col="deepskyblue2")})
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
  
  url <- a("Sources ODD", href=source_odd)
  output$tessst <- renderText({"lol"})
  output$source_odd <- renderUI({tagList(url)})
  outputOptions(output, "sidetext1", suspendWhenHidden = FALSE)
  outputOptions(output, "sidetext2", suspendWhenHidden = FALSE)
  outputOptions(output, "sidetext3", suspendWhenHidden = FALSE)
  outputOptions(output, "sidetext4", suspendWhenHidden = FALSE)
  outputOptions(output, "sidetext5", suspendWhenHidden = FALSE)
  
  # TROISIEME PAGE
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
  
  output$no_indicateur <- renderText({PAS_INDICATEUR})
}
