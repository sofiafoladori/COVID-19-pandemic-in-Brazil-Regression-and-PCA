set.seed(123)

# packages (also in 001_packages.R)
#code provided by Prof.Dr. Rafael de Freitas Souza and 
# Prof.Dr. Luiz Paulo Fávero during the MBA Data Science USP-Esalq
packages <- c("PerformanceAnalytics","factoextra","reshape2",
             "psych",'ggfortify','tidyverse','gridExtra','readxl',
             'ggplot2','plotly','ggrepel','knitr')

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
#use data from 002_cluster.R - 'covidfinal.csv'
covidfinal <- read.csv("covidfinal.csv")
head(covidfinal)

################# tests ################# 
#correlation matrix rho
rho <- cor(covidfinal[,c(2:12,14:22,24,26)])
chart.Correlation(covidfinal[,c(2:12,14:22,24,26)])
# Kaiser-Meyer-Olkin (KMO) statistics
KMO(r = rho)
# Bartlett test
cortest.bartlett(R = rho, n=22) #n is the number of variables

################# PCA ################# 
#standardize data before pca (also done in 002_cluster.R)
covidfinal_scale <- scale(covidfinal[,c(2:12,14:22,24,26)])
pca_covid <- prcomp(covidfinal_scale)

#weight of each variable in each principal component in the pca
data.frame(pca_covid$rotation) %>%
        mutate(var = names(covidfinal[,c(2:12,14:22,24,26)])) %>% 
        melt(id.vars = "var") %>%
        mutate(var = factor(var)) %>%
        ggplot(aes(x = var, y = value, fill = var)) +
        geom_bar(stat = "identity", color = "black") +
        facet_wrap(~variable) +
        labs(x = NULL, y = NULL, fill = "Legend:") +
        scale_fill_viridis_d(option = "plasma",
                             labels = c('adequate sanitation',
                                        'mean income per capita',
                                        'cluster COVID',
                                        'deaths by 100 thousand inhabitants',
                                        'doctors by 100 thousand inhabitants',
                                        'SUS doctors by 100 thousand inhabitants',
                                        'ICU beds by 100 thousand inhabitants',
                                        'SUS ICU beds by 100 thousand inhabitants',
                                        'IDHM 2010',
                                        'IDHM education',
                                        'IDHM income',
                                        'IDHM longevity',
                                        'iadequate sanitation',
                                        'nurses by 100 thousand inhabitants',
                                        'SUS nurses by 100 thousand inhabitants',
                                        'over 60 years old',
                                        'population',
                                        'rural population', 
                                        'semiadequate sanitation',
                                        'urban population',
                                        'ventilators by 100 thousand inhabitants',
                                        'SUS ventilators by 100 thousand inhabitants'))+
        theme_bw()+
        theme(legend.title = element_text(size=1),
              legend.text = element_text(size=1),
              legend.key.size = unit(0.1, 'cm'))

# Scree Plot
ggplotly(
        fviz_eig(X = pca_covid,
                 ggtheme = theme_bw(), 
                 barcolor = "black", 
                 barfill = "dodgerblue4",
                 linecolor = "darkgoldenrod3")
)

#PCA plot
autoplot(kmeans(covidfinal_scale, 2), 
         data = covidfinal_scale, size=5)+ 
        theme_bw()+
        scale_color_manual(values = c("#8A09A5FF","#FEBA2CFF"))+
        geom_text(label=rownames(covidfinal_scale),
                  nudge_x = -0.015 , nudge_y = 0.025,
                  check_overlap = T)
