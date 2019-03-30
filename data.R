COG_2018_COMMUNE_EPCI <- read.csv('./data/COG_2018_COMMUNE_EPCI.csv',header = TRUE,sep=";")
DF_DEP <- read.csv('./data/QUIZZ_ODD_DEP.csv',header = TRUE,sep=";",stringsAsFactors=FALSE)
DF_DEP <- DF_DEP[!is.na(DF_DEP$Zone),]
DF_EPCI <- read.csv('./data/QUIZZ_ODD_EPCI.csv',header = TRUE,sep=";", stringsAsFactors = FALSE)
DF_EPCI <- DF_EPCI[!is.na(DF_EPCI$Zone),]
DF_DEP_EPCI <- read.csv('./data/EPCICOM2019.csv', header=TRUE, sep=",", stringsAsFactors = FALSE)
IND <- read.csv('./data/Tab_passage_ind_ODD.csv',header = TRUE,sep=";", stringsAsFactors = FALSE)
QUESTION <- read.csv('./data/Questions_libel.csv', header=TRUE, sep=',', stringsAsFactors = FALSE)
# save(DF_DEP,DF_EPCI,DF_DEP_EPCI,IND, file = "./odd/data.RData")


# Elements de texte de la landing page
INTRO_TEXT <- "Au coeur de l'Agenda 2030 des Nations Unies, 17 Objectifs de développement durable (ODD) ont été fixés. Ils couvrent l'intégralité des enjeux de développement dans tous les pays tels que le climat, la biodiversité, l'énergie, l'eau, la pauvreté, l'égalité des genres, la prospérité économique ou encore la paix, l'agriculture, et l'éducation.
La région Centre-Val de Loire a défini une cinquantaine d’indicateurs de suivi des ODD pour différents échelons: la région, les départements et les communes via les EPCI (Établissement public de coopération intercommunale). 
Découvrez et comparez les avancées de votre commune et de votre département en matière de développement durable avec l’application [...] !"

TITLE <- "Les objectifs de développement durable dans mon territoire"
CATCHPHRASE <- "Où en est la transition écologique dans mon territoire ? La réponse avec le quizz LES ODDS DANS MON TERRITOIRE Testez votre connaissance du territoire et découvrez les objectifs de développement durable en 8 questions !!!"


# Différentes questions
CHOICES <- c("Inférieur" = 0, "Supérieur" = 1, "Je ne sais pas"="NO")

COLORS <- c("ODD1"="#E81F2D", "ODD2"="#D09F2D", "ODD3"="#2B9B4A", "ODD4"="#C42738", "ODD5"="#ED422B", "ODD6"="#00ACD8", "ODD7"="#FBB617", 
            "ODD8"="#972E47", "ODD9"="#F16E25", "ODD10"="#DE1C83", "ODD11"="#F79C26","ODD12"="#CD8C2E", "ODD13"="#4E7A47", 
            "ODD14"="#007CBB", "ODD15"="#3DAE4A", "ODD16"="#00578B", "ODD17"="#28426E")
# ODD qu'est ce que c'est
ODD_HEADER <- "Les 17 objectifs de développement durable (ODD) et leurs 169 cibles (sous-objectifs) forment la clé de voûte de l’Agenda 2030. Ils tiennent compte équitablement de la dimension économique, de la dimension sociale et de la dimension environnementale du développement durable et intègrent pour la première fois l’éradication de la pauvreté et le développement durable dans un dispositif commun."
ODD_BASIS <- "Les ODD doivent être atteints par tous les États membres de l’ONU d’ici à 2030. Cela signifie que tous les pays sont appelés à relever conjointement les défis urgents de la planète. La Suisse est elle aussi appelée à réaliser ces objectifs sur le plan national. Des mesures incitatives doivent en outre être mises en place pour que les acteurs non étatiques contribuent davantage au développement durable."

