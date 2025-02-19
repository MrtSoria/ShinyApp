# global.R

#library(countrycode)

library(dplyr)
library(shiny)
library(DT)
library(leaflet)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(factoextra)

#Carga del dataset de expectativa de vida
datos <- read.csv("food-supply-vs-life-expectancy.csv")

#Conservamos los datos originales para compararlos con los filtrados
datos_or <- datos

#Borra la ultima columna, que no nos sirve
datos <- select(datos, -W)

#Borra todas las tuplas con datos NA 
datos <-na.omit(datos)

#Borra las tuplas cuyo año sea menor a 1961 y el codigo no cumpla con el estandar ISO A3
datos <- datos %>% filter(
  Year >= 1961, nchar(Code) == 3
) 

#Cargar datos geoespaciales
world <- ne_countries(scale = "medium", returnclass = "sf")

#Limite de años para el slider de tiempo
min_year <- 1961
max_year <- max(datos$Year)

