# install.packages("RPostgreSQL")
if (!require("RPostgres"))
  install.packages("RPostgres")
library(RPostgres)
if (!require("dotenv"))
  install.packages("dotenv")
library(dotenv)
load_dot_env()
library(DBI)
# create a connection
# save the password that we can "hide" it as best as we can by collapsing it
PW <- Sys.getenv("PASSWORD_DB")
USER <- Sys.getenv("USER_DB")
PORT <- Sys.getenv("PORT")
DATABASE <- Sys.getenv("DATABASE")
HOST <- Sys.getenv("HOST_DB")
TABLE_ANSWER <- Sys.getenv("TABLE_ANSWER")
con <- dbConnect(RPostgres::Postgres(),dbname = DATABASE, 
                 host = HOST,
                 port = PORT,
                 user = USER,
                 password = PW)

COG_2018_COMMUNE_EPCI <- dbReadTable(con, "COG_2018_COMMUNE_EPCI")
DF_DEP <- dbReadTable(con, "QUIZZ_ODD_DEP_2019_03_05")
DF_DEP <- DF_DEP[!is.na(DF_DEP$Zone),]
DF_EPCI <- dbReadTable(con, "QUIZZ_ODD_EPCI_2019_03_05")
DF_EPCI <- DF_EPCI[!is.na(DF_EPCI$Zone),]
IND <- dbReadTable(con, "Tab_passage_Ind_ODD")
DF_FR <- dbReadTable(con, "QUIZZ_ODD_FM_2019_03_05")
DF_FR <- DF_FR[!is.na(DF_FR$Zone),]
DF_REG <- dbReadTable(con, "QUIZZ_ODD_REG_2019_03_05")
DF_REG <- DF_REG[!is.na(DF_REG$Zone),]
DF_ANSWER <- dbReadTable(con, TABLE_ANSWER)

insert_answer <- function(line){
  query <- paste("INSERT INTO", TABLE_ANSWER, "(question_label, answer_question, right_answer, date_submit)", "VALUES", "(", line, ");")
  res <- dbSendQuery(con, query)
}


