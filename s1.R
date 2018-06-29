#######################
###load data from RA BASE (2)
######################
rm(list=ls())
options(max.print=999999)
setwd("/media/nicolas/DATOS/Rprojects/polla")
library(here)
library(bueri)
library(tidyverse)
library(openxlsx)
library(stringr)
file_names<-list.files()%>%str_subset(".xlsx")
file_names<-file_names[!file_names%in% c("equipos_1era_r.xlsx","Formato_segunda_ronda.xlsx")]
xlsx_list<-NULL
for(i in file_names){
  xlsx_list[[i]]<-read.xlsx(i, sheet =1, colNames = TRUE)
}
ronda1<-read.xlsx("equipos_1era_r.xlsx", sheet =1, colNames = TRUE)
clasificados<-ronda1%>%filter(ronda1 ==1)%>%.[,1]
xlsx_list%>%reduce(full_join)->z0
z0%>%select(-PAIS)%>%apply(1,sum,na.rm=T)->bets
z0%>%select(-PAIS)%>%apply(2,sum,na.rm=T)
bets<-data.frame(PAIS=z0$PAIS,bets=bets)
bets2<-bets
bets2$PAIS<-factor(bets2$PAIS,levels=bets[order(bets$bets,decreasing=T),"PAIS"])
bets2%>%ggplot(aes(x=PAIS,y=bets))+geom_bar(stat="identity")+theme_bw()+
  scale_y_continuous(breaks=seq(1,14,1))+ coord_flip()

z0%>%filter(PAIS %in% clasificados)%>%select(-PAIS)%>%apply( 2,sum,na.rm=T)->score_s1
scores<-data.frame(id=names(score_s1),score_s1=score_s1)
scores$id<-factor(scores$id,levels=scores[order(scores$score_s1,decreasing = T),"id"])
row.names(scores)<-NULL

scores%>%ggplot(aes(x=id,y=score_s1))+geom_bar(stat="identity")+theme_bw()+
  scale_y_continuous(breaks=seq(1,14,1))+ coord_flip()
save(scores,file="scores.RData")

write.xlsx(ronda1%>%filter(ronda1 ==1),"Formato_segunda_ronda.xlsx")
