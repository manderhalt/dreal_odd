navbarPage("Les ODD dans mon territoire", 
           
   # PREMIERE PAGE
   tabPanel(
     "Accueil-Quiz",
     tags$head(tags$style("* { font-family: Open Sans; }")),
     fluidRow(column(1, align="center", imageOutput("image_dreal")),
       column(8, tags$img(src="logo.svg", width="70%"),
         # TITRES ET PARAGRAPHE D'INTRO
         includeHTML("intro.html"),
         
         # SELECTION DEPARTEMENT COMMUNE
         uiOutput("departement"),
         uiOutput("commune"),
         actionButton("validate_choice", "Valider"),
         
         # FORM 
         conditionalPanel(condition = "input.validate_choice", 
                          br(),
                          h4(textOutput("epci_text")),
                          br(),
                          h4("Par rapport à votre département..."),
                          lapply(1:length(QUESTION$Libel), function(i){
                            radio_button <- paste("radio_button_", i, sep="")
                            radio_img <- paste("radio_img_", i, sep="")
                            fluidRow(column(3,align = "center",uiOutput(radio_img), br()),
                            column(5,uiOutput(radio_button)))
                          }),
                          br(),
                          actionButton("submitBtn", "Valider"),
                          actionButton("refresh", "Réessayer le quiz")
         )
         ,
         
         # WHEEL
         h3(textOutput("wheel_title")),
         h4(textOutput("wheel_legend")),
         conditionalPanel(condition = "input.submitBtn",
         div(tags$img(src="green_tile.png", height="20px"),"Votre territoire est mieux positionné que votre département pour contribuer à l’ODD"),
         div(tags$img(src="red_tile.png", height="20px"),"Votre territoire est moins bien positionné que votre département pour contribuer à l’ODD")
         ),
         tags$head(tags$script('
                        var dimension = [0, 0];
                        $(document).on("shiny:connected", function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        $(window).resize(function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        ')),
         divwheelnavOutput("nav_output")
     
     
   ))),
   
   
   
   # Styling nav bar
   tags$head(
     tags$style(HTML("
                     .navbar-default .navbar-brand {background-color: #5392CB; color: black}
                     .navbar-nav { width: 85% }
                     .navbar-nav>li:nth-child(4) { float: right;}
                     .navbar-default {background-color: #FFFFFF ;}
                       
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
          column(6, h4(tags$b(textOutput("sidetext1"))), plotlyOutput(outputId ="plotgraph1", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, h4(tags$b("Autres ODD concernés")), br(), br(), br(), imageOutput("rightimage1"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext2",
        fluidRow(
          column(6, h4(tags$b(textOutput("sidetext2"))), plotlyOutput(outputId ="plotgraph2", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage2"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext3",
        fluidRow(
          column(6, h4(tags$b(textOutput("sidetext3"))), plotlyOutput(outputId ="plotgraph3", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage3"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext4",
        fluidRow(
          column(6, h4(tags$b(textOutput("sidetext4"))), plotlyOutput(outputId ="plotgraph4", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage4"))
        )
      ), 
      conditionalPanel(
        condition = "output.sidetext5",
        fluidRow(
          column(6, h4(tags$b(textOutput("sidetext5"))), plotlyOutput(outputId ="plotgraph5", height = "250px"), h5("Source ODD", a("Link", href=source_odd))),
          column(2, br(), br(), br(), imageOutput("rightimage5"))
        )
      )
   ),
   
   # DEBUT TROISIEME PAGE
   tabPanel(
     div(tags$img(src="wheel_to_text.png", height="20px"),"Les ODD, qu'est-ce que c'est ?"),
     
     column(8, tags$img(src="logo.svg", width="70%")),
     column(12, style = "font-size: 150%", br(), TEXT_ODD_PRES_1, 
            br(), br(), TEXT_ODD_PRES_2, br(), br(),
            tags$b("Rendez-vous sur le site des ODD pour la France :"),
            a("https://www.agenda-2030.fr", href="https://www.agenda-2030.fr"), br(), br(),
            tags$ul(
              tags$li(a("Présentation : origines et principes", href="https://www.agenda-2030.fr/agenda2030/presentation-principes-specificites-origines-18")),
              tags$li(a("Les indicateurs de suivi des Objectifs de développement durable", href="https://www.agenda-2030.fr/agenda2030/dispositif-de-suivi-les-indicateurs-19")),
              tags$li(a("Situation et organisation de la mise en œuvre en France", href="https://www.agenda-2030.fr/agenda2030/situation-de-la-france-21")),
              tags$li(a("Mobilisation des acteurs", href="https://www.agenda-2030.fr/agenda2030/mobilisation-des-acteurs-non-etatiques-en-france-40")),
              tags$li(a("En Europe et à l'international", href="https://www.agenda-2030.fr/agenda2030/en-europe-et-linternational-22"))
            ),
            br(), br(),
            "Les ODD sur le site de l'ONU :", tags$a(href="https://www.un.org/sustainabledevelopment/fr/objectifs-de-developpement-durable/", 
                                                    "https://www.un.org/sustainabledevelopment/fr/objectifs-de-developpement-durable/"),
            br(), br()
      ),
     
     
     # LES 17 LOGOS
     lapply(1:17, function(i) {
       odd <- paste("ODD ", i, sep="")
       id_button <- paste("ODD_button_", i, sep="")
       odd_image <- paste("ODD", i,".png", sep="")
       tags$button(
         id = id_button,
         class = "btn action-button",
         img(src = odd_image,
             height = "125px"),
         style="background-color: transparent")
       
     }
     ),
     fluidRow(
       column(width = 4, align = "center", br(), imageOutput("third_image")),
       column(width = 7, style = "font-size: 150%", 
              h4(textOutput("text_odd"), 
                 style="font-size: 200%; color:cornflowerblue"), 
              textOutput("subtext_odd"), br(), 
              textOutput("third_text_with_link"), 
              uiOutput("third_link"),br())
       
       
     
   )
     
     
   )
)

