COG_2018_COMMUNE_EPCI <- read.csv('./data/COG_2018_COMMUNE_EPCI.csv',header = TRUE,sep=";")
QUIZZ_ODD_DEP <- read.csv('./data/QUIZZ_ODD_DEP.csv',header = TRUE,sep=";")
QUIZZ_ODD_EPCI <- read.csv('./data/QUIZZ_ODD_EPCI.csv',header = TRUE,sep=";")
IND <- read.csv('./data/Tab_passage_ind_ODD.csv',header = TRUE,sep=";")

save(COG_2018_COMMUNE_EPCI,QUIZZ_ODD_DEP,QUIZZ_ODD_EPCI,IND, file = "./odd/data.RData")

INTRO_TEXT <- "Au coeur de l'Agenda 2030 des Nations Unies, 17 Objectifs de développement durable (ODD) ont été fixés. Ils couvrent l'intégralité des enjeux de développement dans tous les pays tels que le climat, la biodiversité, l'énergie, l'eau, la pauvreté, l'égalité des genres, la prospérité économique ou encore la paix, l'agriculture, et l'éducation.
La région Centre-Val de Loire a défini une cinquantaine d’indicateurs de suivi des ODD pour différents échelons: la région, les départements et les communes via les EPCI (Établissement public de coopération intercommunale). 
Découvrez et comparez les avancées de votre commune et de votre département en matière de développement durable avec l’application [...] !"

TITLE <- "Les objectifs de développement durable dans mon territoire"

CATCHPHRASE <- "Où en est la transition écologique dans mon territoire ?

La réponse avec le quizz LES ODDS DANS MON TERRITOIRE


Testez votre connaissance du territoire et découvrez les objectifs de développement durable en 8 questions !!!"