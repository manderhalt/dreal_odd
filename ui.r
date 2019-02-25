# Define UI for app that draws a histogram ----
library(shiny)
library(markdown)
library(shinydashboard)
source("data.R")

navbarPage("DREAL Quizz",
           tabPanel("Home",
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
                        selectInput("department", "Quel est votre département ?",QUIZZ_ODD_DEP$Zone),
                        uiOutput("commune"),
                        h4(textOutput("epci_text")),
                        lapply(1:length(LIST_QUESTIONS), function(question_number){
                          checkboxGroupInput(inputId=names(LIST_QUESTIONS)[[question_number]], 
                                             label=LIST_QUESTIONS[[question_number]], choices=CHOICES, inline=TRUE)
                        })
                        ,
                        actionButton(inputId = "submitBtn", label = "Submit")
                        
                      )
                    )
                    
                    ),
           tabPanel("Les ODD, qu'est ce que c'est",
                    navlistPanel(
                      "Les ODD en bref",
                      tabPanel("Définition",
                               h4(ODD_HEADER),
                              "",
                              ODD_BASIS),
                      tabPanel("Les 17 ODD",
                               lapply(1:17, function(i) {
                                 odd <- paste("ODD ", i, sep="")
                                 odd_image <- paste("odd_", i, sep="")
                                 box(title = odd,
                                     status = "primary",
                                     solidHeader = F,
                                     collapsible = F,
                                     width = 12,
                                     fluidRow(
                                       column(width = 2, align = "left",
                                              img(src=paste(odd_image,".jpg", sep=""), width=100)),
                                       column(width = 9, align = "center", textOutput( paste("odd_",i,"_text",sep="")))
                                     ))
                               }
                               )
                      )
                    )),
           tabPanel("Voir les ODD de mon territoire",
                    selectInput("department_2", "Quel est votre département ?",QUIZZ_ODD_DEP$Zone),
                    uiOutput("commune_2"),
                    h4(textOutput("epci_text_2"))
                    )
           )

