navbarPage("Les ODD dans mon territoire", 
           
   # PREMIERE PAGE
   tabPanel(
     "Accueil-Quiz",
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
   tabPanel("Les indicateurs ODD de mon territoire",
            
      column(8, tags$img(src="logo.svg", width="70%")),
      # CHOIX DEPARTEMENT
      column(
        12, align="left", br(), h3("Portrait de territoire - Tout les indicateurs ODD de mon territoire"),
        h4("Sélectionnez votre territoire et cliquez sur chaque bloc ODD pour visualiser le positionnement de votre territoire 
        par rapport aux échelles territoriales supérieures (département, région, France métropolitaine).", br(), "Un indicateur peut être relié à plusieurs ODD.", br())
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
     
     column(8, tags$img(src="logo.svg", width="70%")),
     column(12, style = "font-size: 150%", br(), TEXT_ODD_PRES_1, 
            br(), br(), TEXT_ODD_PRES_2, br(), br(),
            tags$b("Rendez-vous sur le site des ODD pour la France:"),
            a("https://www.agenda-2030.fr", href="https://www.agenda-2030.fr"), br(), br(),
            tags$ul(
              tags$li(a("Présentation: origines et principes", href="https://www.agenda-2030.fr/agenda2030/presentation-principes-specificites-origines-18")),
              tags$li(a("Les indicateurs de suivi des Objectifs de développement durable", href="https://www.agenda-2030.fr/agenda2030/dispositif-de-suivi-les-indicateurs-19")),
              tags$li(a("Situation et organisation de la mise en œuvre en France", href="https://www.agenda-2030.fr/agenda2030/situation-de-la-france-21")),
              tags$li(a("Mobilisation des acteurs", href="https://www.agenda-2030.fr/agenda2030/mobilisation-des-acteurs-non-etatiques-en-france-40")),
              tags$li(a("En Europe et à l'international", href="https://www.agenda-2030.fr/agenda2030/en-europe-et-linternational-22"))
            ),
            br(), br(),
            "Les ODD sur le site de l'ONU:", tags$a(href="https://www.un.org/sustainabledevelopment/fr/objectifs-de-developpement-durable/", 
                                                    "https://www.un.org/sustainabledevelopment/fr/objectifs-de-developpement-durable/"),
            br(), br()
      ),
     
     
     # LES 17 LOGOS
     lapply(1:17, function(i) {
       odd_image <- paste("ODD", i,".png", sep="")
       odd_text <- paste("text_odd_", i, sep="")
       odd_subtext <- paste("subtext_odd_", i, sep="")
       odd_link <- paste("link_odd_", i, sep="")
       text_link <- paste("En savoir plus sur l'ODD", i, "sur le site")
       fluidRow(
       column(width = 4, align="center", tags$img(src=odd_image, width='60%'), br(), br()),
       column(width = 7, style = "font-size: 150%", h4(textOutput(odd_text), style="font-size: 200%; color:cornflowerblue"), textOutput(odd_subtext), br(), text_link, uiOutput(odd_link),br())
       )
       
     }
     )
     
   )
)

