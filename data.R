
COG_2018_COMMUNE_EPCI <- read.csv('./data/COG_2018_COMMUNE_EPCI.csv',header = TRUE,sep=";")
QUIZZ_ODD_DEP <- read.csv('./data/QUIZZ_ODD_DEP.csv',header = TRUE,sep=";",stringsAsFactors=FALSE)
QUIZZ_ODD_EPCI <- read.csv('./data/QUIZZ_ODD_EPCI.csv',header = TRUE,sep=";", stringsAsFactors = FALSE)
QUIZZ_GOOD_EPCI <- read.csv('./data/EPCICOM2019.csv', header=TRUE, sep=",", stringsAsFactors = FALSE)
IND <- read.csv('./data/Tab_passage_ind_ODD.csv',header = TRUE,sep=";")

save(COG_2018_COMMUNE_EPCI,QUIZZ_ODD_DEP,QUIZZ_ODD_EPCI,IND, file = "./odd/data.RData")


# Elements de texte de la landing page
INTRO_TEXT <- "Au coeur de l'Agenda 2030 des Nations Unies, 17 Objectifs de développement durable (ODD) ont été fixés. Ils couvrent l'intégralité des enjeux de développement dans tous les pays tels que le climat, la biodiversité, l'énergie, l'eau, la pauvreté, l'égalité des genres, la prospérité économique ou encore la paix, l'agriculture, et l'éducation.
La région Centre-Val de Loire a défini une cinquantaine d’indicateurs de suivi des ODD pour différents échelons: la région, les départements et les communes via les EPCI (Établissement public de coopération intercommunale). 
Découvrez et comparez les avancées de votre commune et de votre département en matière de développement durable avec l’application [...] !"

TITLE <- "Les objectifs de développement durable dans mon territoire"
CATCHPHRASE <- "Où en est la transition écologique dans mon territoire ?

La réponse avec le quizz LES ODDS DANS MON TERRITOIRE


Testez votre connaissance du territoire et découvrez les objectifs de développement durable en 8 questions !!!"


# Différentes questions
CHOICES <- c("Inférieur" = "inf", "Supérieur" = "sup")

QUESTION_1 <- "Le taux de pauvreté dans votre EPCI est:"
QUESTION_2 <- "La surface en agriculture biologique est:"
QUESTION_3 <- "La densité de médecins dans votre EPCI est:"
QUESTION_4 <- "La part des diplômés du supérieur parmi les 15-24 ans dans votre EPCI est:"
QUESTION_5 <- "La part des femmes parmi les chômeurs dans votre EPCI est:"
QUESTION_6 <- "La production d’énergie renouvelable dans votre EPCI est:

(Puissance reliée en énergie renouvelable pour 1000 habitants)
"
QUESTION_7 <- "Le taux d’emploi d’emploi dans votre EPCI est:"
QUESTION_8 <- "La part de déplacements en transports en commun dans les trajets domicile - travail dans votre EPCI est:"
LIST_QUESTIONS <- list("question_1"=QUESTION_1, "question_2"=QUESTION_2,
                    "question_3"=QUESTION_3, "question_4"=QUESTION_4,
                    "question_5"=QUESTION_5, "question_6"=QUESTION_6,
                    "question_7"=QUESTION_7, "question_8"=QUESTION_8)

# ODD qu'est ce que c'est
ODD_HEADER <- "Les 17 objectifs de développement durable (ODD) et leurs 169 cibles (sous-objectifs) forment la clé de voûte de l’Agenda 2030. Ils tiennent compte équitablement de la dimension économique, de la dimension sociale et de la dimension environnementale du développement durable et intègrent pour la première fois l’éradication de la pauvreté et le développement durable dans un dispositif commun."
ODD_BASIS <- "Les ODD doivent être atteints par tous les États membres de l’ONU d’ici à 2030. Cela signifie que tous les pays sont appelés à relever conjointement les défis urgents de la planète. La Suisse est elle aussi appelée à réaliser ces objectifs sur le plan national. Des mesures incitatives doivent en outre être mises en place pour que les acteurs non étatiques contribuent davantage au développement durable."
ODD_1_TEXT <- "Le premier objectif vise la fin de la pauvreté et la lutte contre les inégalités sous toutes ses formes et partout dans le monde. Il se compose de sept sous-objectifs ciblant : la lutte contre la pauvreté, l’accès aux services de base, la réduction de la proportion de travailleurs pauvres et des personnes les plus vulnérables, notamment les femmes et les enfants."



