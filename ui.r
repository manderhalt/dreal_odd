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

print(list.files())
print(list.files('./data'))

source("data.R")
source("helper.R")



navbarPage("DREAL Quizz", 
           
   # PREMIERE PAGE
   tabPanel(
     "Accueil",
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
   
   # DEUXIEME PAGE
   tabPanel("Les indicateurs ODD par territoire",
            
      # CHOIX DEPARTEMENT
      column(
        12, align="center", h1("Portrait de territoire"),
        em(h2("Tout savoir sur les ODD dans mon territoire"))),
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
      column(4, "Taux dans votre territoire et votre département"),
      column(4, "ODD correspondant")),
      conditionalPanel(
        condition = "output.sidetext1.length > 0",
        fluidRow(
          column(4, em(textOutput("sidetext1"))), 
          column(4, plotOutput(outputId ="plotgraph1", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(4, imageOutput("rightimage1"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext2.length > 0",
        fluidRow(
          column(4, em(textOutput("sidetext2"))), 
          column(4, plotOutput(outputId ="plotgraph2", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(4, imageOutput("rightimage2"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext3.length > 0",
        fluidRow(
          column(4, em(textOutput("sidetext3"))), 
          column(4, plotOutput(outputId ="plotgraph3", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(4, imageOutput("rightimage3"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext4.length > 0",
        fluidRow(
          column(4, em(textOutput("sidetext4"))), 
          column(4, plotOutput(outputId ="plotgraph4", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(4, imageOutput("rightimage4"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext5.length > 0",
        fluidRow(
          column(4, em(textOutput("sidetext5"))), 
          column(4, plotOutput(outputId ="plotgraph5", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(4, imageOutput("rightimage5"))
        )
      )
   ),
   
   # DEBUT TROISIEME PAGE
   tabPanel(
     "Les ODD, qu'est ce que c'est ?",
     
     
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

