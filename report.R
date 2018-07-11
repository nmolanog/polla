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
list.files()%>%str_subset(".RData")
load("scores.RData")
load("scores_s2.RData")
load("scores_s3.RData")

list(scores,scores_s2,scores_s3)%>%reduce(full_join)->z0
z0$total<-apply(z0[,2:4],1,sum,na.rm=T)
z0

