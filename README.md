# <div align="center">COVID-19 pandemic in Brazil: Regression and PCA</div>  
  

#### <div align="center">The project links mortality data with socioeconomic factors. 
It seeks to understand the COVID-19 pandemic in Brazil. For this, we will do a regression analysis and a PCA to understand the impact of socioeconomic factors on the mortality due to SARS-CoV-2 in the different Brazilian states. </div>  
  

- Cluster Analysis  
  

- Linear Regression  
  

- Principal Component Analysis (PCA)  
  

<br/>  



### Data  
- socioeconomic data - obtained from IBGE  
  

- IDHM data - obtained from PNUD Brazil  
  

- COVID-19 deaths from the begging of the pandemic in Brazil until the 31/Dec/2020 - obtained from the national website https://covid.saude.gov.br/  
  

- shapefile from Brazil – obtained from IBGE: https://www.ibge.gov.br/geociencias/organizacao-do-territorio/malhas-territoriais/15774-malhas.html?=&t=acesso-ao-produto  
  



### The complete dataframe has the following variables:  
* state
* people over 60 years 
* urban population
* rural population
* adequate sanitation
* semi adequate sanitation
* inadequate sanitation
* average income per capita
* IDHM 2010
* IDHM income
* IDHM longevity
* IDHM education
* population density
* population
* ICU beds per 100 thousand inhabitants
* ventilators per 100 thousand inhabitants
* doctors per 100 thousand inhabitants
* nurses per 100 thousand inhabitants
* ICU beds of the public system (SUS) per 100 thousand inhabitants
* ventilators of the public system (SUS) per 100 thousand inhabitants
* doctors of the public system (SUS) per 100 thousand inhabitants
* nurses of the public system (SUS) per 100 thousand inhabitants
* total covid deaths
* covid deaths per 100 thousand inhabitants
  
  



### Scripts:  
Five scripts will be used for the different analyses:
* 001_packages.R - all the packages used and their function 
* 002_cluster.R - cluster analysis
* 003_regression.R - linear regression analysis
* 004_cluster_map.R  - maps the clusters in the Brazilian map
* 005_pca.R - PCA analysis
  

<br />

----
<div align="center">Generated using <a href="https://profilinator.rishav.dev/" target="_blank">Github Profilinator</a></div>
