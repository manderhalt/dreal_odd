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

con <- dbConnect(RPostgres::Postgres(),dbname = DATABASE, 
                 host = HOST,
                 port = PORT,
                 user = USER,
                 password = PW)
dbListFields(con, "COG_2018_COMMUNE_EPCI")
