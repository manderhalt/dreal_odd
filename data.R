DEP_TO_REGION <- read.csv('./data/depts2018.csv', header=TRUE, sep="\t", encoding = "utf-8")
DF_DEP_EPCI <- read.csv('./data/EPCICOM2019.csv', header=TRUE, sep=",", stringsAsFactors = FALSE)
IND <- read.csv('./data/Tab_passage_Ind_ODD.csv',header = TRUE,sep=";", stringsAsFactors = FALSE)
QUESTION <- read.csv('./data/Questions_libel.csv', header=TRUE, sep=',', stringsAsFactors = FALSE)
ODD_TEXT <- read.csv('./data/texte_odd.csv', header=TRUE, sep=';', stringsAsFactors = FALSE)
# save(DF_DEP,DF_EPCI,DF_DEP_EPCI,IND, file = "./odd/data.RData")

# TEXT TROISIEME PAGE
TEXT_ODD_PRES_1 <- "En septembre 2015, les 193 États membres de l’ONU ont adopté le programme de développement durable à l’horizon 2030, intitulé Agenda 2030. 
C'est un agenda pour les populations, pour  la planète, pour la prospérité, pour la paix pour les partenariats. 
Il porte une vision de transformation de notre monde en éradiquant la pauvreté et en assurant sa transition vers un développement durable."

TEXT_ODD_PRES_2 <- "L'Agenda 2030 a fusionné l'agenda du développement et celui des Sommets de la Terre. 
Il est universel, c’est-à-dire qu'il s’applique à tous les pays, du Nord comme du Sud. 
À cet égard, tous les pays sont « en voie de développement durable ». Avec ses 17 Objectifs de développement durable et 169 cibles (ou sous-objectifs), 
il dessine une feuille de route détaillée et couvre pratiquement toutes les questions de société.
"

# Différentes questions
CHOICES <- c("Inférieur" = 0, "Supérieur" = 1, "Je ne sais pas"=3)
CHOICEVALUES <- c(0,1,3)

WHEEL_TITLE <- "Le positionnement de mon territoire sur ces 8 indicateurs ODD"
WHEEL_LEGEND <- "Cliquez sur les ODD correspondant aux questions du quiz pour visualiser le positionnement de votre territoire par rapport au département"
COLORS <- c("ODD1"="#E81F2D", "ODD2"="#D09F2D", "ODD3"="#2B9B4A", "ODD4"="#C42738", "ODD5"="#ED422B", "ODD6"="#00ACD8", "ODD7"="#FBB617", 
            "ODD8"="#972E47", "ODD9"="#F16E25", "ODD10"="#DE1C83", "ODD11"="#F79C26","ODD12"="#CD8C2E", "ODD13"="#4E7A47", 
            "ODD14"="#007CBB", "ODD15"="#3DAE4A", "ODD16"="#00578B", "ODD17"="#28426E")

indicateur_odd_subtitle <- "Tout savoir sur les ODD dans mon territoire"
source_odd <- "https://www.agenda-2030.fr/odd/odd1-eliminer-la-pauvrete-sous-toutes-ses-formes-et-partout-dans-le-monde-23"

PAS_INDICATEUR <- "Il n'y a pas d'indicateur correspondant à cet objectif de développement durable"
