COG_2018_COMMUNE_EPCI <- read.csv('./data/COG_2018_COMMUNE_EPCI.csv',header = TRUE,sep=";")
DEP_TO_REGION <- read.csv('./data/depts2018.csv', header=TRUE, sep="\t")
DF_DEP_EPCI <- read.csv('./data/EPCICOM2019.csv', header=TRUE, sep=",", stringsAsFactors = FALSE)
IND <- read.csv('./data/Tab_passage_Ind_ODD.csv',header = TRUE,sep=";", stringsAsFactors = FALSE)
QUESTION <- read.csv('./data/Questions_libel.csv', header=TRUE, sep=',', stringsAsFactors = FALSE)
ODD_TEXT <- read.csv('./data/texte_odd.csv', header=TRUE, sep=';', stringsAsFactors = FALSE)
# save(DF_DEP,DF_EPCI,DF_DEP_EPCI,IND, file = "./odd/data.RData")

interstice <- c(br(), br(), br(), br(), br(), br(), br())

# Elements de texte de la landing page


# Différentes questions
CHOICES <- c("Inférieur" = 0, "Supérieur" = 1, "Je ne sais pas"=3)
CHOICENAMES <- list(
  HTML("<font color='red'>Inférieur</font>"), 
  tags$span(style = "color:green", "Supérieur"), 
  "Je ne sais pas"
)
CHOICEVALUES <- c(0,1,3)

WHEEL_TITLE <- "Le positionnement de mon territoire par ODD"
WHEEL_LEGEND <- "Cliquez sur les ODD correspondant aux questions du quizz pour obtenir le niveau de votre territoire par rapport au département."
COLORS <- c("ODD1"="#E81F2D", "ODD2"="#D09F2D", "ODD3"="#2B9B4A", "ODD4"="#C42738", "ODD5"="#ED422B", "ODD6"="#00ACD8", "ODD7"="#FBB617", 
            "ODD8"="#972E47", "ODD9"="#F16E25", "ODD10"="#DE1C83", "ODD11"="#F79C26","ODD12"="#CD8C2E", "ODD13"="#4E7A47", 
            "ODD14"="#007CBB", "ODD15"="#3DAE4A", "ODD16"="#00578B", "ODD17"="#28426E")
# ODD qu'est ce que c'est
ODD_HEADER <- "Les 17 objectifs de développement durable (ODD) et leurs 169 cibles (sous-objectifs) forment la clé de voûte de l’Agenda 2030. Ils tiennent compte équitablement de la dimension économique, de la dimension sociale et de la dimension environnementale du développement durable et intègrent pour la première fois l’éradication de la pauvreté et le développement durable dans un dispositif commun."
ODD_BASIS <- "Les ODD doivent être atteints par tous les États membres de l’ONU d’ici à 2030. Cela signifie que tous les pays sont appelés à relever conjointement les défis urgents de la planète. La Suisse est elle aussi appelée à réaliser ces objectifs sur le plan national. Des mesures incitatives doivent en outre être mises en place pour que les acteurs non étatiques contribuent davantage au développement durable."



indicateur_odd_subtitle <- "Tout savoir sur les ODD dans mon territoire"
source_odd <- "https://www.agenda-2030.fr/odd/odd1-eliminer-la-pauvrete-sous-toutes-ses-formes-et-partout-dans-le-monde-23"

PAS_INDICATEUR <- "Il n'y a pas d'indicateur correspondant à cet objectif de développement durable"
