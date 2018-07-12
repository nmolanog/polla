#######################
###load data from RA BASE (2)
######################
rm(list=ls())
options(max.print=999999)
setwd("/media/nicolas/DATOS/Rprojects/polla/ronda4")
library(here)
library(bueri)
library(tidyverse)
library(openxlsx)
library(stringr)
file_names<-list.files()%>%str_subset(".xlsx")
xlsx_list<-NULL
for(i in file_names){
  xlsx_list[[i]]<-read.xlsx(i, sheet =1, colNames = TRUE)
}
clasificados<-c("FRANCIA","CROACIA")
xlsx_list%>%reduce(full_join)->z0
z0%>%filter(PAIS %in% clasificados)%>%select(-PAIS)%>%apply( 2,sum,na.rm=T)->score_s4
scores<-data.frame(id=names(score_s4),score_s4=score_s4)
scores$id<-factor(scores$id,levels=scores[order(scores$score_s4,decreasing = T),"id"])
row.names(scores)<-NULL

setwd("..")
scores->score_s4
save(score_s4,file="scores_s4.RData")


