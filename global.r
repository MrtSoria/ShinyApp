# global.R
library(dplyr)

#Carga del dataset de expectativa de vida
datos <- read.csv("food-supply-vs-life-expectancy.csv")

#Cambia los nombres de las columnas
colnames(datos) <- c("Country","Code","Year","Life_Exp","Cal_diarias_p/persona","Poblacion_historica","W")

#Borra la ultima columna, que no nos sirve
datos <- select(datos, -W)

#Borra todas las tuplas con datos NA 
datos <-na.omit(datos)

#Borra las tuplas cuyo año sea menor a 1961 y el codigo no cumpla con el estandar ISO A3
datos <- datos %>% filter(
  Year >= 1961, nchar(Code) == 3
) 

min_year <- min(datos$Year)
max_year <- max(datos$Year)
