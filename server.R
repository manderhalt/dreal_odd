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
  output$catchphrase <- renderText({CATCHPHRASE})
  
}