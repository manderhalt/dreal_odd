# Define server logic required to draw a histogram ----
source("data.R")
source("helper.R")
if (!require("dplyr"))
  install.packages("dplyr")
library(dplyr)

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
  response_all <- integer(nrow(QUESTION))
  event_submit_button_wheel <- eventReactive(input$submitBtn, {
    
    lapply(1:nrow(QUESTION), function(question_number){
      current_question <- QUESTION[question_number,]
      question_input_id <- paste("question_",current_question$Num_question,sep='')
      bonne_reponse <- get_result_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
      response_user <- input[[question_input_id]]
      type_answer <- get_correct_or_wrong_answer(response_user, bonne_reponse)
      
      response_all[[question_number]] <<- type_answer
    })
    all_logos <- get_all_logos_odd()
    
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
  
  lapply(1:17, function(i) {
    button <- paste("ODD_button_graph", i, sep="")
    odd_text <- paste("odd_", i, "_text", sep="")
    odd <- paste("ODD", i, sep="")
    list_code_indic <- get_code_indicateur_from_odd(odd)
    code_indic <- NULL
    if (length(list_code_indic)>1){
      code_indic <-  list_code_indic[[1]]
    }
    observeEvent(input[[button]], {
      outgraph(horiz_histo(departement_2()$CodeZone,
                           epci_2()$siren,
                           code_indic))
      outtextgraph(ODD_TEXT[[odd_text]])
    })
  })
  output$plot_graph <- renderPlot({outgraph()})
  output$text_graph <- renderText({outtextgraph()})
}
