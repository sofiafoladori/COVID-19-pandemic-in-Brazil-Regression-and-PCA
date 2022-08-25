set.seed(123)

# packages (also in 001_packages.R)
#code provided by Prof.Dr. Rafael de Freitas Souza and 
# Prof.Dr. Luiz Paulo Fávero during the MBA Data Science USP-Esalq
packages <- c('factoextra','gridExtra','tidyverse','gridExtra',
              'readxl','ggplot2','plotly','ggrepel','knitr')

if(sum(as.numeric(!packages %in% installed.packages())) != 0){
        instalator <- packages[!packages %in% installed.packages()]
        for(i in 1:length(instalator)) {
                install.packages(instalator, dependencies = T)
                break()}
        sapply(packages, require, character = T) 
} else {
        sapply(packages, require, character = T)
} 

################# Load Data ################# 
#data called "covid" 
covid <- read.csv("coviddata.csv")
#work with a copy "state" to keep original df
state <- covid
head(state)

################# STATE CLUSTER #################

################# Load and Prepare Data #################
state_cluster <- state
covid_state <- state #for later usage

#for plotting purpuses, the abreviation (abv) of each state will
#be added to the df
state_cluster$state #to check the order
#create the new variable
state_cluster$abv <- c("AC","AL","AP","AM","BA","CE","DF","ES","GO",
                          "MA","MT","MS","MG","PA","PB","PR","PE","PI",
                          "RJ","RN","RS","RO","RR","SC","SP","SE","TO")
#add the abv to the rownames
rownames(state_cluster) <- state_cluster$abv
#clear df, leaving only variables that will be used
state_cluster <- state_cluster[,-c(1,13,23,25)]

#standardize data
state_cluster_scale <- scale(state_cluster)

################# Kmeans #################
#run kmeans with different number of centers
covid.k2 <- kmeans(state_cluster_scale, centers = 2)
covid.k3 <- kmeans(state_cluster_scale, centers = 3)
covid.k4 <- kmeans(state_cluster_scale, centers = 4)
covid.k5 <- kmeans(state_cluster_scale, centers = 5)

#visualize the best division
#graphs
G1 <- fviz_cluster(covid.k2, geom = "point", 
                   data = state_cluster_scale) + 
        ggtitle("k = 2")
G2 <- fviz_cluster(covid.k3, geom = "point", 
                   data = state_cluster_scale) + 
        ggtitle("k = 3")
G3 <- fviz_cluster(covid.k4, geom = "point",  
                   data = state_cluster_scale) + 
        ggtitle("k = 4")
G4 <- fviz_cluster(covid.k5, geom = "point",  
                   data = state_cluster_scale) + 
        ggtitle("k = 5")

#plot matrix with 4 graphs
grid.arrange(G1, G2, G3, G4, nrow = 2)

#verify with elbow method
fviz_nbclust(state_cluster_scale, 
             FUN = hcut, method = "wss")

#data with 2 clusters selected
covidfit <- data.frame(covid.k2$cluster)
#add cluster to df
covidfinal <-  cbind(covid_state, covidfit)

#save data
write.csv(covidfinal, "covidfinal.csv")

################# clean environment #################
rm(covidfit, covid_state, state_cluster)

