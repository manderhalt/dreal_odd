# Define UI for app that draws a histogram ----
library(shiny)
source("data.R")
ui <- fluidPage(
  
  # App title ----
  titlePanel("Dreal Quizz"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      imageOutput("image_dreal")
    )
  ,
    
    # Main panel for displaying outputs ----
    mainPanel(
      h3(textOutput("caption")),
      # Output: Histogram ----
      textOutput("intro_text"),
      
      h4(textOutput("catchphrase")),
      lapply(1:length(LIST_QUESTIONS), function(question_number){
        checkboxGroupInput(inputId=names(LIST_QUESTIONS)[[question_number]], 
                           label=LIST_QUESTIONS[[question_number]], choices=CHOICES, inline=TRUE)
      })
      ,
      actionButton(inputId = "submitBtn", label = "Submit")
      
  )
)
)