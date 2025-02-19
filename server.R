library(shiny)
library(leaflet)
library(dplyr)
library(countrycode)
library(rnaturalearth)
library(rnaturalearthdata)

function(input, output) {
  
  filteredData <- reactive({
    data <- countries %>%
      filter(Year == input$year) %>%
      mutate(
        Life_Exp = as.numeric(as.character(Life_Exp)),
        Cal_diarias_p = as.numeric(as.character(Cal_diarias_p)),
        Code = as.character(Code),
      )
    validate(
      need(nrow(data) > 0, "No hay datos disponibles para el año seleccionado.")
    )
    data
  })
  world <- ne_countries(scale = "medium", returnclass = "sf")

  
  mapa_datos <- reactive({
      world %>%
        left_join(filteredData(), by = c("iso_a3" = "Code"))
    })
  clusters <- reactive({
    # Perform k-means clustering
    data3<- mapa_datos()[, c("Life_Exp", "Cal_diarias_p")]
    data3 <- na.omit(data3)
     data2 <- data.frame(
      Life_Exp = as.numeric(data3$Life_Exp),
      Cal_diarias_p = as.numeric(data3$Cal_diarias_p)
    )
    str(data2)
    kmeans(scale(data2), centers = 3)  # 3 clusters
  })
  output$clusterMap <- renderLeaflet({
    df <- mapa_datos()
    df <- na.omit(df)
    clust <- clusters()
    
    # Merge cluster results with geographical data
    df$cluster <- as.factor(clust$cluster)
    
    # Create color palette for clusters
    pal <- colorFactor(palette = c("red", "blue", "green"), domain = df$cluster)
    
    leaflet(df) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~Lon, lat = ~Lat,
        color = ~pal(cluster),
        radius = 8,
        stroke = FALSE,
        fillOpacity = 0.8,
        popup = ~paste(Country, "<br>Expectativa de vida:", Life_Exp, "<br>",
                      "Calorías:", Cal_diarias_p)
      ) %>%
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~cluster,
        title = "Clusters",
        opacity = 1
      )
  })
}
