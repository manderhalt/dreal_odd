navbarPage("DREAL Quiz", 
           
   # PREMIERE PAGE
   tabPanel(
     "Accueil",
     setBackgroundImage(src = "background3.jpg"),
     tags$head(tags$style("* { font-family: NEUZEIT S LT STD – BOOK; }")),
     fluidRow(column(2, imageOutput("image_dreal")),
       column(8, tags$img(src="logo.svg", width="70%"),
         # TITRES ET PARAGRAPHE D'INTRO
         includeHTML("intro.html"),
         
         # SELECTION DEPARTEMENT COMMUNE
         uiOutput("departement"),
         uiOutput("commune"),
         actionButton("validate_choice", "Valider"),
         
         # FORM 
         conditionalPanel(condition = "input.validate_choice", 
                          h4(textOutput("epci_text")),
                          uiOutput("plots_and_radios"),
                          br(),
                          actionButton("submitBtn", "Valider"),
                          actionButton("refresh", "Réessayer le quiz")
         )
         ,
         
         # WHEEL
         h3(textOutput("wheel_title")),
         br(),
         textOutput("wheel_legend"),
         divwheelnavOutput("nav_output", width = 900)
     
     
   ))),
   
   
   
   # Styling nav bar
   tags$head(
     tags$style(HTML("
                     .navbar-nav { width: 85% }
                     .navbar-nav>li:nth-child(4) { float: right; }
                     .navbar-default {
    background-color: #FFFFFF ;
}
                     
                     "))
     ), 
   # DEUXIEME PAGE
   tabPanel("Les indicateurs ODD par territoire",
            
      column(8, tags$img(src="logo.svg", width="70%")),
      # CHOIX DEPARTEMENT
      column(
        12, align="left", br(), h3("Portrait de territoire - Tout savoir sur les ODD dans mon territoire"), br()
      ),
        
      uiOutput("departement_2"),
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
        odd_image <- paste("ODD", i,".png", sep="")
        tags$button(
          id = id_button,
          class = "btn action-button",
          img(src = odd_image,
              height = "125px"),
          tags$style(type = 'text/css', 
                     HTML('.action-button { background-color: transparent;
.active {
                                color: #555;
                          background-color: green;
      };
}'))
        )
      }
      ),
      # TEXTE
      column(12, align="center", h3(textOutput("text_graph"), br(), style="display: block; margin-left: auto; margin-right: auto;")),
      
      # GRAPHE
      conditionalPanel(
        condition = "!output.sidetext1",
        h3(textOutput("no_indicateur"), align="center")
        ),
      conditionalPanel(
        
        condition = "output.sidetext1",
        fluidRow(
          column(6, textOutput("sidetext1"), plotlyOutput(outputId ="plotgraph1", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage1"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext2",
        fluidRow(
          column(6, textOutput("sidetext2"), plotlyOutput(outputId ="plotgraph2", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage2"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext3",
        fluidRow(
          column(6, textOutput("sidetext3"), plotlyOutput(outputId ="plotgraph3", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage3"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext4",
        fluidRow(
          column(6, textOutput("sidetext4"), plotlyOutput(outputId ="plotgraph4", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage4"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext5",
        fluidRow(
          column(6, textOutput("sidetext5"), plotlyOutput(outputId ="plotgraph5", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage5"))
        )
      )
   ),
   
   # DEBUT TROISIEME PAGE
   tabPanel(
     div(tags$img(src="wheel_to_text.png", height="20px"),"Les ODD, qu'est ce que c'est ?"),
     
     
     
     # LES 17 LOGOS
     lapply(1:17, function(i) {
       odd_image <- paste("ODD", i,".png", sep="")
       odd_text <- paste("text_odd_", i, sep="")
       odd_subtext <- paste("subtext_odd_", i, sep="")
       fluidRow(
       column(width = 4, align="center", tags$img(src=odd_image, width='60%'), br(), br()),
       column(width = 8, align = "center", h4(textOutput(odd_text)), textOutput(odd_subtext), br(), br())
       )
       
     }
     )
     
   )
)

