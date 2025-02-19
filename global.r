# global.R
library(dplyr)

#Carga del dataset de expectativa de vida
data1 <- read.csv("https://ourworldindata.org/grapher/life-expectancy.csv?v=1&csvType=full&useColumnShortNames=true")

#Cambio de nombre de columnas para mayor comodidad
colnames(data1) <- c("pais","iso_a3","year","lifeExp")

min_year <- min(data1$year)
max_year <- max(data1$year)
