library(shiny)
library(leaflet)
library(dplyr)
library(countrycode)


fluidPage(
  titlePanel("Clustering de países por indicadores de salud"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Selecciona un año:",
                  min = 1961, max = 2021,
                  value = 2021, step = 1,
                  animate = TRUE)
    ),
    mainPanel(
      leafletOutput("clusterMap", height = "800px")
    )
  )
)