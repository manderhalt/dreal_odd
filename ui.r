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
      column(
        12, align="center", h1("Portrait de territoire"),
        h2("Tout savoir sur les ODD dans mon territoire")),
      selectInput("department_2", "Quel est votre département ?",DF_DEP$Zone),
      uiOutput("commune_2"),
    
      # LOGOS ET GRAPHE
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
      column(12, align="center", h3(textOutput("text_graph"), br(), style="display: block; margin-left: auto; margin-right: auto;")),
      
      # GRAPHE
      fluidRow(column(4, "Indicateur"),
      column(4, "Taux dans votre commune et votre département"),
      column(4, "ODD correspondant")),
      fluidRow(column(4, br(),br(),br(), br(), br(), span(em(textOutput("side_text_graph")), style="font-size: 15px; display: block; margin-left: auto; margin-right: auto;")),
      column(4, plotOutput(outputId ="plot_graph")),
      column(4, imageOutput("rightimage1"),imageOutput("rightimage2"),imageOutput("rightimage3"),imageOutput("rightimage4"),imageOutput("rightimage5"))
    )
   )        
)

