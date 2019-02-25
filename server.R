# Define server logic required to draw a histogram ----
source("data.R")

# devtools::install_github('rstudio/DT')
# install.packages("shinyjs")
# install.packages("dplyr")
# install.packages("digest")
library(imager)
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
  output$caption <-  renderText({TITLE})
  
  output$image_dreal <- renderImage({
    list(src = "logo_fr_dreal.png",
         contentType = 'image/png',
         width=250,
         height=250)
    
    }, deleteFile=FALSE
    )
  output$odd_1_text <- renderText({ODD_1_TEXT})
  for (i in 1:17){
    
  }
  output$ODD_1 <- renderImage({
    list(src = "./Logos/ODD_1.jpg",
         contentType = 'image/jpg',
         width=150,
         height=150)
    
  }, deleteFile=FALSE
  )
  output$ODD_2 <- renderImage({
    list(src = "./Logos/ODD_2.jpg",
         contentType = 'image/jpg',
         width=150,
         height=150)
    
  }, deleteFile=FALSE
  )
  output$catchphrase <- renderText({CATCHPHRASE})
  
  departement <- reactive({departement_number <-QUIZZ_ODD_DEP[QUIZZ_ODD_DEP$Zone==input$department, ][["CodeZone"]][[1]]
  })
  output$commune <- renderUI({
    selectInput("commune_string", "Quelle est votre commune ?", choices = QUIZZ_GOOD_EPCI[QUIZZ_GOOD_EPCI$dept==departement(),][["nom_membre"]])
  })
  epci_text <- reactive({epci_text <- QUIZZ_GOOD_EPCI[QUIZZ_GOOD_EPCI$nom_membre==input$commune_string,][["raison_sociale"]]})
  output$epci_text <- renderText({paste("Votre EPCI est: ",epci_text())})
  
  
  departement_2 <- reactive({departement_number <-QUIZZ_ODD_DEP[QUIZZ_ODD_DEP$Zone==input$department_2, ][["CodeZone"]][[1]]
  })
  output$commune_2 <- renderUI({
    selectInput("commune_string_2", "Quelle est votre commune ?", choices = QUIZZ_GOOD_EPCI[QUIZZ_GOOD_EPCI$dept==departement_2(),][["nom_membre"]])
  })
  epci_text_2 <- reactive({epci_text_2 <- QUIZZ_GOOD_EPCI[QUIZZ_GOOD_EPCI$nom_membre==input$commune_string_2,][["raison_sociale"]]})
  output$epci_text_2 <- renderText({paste("Votre EPCI est: ",epci_text_2())})
}

