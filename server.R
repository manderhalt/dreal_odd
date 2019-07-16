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
  
  lapply(1:length(QUESTION$Libel), function(question_number){
    size_img <- "30%"
    current_question <- QUESTION[question_number,]
    cur_libel <- current_question$Libel
    radio_button <- paste("radio_button_", question_number, sep="")
    radio_img <- paste("radio_img_", question_number, sep="")
    logos <- logos_from_code_indic(current_question$Code_indicateur)
    if (length(logos)>1){
      img_file_1 = paste(logos[[1]],".png", sep="")
      img_file_2 = paste(logos[[2]],".png", sep="")
      
     output[[radio_img]] <- renderUI({ list(img(src=img_file_1, width = size_img), img(src=img_file_2, width = size_img))})
    }
    else {
      img_file = paste(logos[[1]],".png", sep="")
      
        output[[radio_img]] <- renderUI({img(src=img_file, width = size_img)})
    }
    output[[radio_button]] <- renderUI({ radioButtons(inputId=paste("question_",current_question$Num_question,sep=''), 
                                         label=cur_libel, inline=TRUE, selected = character(0),
                                         choiceNames=get_choices_labels_from_question(cur_libel), choiceValues=CHOICEVALUES
    )})
  })
  
  
  observeEvent(input$submitBtn, {
    
    lapply(1:length(QUESTION$Libel), function(question_number){
      current_question <- QUESTION[question_number,]
      cur_libel <- current_question$Libel
      input_id <- paste("question_",current_question$Num_question,sep='')
      bonne_reponse <- get_under_over_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
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
      question_input_id <- paste("question_",current_question$Num_question,sep='')
      
      bonne_reponse <- get_result_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      type_answer <- get_under_over_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_user <- input[[question_input_id]]
      cur_odd <- number_from_code_indic(current_question$Code_indicateur)[[1]]
      numbers <- get_numbers_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_all[cur_odd] <<- bonne_reponse
      all_logos[cur_odd] <<- paste("ODD", cur_odd, sep="")
      text_alert_all[cur_odd] <<- get_divwheel_text_from_question_numbers(question = current_question, numbers = numbers)
      if (is.null(response_user)){
        response_to_send_sql <- 3
      }
      else {
        response_to_send_sql <- response_user
      }
      insert_answer(question_label = current_question$Libel, 
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
    
    
      list_images_to_plot = list()
      list_source_entity = list()
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
      list_side_text = list()
      for (i in list_code_indic){
        cur_values <- horiz_histo(departement_2()$CodeZone,
                                  epci_2()$siren,
                                  i)
        if (length(cur_values)>1){
        list_graph_values_to_plot <- list.append(list_graph_values_to_plot, cur_values)
        
        cur_source = paste("Source:",IND[IND$code_indicateur==i,]$source)
        list_source_entity <- list.append(list_source_entity, cur_source)
        list_side_text <- list.append(list_side_text, IND[IND$code_indicateur==i,]$libel_court)
        }
      }
      if (length(list_graph_values_to_plot)==0){
        no_indicateur(PAS_INDICATEUR)
      }
      print(length(list_graph_values_to_plot))
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
  
  output$source_entity <- renderText({
    source_plot <- source_entity()
    source_output_list <- lapply(1:length(source_plot), function(cur_source){
      source_name <- paste("source_text", i, sep="")
      cur_source
    })
    do.call(tagList, source_output_list)
  })
  for (i in 1:max_plot){
    local({
      my_i <- i
      source_name <- paste("source_text", i, sep="")
      output[[source_name]] <- renderText({source_entity()[[my_i]]})
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
      output[[plotname]]<- renderPlotly({
        cur_indic <- code_indic()[[my_j]]
        unit <- IND[IND$code_indicateur==cur_indic,]$unite
        get_graph(
        outgraph()[[my_j]],
        c(epci_2()$raison_sociale, input$departement_2, get_region_name_from_dep(departement_2()$CodeZone), "France"), unit
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
  
  
  ### BOUTTON 
  outgraph_small <- reactiveVal()
  outtextgraph_small <- reactiveVal()
  sidetextgraph_small <- reactiveVal()
  no_indicateur_small <- reactiveVal()
  source_entity_small <- reactiveVal()
  code_indic_small <- reactiveVal()
  rightoddimage_small <- reactiveVal(NULL)
  observeEvent({input$wheel_small_button},{
    list_images_to_plot = list()
    list_source_entity = list()
    list_graph_values_to_plot = list()
    list_code_indic = c()
    list_side_text = list()
  lapply(1:17, function(i) {
    
    odd_text <- paste("odd", i, sep="")
    odd <- paste("ODD", i, sep="")
    list_code_indic <<- c(list_code_indic,get_code_indicateur_from_odd(odd))
    cur_list_indic <- get_code_indicateur_from_odd(odd)
    list_image_all <- list()
    for (i in cur_list_indic){
      list_image <- c()
      cur_logos <- logos_from_code_indic(i)
      for (logo in cur_logos){
          cur_img = paste("www/", logo, ".png", sep="")
          list_image <- c(list_image, cur_img)
      }
      list_image_all <- c(list_image_all, list(list_image))
    }
    
      for (i in list_image_all){
        cur_img <- NULL
        for (j in i){
          if (j !=""){
            cur_img <- list(src=j, height=60)
          }
        }
        list_images_to_plot <<- list.append(list_images_to_plot, cur_img)
        print(list_images_to_plot)
        
      }
      
      for (i in cur_list_indic){
        cur_values <- horiz_histo(departement_2()$CodeZone,
                                  epci_2()$siren,
                                  i)
        if (length(cur_values)>1){
          list_graph_values_to_plot <<- list.append(list_graph_values_to_plot, cur_values)
          
          cur_source = paste("Source:",IND[IND$code_indicateur==i,]$source)
          list_source_entity <<- list.append(list_source_entity, cur_source)
          list_side_text <<- list.append(list_side_text, IND[IND$code_indicateur==i,]$libel_court)
        }
      }
      
      outgraph_small(list_graph_values_to_plot)
      outtextgraph_small(ODD_TEXT[ODD_TEXT[["ODD"]]==odd_text,]$ODD_TITLE)
      sidetextgraph_small(list_side_text)
      rightoddimage_small(list_images_to_plot)
      source_entity_small(list_source_entity)
      code_indic_small(list_code_indic)
      
    })
  })
  output$text_graph_small <- renderText({outtextgraph_small()})
  
  # SIDE TEXT
  output$side_text_graph_small <- renderUI({
    side_text <- sidetextgraph_small()
    text_output_list <- lapply(1:length(side_text), function(cur_text){
      text_name <- paste("sidetext_small", i, sep="")
      cur_text
    })
    do.call(tagList, text_output_list)
  })
  for(l in 1:76){
    local({
      my_l <- l
      textname <- paste("sidetext_small", my_l, sep="")
      output[[textname]] <- renderText({sidetextgraph_small()[[my_l]]})
    })
  }
  
  output$source_entity_small <- renderText({
    source_plot <- source_entity_small()
    source_output_list <- lapply(1:length(source_plot), function(cur_source){
      source_name <- paste("source_text_small", i, sep="")
      cur_source
    })
    do.call(tagList, source_output_list)
  })
  for (i in 1:76){
    local({
      my_i <- i
      source_name <- paste("source_text_small", i, sep="")
      output[[source_name]] <- renderText({source_entity_small()[[my_i]]})
    })
  }
  
  output$plot_graph_small <- renderUI({
    plot_values <- outgraph_small()
    plot_output_list <- lapply(1:length(plot_values), function(cur_value){
      plot_name <- paste("plotgraph_small", i, sep="")
      cur_value
    })
    do.call(tagList, plot_output_list)
  })
  for (j in 1:76){
    local({
      my_j <- j
      plotname <- paste("plotgraph_small", my_j, sep="")
      output[[plotname]]<- renderPlotly({
        cur_indic <- code_indic_small()[[my_j]]
        unit <- IND[IND$code_indicateur==cur_indic,]$unite
        get_graph(
          outgraph_small()[[my_j]],
          c(epci_2()$raison_sociale, input$departement_2, get_region_name_from_dep(departement_2()$CodeZone), "France"), unit
        )})
      # output[[plotname]]<- renderPlot({barplot(outgraph()[[my_j]], horiz=TRUE,names.arg=c("Dep", "EPCI"), col="deepskyblue2")})
    })
  } 
  # ODD IMAGE
  output$right_odd_image <- renderUI({
    right_images <- rightoddimage_small()
    img_output_list <- lapply(1:length(right_images), function(cur_image){
      img_name <- paste("rightimage_small", i , sep="")
      cur_image
    })
    do.call(tagList, img_output_list)
  })
  for (i in 1:75){
    local({
      my_i <- i
      imgname <- paste("rightimage_small", my_i, sep="")
      output[[imgname]] <- renderImage({rightoddimage_small()[[my_i]]}, deleteFile = FALSE)
    })
  }
  
  
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
