# Define UI for app that draws a histogram ----
library(shiny)
library(divwheel)
if (!require("markdown"))
  install.packages("markdown")
library(markdown)
if (!require("shinydashboard"))
  install.packages("shinydashboard")
library(shinydashboard)
source("data.R")
source("helper.R")

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
                        selectInput("department", "Quel est votre département ?",DF_DEP$Zone),
                        uiOutput("commune"),
                        h4(textOutput("epci_text")),
                        tags$form(
                        lapply(1:length(QUESTION$Libel), function(question_number){
                          current_question <- QUESTION[question_number,]
                          logos <- logos_from_code_indic(current_question$Code_indicateur)
                          if (length(logos)>1){
                            img_file_1 = paste(logos[[1]],".jpg", sep="")
                            img_file_2 = paste(logos[[2]],".jpg", sep="")
                            div(
                              checkboxGroupInput(inputId=paste("question_",current_question$Num_question,sep=''), 
                                                 label=current_question$Libel, choices=CHOICES, inline=TRUE),
                              img(src=img_file_1, width = 50), img(src=img_file_2, width = 50))
                          }
                          else {
                            img_file = paste(logos[[1]],".jpg", sep="")
                          div(
                          checkboxGroupInput(inputId=paste("question_",current_question$Num_question,sep=''), 
                                             label=current_question$Libel, choices=CHOICES, inline=TRUE),
                          img(src=img_file, width = 50))
                          }
                        }), 
                        br(),
                        actionButton("submitBtn", "Submit")
                        )
                        ,
                        divwheelnavOutput("nav_output")
                        
                        
                        
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
                                 id_button <- paste("ODD_button_", i, sep="")
                                 odd_image <- paste("ODD", i,".jpg", sep="")
                                 tags$button(
                                         id = id_button,
                                         class = "btn action-button",
                                         img(src = odd_image,
                                             height = "75px")
                                       )
                                       
                                     
                               }
                               ),
                               column(width = 9, align = "center", h4(textOutput("text_odd")))
                      )
                    )),
           
           
           
           tabPanel("Voir les ODD de mon territoire",
                    selectInput("department_2", "Quel est votre département ?",DF_DEP$Zone),
                    uiOutput("commune_2"),
                    h4(textOutput("epci_text_2")),
                    mainPanel(
                      tags$style(type="text/css",
                                 ".shiny-output-error { visibility: hidden; }",
                                 ".shiny-output-error:before { visibility: hidden; }"),
                      lapply(1:17, function(i){
                        odd <- paste("ODD ", i, sep="")
                        id_button <- paste("ODD_button_graph", i, sep="")
                        odd_image <- paste("ODD", i,".jpg", sep="")
                        tags$button(
                          id = id_button,
                          class = "btn action-button",
                          img(src = odd_image,
                              height = "75px")
                        )
                        
                        
                      }
                      ),
                      column(width = 9, align = "center", h4(textOutput("text_graph"))),
                      plotOutput(outputId ="plot_graph")
                      
                    )
                    )
           
           
           )

