# Define server logic required to draw a histogram ----
source("data.R")
source("helper.R")
library(dplyr)
if (!require("jsonlite"))
  install.packages("jsonlite")

library(jsonlite)
# devtools::install_github('rstudio/DT')
server <- function(input, output) {
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$intro_text <- renderText({
    INTRO_TEXT
  })
  output$caption <-  renderText({
    TITLE
  })
  
  output$image_dreal <- renderImage({
    list(
      src = "logo_fr_dreal.png",
      contentType = 'image/png',
      width = 250,
      height = 250
    )
    
  }, deleteFile = FALSE)
  lapply(1:17, function(i) {
    odd_text = paste("odd_", i , "_text", sep = "")
    output[[odd_text]] <- renderText({
      ODD_TEXT[[odd_text]]
    })
  })
  
  output$catchphrase <- renderText({
    CATCHPHRASE
  })
  
  departement <-
    reactive({
      departement_number <- DF_DEP[DF_DEP$Zone == input$department,]
    })
  output$commune <- renderUI({
    selectInput(
      "commune_string",
      "Quelle est votre commune ?",
      choices = filter(DF_DEP_EPCI, dept == departement()$CodeZone)[["nom_membre"]]
    )
  })
  epci <-
    reactive({
      epci <-
        filter(
          filter(DF_DEP_EPCI, nom_membre == input$commune_string),
          dept == departement()$CodeZone
        )
    })
  output$epci_text <-
    renderText({
      paste("Votre EPCI est: ", epci()$raison_sociale)
    })
  
  
  departement_2 <-
    reactive({
      departement_number <- DF_DEP[DF_DEP$Zone == input$department_2,]
    })
  output$commune_2 <- renderUI({
    selectInput(
      "commune_string_2",
      "Quelle est votre commune ?",
      choices = filter(DF_DEP_EPCI, dept == departement_2()$CodeZone)[["nom_membre"]]
    )
  })
  epci_2 <-
    reactive({
      epci_2 <-
        filter(
          filter(DF_DEP_EPCI, nom_membre == input$commune_string_2),
          dept == departement_2()$CodeZone
        )
    })
  output$epci_text_2 <-
    renderText({
      paste("Votre EPCI est: ", epci_2()$raison_sociale)
    })
  
  lapply(1:nrow(QUESTION), function(i) {
    current_plot <- paste("plot_", i, sep = "")
    current_question <- QUESTION[i, ]
    output[[current_plot]] <-
      renderPlot({
        horiz_histo(departement_2()$CodeZone,
                    epci_2()$siren,
                    current_question$Code_indicateur)
      })
  })
  answers <- reactive({
  # answers <- reactive({answers <- input$question_1})
     lapply(1:nrow(QUESTION), function(question_number){
       current_question <- QUESTION[question_number,]
       question_input_id <- paste("question_",current_question$Num_question,sep='')
       bonne_reponse <- get_result_from_question(current_question$Code_indicateur,epci()$siren, departement()$CodeZone)
       response_user <- input[[question_input_id]]
       answers[[question_input_id]] <-
         get_correct_or_wrong_answer(reponse_user, bonne_reponse)})
     })
  lapply(1:nrow(QUESTION), function(question_number){
    current_question <- QUESTION[question_number,]
    question_output_id <- paste("question_",current_question$Num_question,sep='')
    output[[question_output_id]]<-renderText({
      input$submitBtn
      answers()$question_output_id
    })
  })
  
  #
}
