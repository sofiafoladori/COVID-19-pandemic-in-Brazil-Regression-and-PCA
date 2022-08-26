set.seed(123)

# packages (also in 001_packages.R)
#code provided by Prof.Dr. Rafael de Freitas Souza and 
# Prof.Dr. Luiz Paulo Fávero during the MBA Data Science USP-Esalq
packages <- c('fastDummies', 'PerformanceAnalytics', 'jtools', 
              'nortest', 'olsrr','tidyverse','gridExtra','readxl',
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
#use data from 002_cluster.R - "covidfinal"
covidfinal <- read.csv("covidfinal.csv")
head(covidfinal)

################# cluster as variable - dummy #################
covidfinal_dummy <- dummy_columns(.data = covidfinal,
                                  select_columns = "covid.k2.cluster",
                                  remove_selected_columns = T,
                                  remove_most_frequent_dummy = T)

################# prepare df ################# 
#use log(deaths) as y variable
covidfinal_dummy$log_deaths <- log(covidfinal_dummy$deaths_100thousand)

#organize order for visualization
covidfinal_dummy <- covidfinal_dummy |>
        dplyr::select(abv,state,deaths_100thousand,log_deaths,covid.k2.cluster_2,
                      everything())

################# correlation #################
#select only relevant columns for correlation. In this case
#state names, deaths variables (other than log), SUS related 
#variables and rural areas were removed
correlation <- as.data.frame(cor(covidfinal_dummy[, c(4:7,9:16,18:22)]))
chart.Correlation(correlation, histogram=TRUE, pch=19)

################# Regression model ################# 
regression  <- lm(formula = log_deaths ~
                          idhm  + 
                          idhm_income  + 
                          idhm_longevity  +
                          idhm_education  + 
                          icu_beds_SUS_100thousand  + 
                          ventilators_100thousand  + 
                          doctors_SUS_100thousand + 
                          nurses_SUS_100thousand+          
                          over60+
                          urban+
                          adequate_sanitation+
                          semiadequate_sanitation+
                          inadequate_sanitation+
                          avg_income+
                          covid.k2.cluster_2,
                  data = covidfinal_dummy)
summary(regression)
#stepwise
step_regression <- step(regression, k = 3.841459)
regression_final <- lm(formula = log_deaths ~
                               over60 + 
                               idhm_income +
                               covid.k2.cluster_2 +  
                               ventilators_100thousand +
                               semiadequate_sanitation, 
                       data = covidfinal_dummy)
summary(regression_final) 

#visualize the results - 2 options
summ(regression_final, confint = T, digits = 4, ci.width = .95)
export_summs(regression_final, scale = F, digits = 5)

################# tests #################
#Shapiro-Francia
sf.test(regression_final$residuals) 

#plot residuals
regression_final %>% 
        ggplot(aes(x = regression_final$residuals)) + 
        geom_histogram(color = "white", fill = "#440154FF", 
                       bins = 30, alpha = 0.6) + 
        labs(x = "Residuals", y = "Frequence") + theme_bw()
#other option
hist(regression_final$residuals)

#qqplot
qqnorm(regression_final$residuals, pch = 1, frame = FALSE)
qqline(regression_final$residuals, col = "steelblue", lwd = 2)

#OLS
ols_vif_tol(regression_final)

#Breusch-Pagan - heteroscedasticity. IF H0 acepted, no heteroscedasticity.
ols_test_breusch_pagan(regression_final) 

################# clean environment #################
rm(regression, step_regression)

