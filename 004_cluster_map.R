set.seed(123)

# packages (also in 001_packages.R)
#code provided by Prof.Dr. Rafael de Freitas Souza and 
# Prof.Dr. Luiz Paulo Fávero during the MBA Data Science USP-Esalq
packages <- c('rgdal','knitr','tmap','tidyverse','gridExtra',
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

################# Load and Prepare Data ################# 
shp_br <- readOGR(dsn = "BR_UF_2021/BR_UF_2021.shp")
#from - https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html?=&t=acesso-ao-produto

#basic information
summary(shp_br)
class(shp_br)
typeof(shp_br)
shp_br@data %>% 
        kable() %>%
        kable_styling(bootstrap_options = "striped", 
                      full_width = TRUE, 
                      font_size = 16)

#fix accents 
Encoding(shp_br@data$NM_UF) = "UTF-8"

#add cluster (from 002_cluster.R)
shp_br@data$cluster <- c('1','1','1','1','1','1','1','1','1','1','1',
                         '1','1','1','1','1','2','1','1','2','2',
                         '2','2','1','1','1','1')

################# plot map ################# 
dev.off()
tm_shape(shp = shp_br) +
        tm_fill(col = "cluster", 
                palette=c("#8A09A5FF","#FEBA2CFF"), #from viridis
                title="Cluster", labels = c("1","2"))+
        tm_borders() +
        tm_text(text = "SIGLA", size = 0.8)+ 
        tm_layout(legend.title.size=1, legend.text.size=1,
                  legend.position = c("left", "bottom"), scale=1)
