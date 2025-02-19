# global.R
library(dplyr)

#Carga del dataset de expectativa de vida
datos <- read.csv("food-supply-vs-life-expectancy.csv")

#Borra la ultima columna, que no nos sirve
datos <- select(datos, -W)

#Borra todas las tuplas con datos NA 
datos <-na.omit(datos)

#Borra las tuplas cuyo año sea menor a 1961 y el codigo no cumpla con el estandar ISO A3
datos <- datos %>% filter(
  Year >= 1961, nchar(Code) == 3
) 

min_year <- 1961
max_year <- max(datos$Year)

countries <- datos
