# Define UI for app that draws a histogram ----
library(shiny)
library(divwheel)
if (!require("markdown"))
  install.packages("markdown")
library(markdown)
if (!require("shinydashboard"))
  install.packages("shinydashboard")
library(shinydashboard)
if (!require("shinyWidgets"))
  install.packages("shinyWidgets")
source("data.R")
source("helper.R")

navbarPage("DREAL Quizz", 
           
   # PREMIERE PAGE
   tabPanel(
     "Home",
     setBackgroundImage(src = "background3.jpg"),
     
         
         # TITRES ET PARAGRAPHE D'INTRO
         h3(textOutput("caption")),
         textOutput("intro_text"),
         h4(textOutput("catchphrase")),
         
         # SELECTION DEPARTEMENT COMMUNE
         selectInput("department", "Quel est votre département ?",DF_DEP$Zone),
         uiOutput("commune"),
         h4(textOutput("epci_text")),
         
         # FORM 
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
         
         # WHEEL
         divwheelnavOutput("nav_output") 
       
     
     
   ),
   
   # DEBUT DEUXIEME PAGE
   tabPanel(
     "Les ODD, qu'est ce que c'est",
     navlistPanel(
       "Les ODD en bref",
       
       # PREMIERE CASE
       tabPanel(
         "Définition",
         # TEXTE
         h4(ODD_HEADER),
         "",
         ODD_BASIS),
       
       # DEUXIEME CASE
       tabPanel(
         "Les 17 ODD",
         # LES 17 LOGOS
         lapply(1:17, function(i) {
           odd <- paste("ODD ", i, sep="")
           id_button <- paste("ODD_button_", i, sep="")
           odd_image <- paste("ODD", i,".jpg", sep="")
           tags$button(
             id = id_button,
             class = "btn action-button",
             img(src = odd_image,
                 height = "75px"),
             style="background-color: #FFFFFF"
           )
         }
         ),
         column(width = 9, align = "center", h4(textOutput("text_odd")))
       )
     )
   ),
   
   # TROISIEME PAGE
   tabPanel("Voir les ODD de mon territoire",
            
      # CHOIX DEPARTEMENT
      sidebarPanel(
        selectInput("department_2", "Quel est votre département ?",DF_DEP$Zone),
        uiOutput("commune_2")),
      
      # LOGOS ET GRAPHE
      mainPanel(
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }"),
        # LOGOS
        h4(textOutput("epci_text_2")),
        lapply(1:17, function(i){
          odd <- paste("ODD ", i, sep="")
          id_button <- paste("ODD_button_graph", i, sep="")
          odd_image <- paste("ODD", i,".jpg", sep="")
          tags$button(
            id = id_button,
            class = "btn action-button",
            img(src = odd_image,
                height = "75px"),
            style="background-color: #FFFFFF"
          )
        }
        ),
        # TEXTE
        column(width = 9, align = "center", h4(textOutput("text_graph"))),
        # GRAPHE
        plotOutput(outputId ="plot_graph")
      )
   )        
)

