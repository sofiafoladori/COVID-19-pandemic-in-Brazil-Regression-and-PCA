#packages

#general - used in most scripts
library(tidyverse) #organize data
library(gridExtra) #grid arrange
library(readxl) #read excel
library(ggplot2) #graphs
library(plotly) #graphs
library(ggrepel) #graphs
library(knitr) #tables

#cluster - used in 002_cluster.R
library(factoextra) #cluster and visualizing

#regression - used in 003_regression.R 
library(PerformanceAnalytics) #correlation
library(jtools) #regression visualization summ()
library(olsrr) #regression test
library(fastDummies) #dummies
library(nortest) #Shapiro-Francia

#map - used in 004_cluster_map.R
library(rgdal) #read map
library(tmap) #plot nap

#PCA - used in 005_pca.R
library(PerformanceAnalytics) #correlation
library(factoextra) #fviz_eig()
library(reshape2) #melt()
library(psych) #kmo statistics
library(ggfortify) #autoplot

#option for fast installing and loading packages
#code provided by Prof.Dr. Rafael de Freitas Souza and 
# Prof.Dr. Luiz Paulo Fávero during the MBA Data Science USP-Esalq
packages <- #c('add packages here')

if(sum(as.numeric(!packages %in% installed.packages())) != 0){
        instalator <- packages[!packages %in% installed.packages()]
        for(i in 1:length(instalator)) {
                install.packages(instalator, dependencies = T)
                break()}
        sapply(packages, require, character = T)
        } else {
                sapply(packages, require, character = T) 
}

