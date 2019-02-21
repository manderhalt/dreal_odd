# Define UI for app that draws a histogram ----
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
      
      h4(textOutput("catchphrase"))
  )
)
)
