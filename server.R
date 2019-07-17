server <- function(input, output, session) {
 
  
  # PREMIERE PAGE
  # Logo gauche
  output$image_dreal <- renderImage({
    list(
      src = "logo_fr_dreal.png",
      contentType = 'image/png',
      width = "100%"
    )}, deleteFile = FALSE)
  
  # SELECTION DEPARTEMENT
  output$departement <- renderUI({
    DF_GOOD_DEP <- subset(DF_DEP, DF_DEP$CodeZone %in% ACCEPTED_DEPT)
    selectInput("departement", 
                "Quel est votre département ?",
                DF_GOOD_DEP[order(DF_GOOD_DEP$Zone),]$Zone)
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
  output$epci_text <- renderText({paste("Votre territoire (EPCI) est : ", epci()$raison_sociale)})
  
  #FORM
  
  lapply(1:length(QUESTION[["Question.QUIZ"]]), function(question_number){
    size_img <- "30%"
    current_question <- QUESTION[question_number,]
    cur_libel <- current_question[["Question.QUIZ"]]
    radio_button <- paste("radio_button_", question_number, sep="")
    radio_img <- paste("radio_img_", question_number, sep="")
    logos <- logos_from_code_indic(current_question$code_indicateur)
    if (length(logos)>1){
      img_file_1 = paste(logos[[1]],".png", sep="")
      img_file_2 = paste(logos[[2]],".png", sep="")
      
     output[[radio_img]] <- renderUI({ list(img(src=img_file_1, width = size_img), img(src=img_file_2, width = size_img))})
    }
    else {
      img_file = paste(logos[[1]],".png", sep="")
      
        output[[radio_img]] <- renderUI({img(src=img_file, width = size_img)})
    }
    output[[radio_button]] <- renderUI({ radioButtons(inputId=paste("question_",question_number,sep=''), 
                                         label=cur_libel, inline=TRUE, selected = character(0),
                                         choiceNames=get_choices_labels_from_question(cur_libel), choiceValues=CHOICEVALUES
    )})
  })
  
  
  observeEvent(input$submitBtn, {
    
    lapply(1:length(QUESTION[["Question.QUIZ"]]), function(question_number){
      current_question <- QUESTION[question_number,]
      cur_libel <- current_question[["Question.QUIZ"]]
      input_id <- paste("question_",question_number,sep='')
      bonne_reponse <- get_under_over_from_question(current_question$code_indicateur,epci()$siren, departement()$CodeZone)
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
                        label=current_question[["Question.QUIZ"]],
                        inline=TRUE,
                        choiceNames=choice_names, choiceValues = CHOICEVALUES, selected = marker_to_select) 
    })
  })
  
  event_submit_legend_wheel <- eventReactive(input$submitBtn, {
    "./www/green_tile.png"
  })
  output$green_tile <- renderImage({list(src=event_submit_legend_wheel(),contentType = 'image/png'
  )}, deleteFile = FALSE)
  
  # DIVWHEEL
  observeEvent(input$refresh, {session$reload()})
  response_all <- integer(17)+3
  text_alert_all <- replicate(17, "")
  all_logos <- replicate(17, "")
  event_submit_button_wheel <- eventReactive(input$submitBtn, {
    questionnaire_id <- get_last_questionnaire_id()[[1]]+1
    
    lapply(1:nrow(QUESTION), function(question_number){
      current_question <- QUESTION[question_number,]
      question_input_id <- paste("question_",question_number,sep='')
      
      bonne_reponse <- get_result_from_question(current_question$code_indicateur,epci()$siren, departement()$CodeZone)
      type_answer <- get_under_over_from_question(current_question$code_indicateur,epci()$siren, departement()$CodeZone)
      response_user <- input[[question_input_id]]
      cur_odd <- number_from_code_indic(current_question$code_indicateur)[[1]]
      numbers <- get_numbers_from_question(current_question$code_indicateur,epci()$siren, departement()$CodeZone)
      response_all[cur_odd] <<- bonne_reponse
      all_logos[cur_odd] <<- paste("ODD", cur_odd, sep="")
      text_alert_all[cur_odd] <<- get_divwheel_text_from_question_numbers(question = current_question, numbers = numbers)
      if (is.null(response_user)){
        response_to_send_sql <- 3
      }
      else {
        response_to_send_sql <- response_user
      }
      insert_answer(question_label = current_question[["Question.QUIZ"]], 
                    answer_question = response_to_send_sql, 
                    right_answer = type_answer,
                    date_submit = Sys.Date(),
                    dep = departement()$CodeZone,
                    epci = epci()$siren,
                    questionnaire_id = questionnaire_id
                    )
    })
    title_alert <- all_logos
    
    divwheelnav(response_all, all_logos, get_all_colors_from_list_odds(), title_alert, text_alert_all, 
                width = (0.95*as.numeric(input$dimension[1])), height = (0.95*as.numeric(input$dimension[1])))

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
    DF_GOOD_DEP <- subset(DF_DEP, DF_DEP$CodeZone %in% ACCEPTED_DEPT)
    selectInput("departement_2", 
                "Quel est votre département ?",
                DF_GOOD_DEP[order(DF_GOOD_DEP$Zone),]$Zone, 
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
  
  output$epci_text_2 <-renderText({paste("Votre territoire est : ", epci_2()$raison_sociale)})
  
  # LOGOS
  outgraph <- reactiveVal()
  outtextgraph <- reactiveVal()
  sidetextgraph <- reactiveVal()
  no_indicateur <- reactiveVal()
  source_entity <- reactiveVal()
  code_indic <- reactiveVal()
  rightoddimage <- reactiveVal(NULL)
  lapply(1:17, function(i) {
    button <- paste("ODD_button_graph", i, sep="")
    observeEvent({input[[button]]
    }
    , {
    odd_text <- paste("odd", i, sep="")
    odd <- paste("ODD", i, sep="")
    list_code_indic <- get_code_indicateur_from_odd(odd)
    list_image_all <- list()
    for (i in list_code_indic){
      list_image <- c()
      cur_logos <- logos_from_code_indic(i)
      for (logo in cur_logos){
          cur_img = paste(logo, ".png", sep="")
          list_image <- c(list_image, cur_img)
      }
      list_image_all <- c(list_image_all, list(list_image))
    }
    
    
      list_images_to_plot = list()
      list_source_entity = list()
      for (i in list_image_all){
        cur_img = c()
        for (j in i){
          if (j !=""){
            cur_img <- c(cur_img, j)
          }
          
        }
        list_images_to_plot <- list.append(list_images_to_plot, cur_img)
      }
      list_graph_values_to_plot = list()
      list_side_text = list()
      for (i in list_code_indic){
        cur_values <- horiz_histo(departement_2()$CodeZone,
                                  epci_2()$siren,
                                  i)
        if (length(cur_values)>1){
        list_graph_values_to_plot <- list.append(list_graph_values_to_plot, cur_values)
        
        cur_source = paste("Source:",IND[IND$code_indicateur==i,]$source, IND[IND$code_indicateur==i,]$annee)
        list_source_entity <- list.append(list_source_entity, cur_source)
        list_side_text <- list.append(list_side_text, IND[IND$code_indicateur==i,]$libel_court)
        }
      }
      if (length(list_graph_values_to_plot)==0){
        no_indicateur(PAS_INDICATEUR)
      }
      outgraph(list_graph_values_to_plot)
      outtextgraph(ODD_TEXT[ODD_TEXT[["ODD"]]==odd_text,]$ODD_TITLE)
      sidetextgraph(list_side_text)
      rightoddimage(list_images_to_plot)
      source_entity(list_source_entity)
      code_indic(list_code_indic)
      
      
    })
  })
  output$text_graph <- renderText({outtextgraph()})
  
  # SIDE TEXT
  output$cur_odd <- renderUI({
    lapply(1:length(sidetextgraph()), function(cur_odd){
      if (length(rightoddimage()[[cur_odd]])>1){
      fluidRow(
        column(6, h4(tags$b(sidetextgraph()[[cur_odd]])), 
               renderPlotly({
                    if (cur_odd<=length(code_indic())){
                      cur_indic <- code_indic()[[cur_odd]]
                      unit <- IND[IND$code_indicateur==cur_indic,]$unite
                      get_graph(
                        outgraph()[[cur_odd]],
                        c(epci_2()$raison_sociale, input$departement_2, get_region_name_from_dep(departement_2()$CodeZone), "France"), unit
                      )
                      }}),
        h5(source_entity()[[cur_odd]])),
        column(6, br(), br(), br(), 
          
          tags$div(img(src = rightoddimage()[[cur_odd]][[1]], width = 70, height = 70),
                   img(src = rightoddimage()[[cur_odd]][[2]], width = 70, height = 70))
        
        )
      )
      }
      else {
        fluidRow(
          column(6, h4(tags$b(sidetextgraph()[[cur_odd]])), 
                 renderPlotly({
                   if (cur_odd<=length(code_indic())){
                     cur_indic <- code_indic()[[cur_odd]]
                     unit <- IND[IND$code_indicateur==cur_indic,]$unite
                     get_graph(
                       outgraph()[[cur_odd]],
                       c(epci_2()$raison_sociale, input$departement_2, get_region_name_from_dep(departement_2()$CodeZone), "France"), unit
                     )
                   }}),
                 h5(source_entity()[[cur_odd]])),
          column(6, br(), br(), br(), 
                 
                 tags$div(img(src = rightoddimage()[[cur_odd]][[1]], width = 70, height = 70))
                 
          )
        )
      }
    })
  })
  
  
  ###BUTTON
  
  outgraph_all <- reactiveVal()
  outtextgraph_all <- reactiveVal()
  sidetextgraph_all <- reactiveVal()
  source_entity_all <- reactiveVal()
  code_indic_all <- reactiveVal()
  rightoddimage_all <- reactiveVal()
  observeEvent({input[["wheel_small_button"]]
  }
  , {
    list_text_main <- list()
    list_side_text_all <- list()
    list_source_entity_all <- list()
    list_code_indic_all <- list()
    list_right_odd_image_all <- list()
    list_graph_all <- list()
  lapply(1:17, function(i) {
    
      odd_text <- paste("odd", i, sep="")
      odd <- paste("ODD", i, sep="")
      list_code_indic <- get_code_indicateur_from_odd(odd)
      list_image_all <- list()
      for (i in list_code_indic){
        list_image <- c()
        cur_logos <- logos_from_code_indic(i)
        for (logo in cur_logos){
          cur_img = paste(logo, ".png", sep="")
          list_image <- c(list_image, cur_img)
        }
        list_image_all <- c(list_image_all, list(list_image))
      }
      
      
      list_images_to_plot = list()
      list_source_entity = list()
      for (i in list_image_all){
        cur_img = c()
        for (j in i){
          if (j !=""){
            cur_img <- c(cur_img, j)
          }
          
        }
        list_images_to_plot <- list.append(list_images_to_plot, cur_img)
      }
      list_graph_values_to_plot = list()
      list_side_text = list()
      for (i in list_code_indic){
        cur_values <- horiz_histo(departement_2()$CodeZone,
                                  epci_2()$siren,
                                  i)
        if (length(cur_values)>1){
          list_graph_values_to_plot <- list.append(list_graph_values_to_plot, cur_values)
          
          cur_source = paste("Source:",IND[IND$code_indicateur==i,]$source, IND[IND$code_indicateur==i,]$annee)
          list_source_entity <- list.append(list_source_entity, cur_source)
          list_side_text <- list.append(list_side_text, IND[IND$code_indicateur==i,]$libel_court)
        }
      }
      if (length(list_graph_values_to_plot)==0){
        no_indicateur(PAS_INDICATEUR)
      }
      
      list_right_odd_image_all <<- list.append(list_right_odd_image_all, list_images_to_plot)
      list_code_indic_all <<- list.append(list_code_indic_all, list_code_indic)
      list_graph_all <<- list.append(list_graph_all, list_graph_values_to_plot)
      list_side_text_all <<- list.append(list_side_text_all, list_side_text)
      list_source_entity_all <<- list.append(list_source_entity_all, list_source_entity)
      list_text_main <<- list.append(list_text_main, ODD_TEXT[ODD_TEXT[["ODD"]]==odd_text,]$ODD_TITLE)
    
      
    })
  print(list_graph_all)
  print(list_text_main)
  print(list_side_text_all)
  print(list_code_indic_all)
  print(list_right_odd_image_all)
  
  outgraph_all(list_graph_all)
  outtextgraph_all(list_text_main)
  sidetextgraph_all(list_side_text_all)
  rightoddimage_all(list_right_odd_image_all)
  source_entity_all(list_source_entity_all)
  code_indic_all(list_code_indic_all)
  
  
  })
  lapply(1:17, function(cur_odd){
      odd_all_cur <- paste("odd_all_cur", cur_odd, sep="")
      odd_main_text <- paste("odd_main_text", cur_odd, sep="")
      output[[odd_main_text]]<- renderText({outtextgraph_all()[[cur_odd]]})
      output[[odd_all_cur]] <- renderUI({
        
        if(length(rightoddimage_all()[[cur_odd]])>=1){
      lapply(1:length(outgraph_all()[[cur_odd]]), function(cur_code){
        if (length(rightoddimage_all()[[cur_odd]][[cur_code]])>1){
          fluidRow(
            column(6, h4(tags$b(sidetextgraph_all()[[cur_odd]][[cur_code]])), 
                   renderPlotly({
                     if (cur_odd<=length(code_indic_all()[[cur_odd]])){
                       cur_indic <- code_indic_all()[[cur_odd]][[cur_code]]
                       unit <- IND[IND$code_indicateur==cur_indic,]$unite
                       get_graph(
                         outgraph_all()[[cur_odd]][[cur_code]],
                         c(epci_2()$raison_sociale, input$departement_2, get_region_name_from_dep(departement_2()$CodeZone), "France"), unit
                       )
                     }}),
                   h5(source_entity_all()[[cur_odd]][[cur_code]])),
            column(6, br(), br(), br(), 
                   
                   tags$div(img(src = rightoddimage_all()[[cur_odd]][[cur_code]][[1]], width = 70, height = 70),
                            img(src = rightoddimage_all()[[cur_odd]][[cur_code]][[2]], width = 70, height = 70))
                   
            )
          )
        }
        else {
          fluidRow(
            column(6, h4(tags$b(sidetextgraph_all()[[cur_odd]][[cur_code]])), 
                   renderPlotly({
                     if (cur_odd<=length(code_indic_all()[[cur_odd]])){
                       cur_indic <- code_indic_all()[[cur_odd]][[cur_code]]
                       unit <- IND[IND$code_indicateur==cur_indic,]$unite
                       get_graph(
                         outgraph_all()[[cur_odd]][[cur_code]],
                         c(epci_2()$raison_sociale, input$departement_2, get_region_name_from_dep(departement_2()$CodeZone), "France"), unit
                       )
                     }}),
                   h5(source_entity_all()[[cur_odd]][[cur_code]])),
            column(6, br(), br(), br(), 
                   
                   tags$div(img(src = rightoddimage_all()[[cur_odd]][[cur_code]][[1]], width = 70, height = 70))
                   
            )
          )
        }
      })
        }
    })
  })
  
  # TROISIEME PAGE
  # BOUTTONS LOGOS
  outtextgraphthird <- reactiveVal()
  outsubtextgraphthird <- reactiveVal()
  outtextgraphthirdlink <- reactiveVal()
  imgoutgraphthird <- reactiveVal()
  textwithlink <- reactiveVal()
  lapply(1:17, function(i) {
    button <- paste("ODD_button_", i, sep="")
    odd_text <- paste("odd", i, sep="")
    cur_text <- paste("text_odd_", i, sep="")
    odd_img <- paste("www/ODD", i, ".png", sep="")
    cur_subtext <- paste("subtext_odd_", i, sep="")
    cur_link <- paste("link_odd_", i, sep="")
    text_link <- paste("En savoir plus sur l'ODD", i, "sur le site")
    observeEvent(input[[button]], {
      outtextgraphthird(ODD_TEXT[ODD_TEXT[["ODD"]]==odd_text,]$ODD_TITLE)
      outsubtextgraphthird(ODD_TEXT[ODD_TEXT[["ODD"]]==odd_text,]$ODD_SUBTEXT)
      outtextgraphthirdlink(a("Agenda-2030.fr", href=ODD_TEXT[ODD_TEXT[["ODD"]]==odd_text,]$ODD_LINK))
      imgoutgraphthird(odd_img)
      textwithlink(text_link)
    })
    })
  output$text_odd <- renderText({outtextgraphthird()})
  output$subtext_odd <- renderText({outsubtextgraphthird()})
  output$third_link <- renderUI({outtextgraphthirdlink()})
  output$third_image <-renderImage({
    list(
      src = imgoutgraphthird(),
      contentType = 'image/png',
      width = "60%"
    )}, deleteFile = FALSE)
  output$third_text_with_link <- renderText({textwithlink()})
  
  output$no_indicateur <- renderText({no_indicateur()})
}
