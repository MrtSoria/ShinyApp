
# library(countrycode)
# 
# function(input, output) {
#   
#   filteredData <- reactive({
#     data <- countries %>%
#       filter(Year == input$year) %>%
#       mutate(
#         Life_Exp = as.numeric(as.character(Life_Exp)),
#         Cal_diarias_p = as.numeric(as.character(Cal_diarias_p)),
#         Code = as.character(Code),
#       )
#     validate(
#       need(nrow(data) > 0, "No hay datos disponibles para el año seleccionado.")

# 
# Logica del server
function(input, output, session) {

  #Generar la DataTable para mostrar el dataset
    output$datos_ <- renderDT(
      datos,
      options = list(lengthchange = TRUE)
    )
    
    #Cargar datos geoespaciales con los codigos ISO
    #world <- ne_countries(scale = "medium", returnclass = "sf")
    
    #Filtrar datos por año
      # datos_fil <- reactive({
      #   datos %>%
      #     filter(Year == input$year)
      # })
      
      #Unir datos filtrados con el mapa usando los codigos ISO
      
      
      #============================================
      # PREPARACION KMEANS
      
      #Quitar columnas Country, Code y Year
      #datos_norm <- datos[,-1:-2]
      
      #Normalizar datos
      datos_norm <- datos %>% 
        mutate(across(c(Life_Exp, Cal_diarias_p, Poblacion_historica), scale))
      
      #Filtrar por año
      datos_fil <- reactive({
        df <- datos_norm
        
        df <- df %>% filter(Year == input$year)
        
        rownames(df) <- df$Code
        
        df <- select(df,-Country,-Code,-Year)
        
        return(df)
      })
      #datos_fil <- datos_norm %>% filter(Year == 1980)
      
      datos_k <- reactive({
        df <- datos_fil()
        
        #Renombrar
        #rownames(df) <- df$Code
        
        #Quitar 
        #df_k <- select(df,-Country,-Code,-Year)
        
        
        set.seed(1234)
        
        num_clusters <- 5
        
        kmeans <- kmeans(df, centers = num_clusters, nstart = 25)
        
        df$Cluster <- as.factor(kmeans$cluster)
        
        return(df)
      })
      
      # mapa_datos <- reactive({
      #   
      #   df <- datos_k()
      #   
      #   world %>%
      #     left_join(df, by = c("iso_a3_eh" = "Code")) %>%
      #     mutate(Cluster = as.factor(Cluster))
      # })
      
      
      output$mapa <- renderLeaflet({
        
        df_k <- datos_k()
        
        
        pal <- colorFactor(viridis::viridis(5), domain = df_k$Cluster)
        
        leaflet(data = world) %>%
          addTiles() %>%
          addPolygons(
            fillColor = ~pal(df_k$Cluster[match(world$iso_a3_eh, rownames(df_k))]),
            color = "black", weight = 1, fillOpacity = 0.7
          )
      })
      

      
      
      
      
      # pal <- colorFactor(viridis::viridis(num_clusters), domain = datos_k$Cluster)
      # 
      # output$mapa <- renderLeaflet({
      #   leaflet(data = world) %>%
      #     addTiles() %>%
      #     addPolygons(
      #       fillColor = ~pal(datos_k$Cluster[match(world$iso_a3_eh,rownames(datos_k))]),
      #       color = "black", weight = 1, fillOpacity =  0.7
      #     )
      # })
      
      
      #Nombre de filas como codigos de paises
      #rownames(datos_fil) <- datos_fil$Code
      
      #Quitar columnas Country, Code y Year
      #datos_k <- datos_fil[,-1:-2:-3]
      
      #Nombrar filas como paises
      #rownames(datos_fil) <- datos_fil$Country
      
      
      
      
      
      #Comprobar el numero optimo de clusters
      #fviz_nbclust(x = datos_norm , FUNcluster = kmeans, method = "silhouette") +
      #  ggtitle("Numero optimo de clusters - Metodo del codo") + theme_minimal()

      #Seed
      #set.seed(1234)
      
      #num_clusters <- 5
      
      #Aplicar kmeans
      #kmeans <- kmeans(datos_k, centers = num_clusters, nstart = 25)
      
      #Agregar cluster al dataset
      #datos_k$Cluster <- as.factor(kmeans$cluster)
      
      
      #Colorear mapa
      
      
      output$data_k <- renderDT(
        datos_k(),
        options = list(lengthchange = TRUE)
      )
      
      #Renderizar mapa
      # output$mapa <- renderLeaflet({
      #   leaflet(data = mapa_datos(), options = leafletOptions(zoomSnap = 0.5, zoomDelta = 0.5, maxZoom = 4, minZoom = 2.25)) %>%
      #     addTiles() %>%
      #     #Setear vista de inicio
      #     setView(lng = 0, lat = 30, zoom = 2) %>%
      #     addPolygons(
      #       #Color de los paises
      #       fillColor = ~colorBin("YlGnBu", Life_Exp, bins = 6)(Life_Exp),
      #       #Opacidad del color
      #       fillOpacity = 0.8,
      #       #Color de frontera
      #       color = "white",
      #       #Grosor de frontera
      #       weight = 0.5,
      #       #Popup con valor por pais
      #       popup = ~paste(name, "<br>Expectativa de vida:", round(Life_Exp, 1), "años"),
      #       label = ~name
      #     ) %>%
      #     #Leyenda del mapa
      #     addLegend("bottomright",
      #               pal = colorBin("YlGnBu", mapa_datos()$Life_Exp, bins = 6),
      #               values = mapa_datos()$Life_Exp,
      #               title = "Expectativa de vida",
      #               opacity = 1
      #     ) %>% 
      #     #Fijar limites de desplazamiento
      #     setMaxBounds(lng1 = -180, lat1 = -60, lng2 = 180, lat2 = 85)
      # })
}





#   mapa_datos <- reactive({

#     #Cargar datos geoespaciales con los codigos ISO
#     #world <- ne_countries(scale = "medium", returnclass = "sf")
#     
#     #Filtrar datos por año
#     datos_fil <- reactive({
#       datos %>%
#         filter(Year == input$year)
#     })
# 
#     #Unir datos filtrados con el mapa usando los codigos ISO
#     mapa_datos <- reactive({

  # clusters <- reactive({
  #   # Perform k-means clustering
  #   data3<- mapa_datos()[, c("Life_Exp", "Cal_diarias_p")]
  #   data3 <- na.omit(data3)
  #    data2 <- data.frame(
  #     Life_Exp = as.numeric(data3$Life_Exp),
  #     Cal_diarias_p = as.numeric(data3$Cal_diarias_p)
  #   )
  #   str(data2)
  #   kmeans(scale(data2), centers = 3)  # 3 clusters
  # })
  # output$clusterMap <- renderLeaflet({
  #   df <- mapa_datos()
  #   df <- na.omit(df)
  #   clust <- clusters()
  #   
  #   # Merge cluster results with geographical data
  #   df$cluster <- as.factor(clust$cluster)
  #   
  #   # Create color palette for clusters
  #   pal <- colorFactor(palette = c("red", "blue", "green"), domain = df$cluster)
  #   
  #   leaflet(df) %>%
  #     addTiles() %>%
  #     addCircleMarkers(
  #       lng = ~Lon, lat = ~Lat,
  #       color = ~pal(cluster),
  #       radius = 8,
  #       stroke = FALSE,
  #       fillOpacity = 0.8,
  #       popup = ~paste(Country, "<br>Expectativa de vida:", Life_Exp, "<br>",
  #                     "Calorías:", Cal_diarias_p)
  #     ) %>%
  #     addLegend(
  #       position = "bottomright",
  #       pal = pal,
  #       values = ~cluster,
  #       title = "Clusters",
  #       opacity = 1
  #     )
  # })
#}
