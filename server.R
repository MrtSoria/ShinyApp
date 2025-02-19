# server.R
library(dplyr)
library(shiny)
library(DT)
library(leaflet)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# Define server logic required to draw a histogram
function(input, output, session) {

    #Generar la DataTable para mostrar el dataset
    output$datos_ <- renderDT(
      datos,
      options = list(lengthchange = TRUE)
    )

    #Cargar datos geoespaciales con los codigos ISO
    world <- ne_countries(scale = "medium", returnclass = "sf")

    #Filtrar datos por año
    datos_fil <- reactive({
      datos %>%
        filter(Year == input$year)
    })

    #Unir datos filtrados con el mapa usando los codigos ISO
    mapa_datos <- reactive({
      world %>%
        left_join(datos_fil(), by = c("iso_a3" = "Code"))
    })

    #Renderizar mapa
    output$mapa <- renderLeaflet({
      leaflet(data = mapa_datos(), options = leafletOptions(zoomSnap = 0.5, zoomDelta = 0.5, maxZoom = 4, minZoom = 2.25)) %>%
        addTiles() %>%
        #Setear vista de inicio
        setView(lng = 0, lat = 30, zoom = 2) %>%
        addPolygons(
          #Color de los paises
          fillColor = ~colorBin("YlGnBu", Life_Exp, bins = 6)(Life_Exp),
          #Opacidad del color
          fillOpacity = 0.8,
          #Color de frontera
          color = "white",
          #Grosor de frontera
          weight = 0.5,
          #Popup con valor por pais
          popup = ~paste(name, "<br>Expectativa de vida:", round(Life_Exp, 1), "años"),
          label = ~name
        ) %>%
        #Leyenda del mapa
        addLegend("bottomright",
                  pal = colorBin("YlGnBu", mapa_datos()$Life_Exp, bins = 6),
                  values = mapa_datos()$Life_Exp,
                  title = "Expectativa de vida",
                  opacity = 1
                  ) %>%
        #Fijar limites de desplazamiento
        setMaxBounds(lng1 = -180, lat1 = -60, lng2 = 180, lat2 = 85)
    })
}
