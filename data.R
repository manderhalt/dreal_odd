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
ODD_1_TEXT <- "Objectif 1: Éliminer la pauvreté sous toutes ses formes et partout dans le monde"
ODD_2_TEXT <- "Objectif 2: Éliminer la faim, assurer la sécurité alimentaire, améliorer la nutrition et promouvoir l’agriculture durable"
ODD_3_TEXT <- "Objectif 3: Permettre à tous de vivre en bonne santé et promouvoir le bien-être de tous à tout âge"
ODD_4_TEXT <- "Objectif 4: Assurer l’accès de tous à une éducation de qualité, sur un pied d’égalité, et promouvoir les possibilités d’apprentissage tout au long de la vie"
ODD_5_TEXT <- "Objectif 5: Parvenir à l’égalité des sexes et autonomiser toutes les femmes et les filles"
ODD_6_TEXT <- "Objectif 6: Garantir l’accès de tous à l’eau et à l’assainissement et assurer une gestion durable des ressources en eau"
ODD_7_TEXT <- "Objectif 7: Garantir l’accès de tous à des services énergétiques fiables, durables et modernes, à un coût abordable"
ODD_8_TEXT <- "Objectif 8: Promouvoir une croissance économique soutenue, partagée et durable, le plein emploi productif et un travail décent pour tous"
ODD_9_TEXT <- "Objectif 9: Bâtir une infrastructure résiliente, promouvoir une industrialisation durable qui profite à tous et encourager l’innovation"
ODD_10_TEXT <- "Objectif 10: Réduire les inégalités dans les pays et d’un pays à l’autre"
ODD_11_TEXT <- "Objectif 11: Faire en sorte que les villes et les établissements humains soient ouverts à tous, sûrs, résilients et durables"
ODD_12_TEXT <- "Objectif 12: Établir des modes de consommation et de production durables"
ODD_13_TEXT <- "Objectif 13: Prendre d’urgence des mesures pour lutter contre les changements climatiques et leurs répercussions"
ODD_14_TEXT <- "Objectif 14: Conserver et exploiter de manière durable les océans, les mers et les ressources marines aux fins du développement durable"
ODD_15_TEXT <- "Objectif 15: Préserver et restaurer les écosystèmes terrestres"
ODD_16_TEXT <- "Objectif 16: Promouvoir l’avènement de sociétés pacifiques et ouvertes aux fins du développement durable"
ODD_17_TEXT <- "Objectif 17: Renforcer les moyens de mettre en oeuvre le Partenariat mondial pour le développement durable et le revitaliser"
ODD_TEXT <- list("odd_1_text"=ODD_1_TEXT, "odd_2_text"=ODD_2_TEXT, "odd_3_text"=ODD_3_TEXT, "odd_4_text"=ODD_4_TEXT, "odd_5_text"=ODD_5_TEXT,
                                  "odd_6_text"=ODD_6_TEXT, "odd_7_text"=ODD_7_TEXT, "odd_8_text"=ODD_8_TEXT, "odd_9_text"=ODD_9_TEXT, "odd_10_text"=ODD_10_TEXT,
                                  "odd_11_text"=ODD_11_TEXT, "odd_12_text"=ODD_12_TEXT, "odd_13_text"=ODD_13_TEXT, "odd_14_text"=ODD_14_TEXT, "odd_15_text"=ODD_15_TEXT,
                                   "odd_16_text"=ODD_16_TEXT, "odd_17_text"=ODD_17_TEXT)

