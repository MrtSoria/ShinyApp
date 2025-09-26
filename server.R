# Logica del server
function(input, output, session) {
    
    #Filtrar datos por año
      datos_fil <- reactive({
        df <- datos %>% filter(Year == input$year)
        return(df)
      })
      
      #Datos kmeans
      datos_k <- reactive({
        #Se usan los datos filtrados de base
        df <- datos_fil()
        
        #Cambiar nombres de filas por codigos ISO
        rownames(df) <- df$Code
        
        #Se borran columnas que no sirven para el kmeans 
        df <- df %>% select(-Country,-Code,-Year)
        
        #Se normalizan los datos
        df <- df %>% mutate(across(c(Life_Exp, Cal_diarias_p, Poblacion_historica), scale))
        
        #Setear semilla 
        set.seed(1234)
        
        #Kmeans
        k <- kmeans(df, centers = input$clusters, nstart = 25)
        
        #Agregar nro de cluster a cada pais
        df$Cluster <- as.factor(k$cluster)
        
        return(df)
      })
      
      # Resumen de límites de cada cluster
      cluster_limits <- reactive({
        df_k <- datos_k()
        
        df_real <- datos_fil() %>%
          mutate(Cluster = df_k$Cluster)
        
        df_real %>%
          group_by(Cluster) %>%
          summarise(
            LifeExp = paste0(
              round(min(Life_Exp, na.rm = TRUE),1), " – ",
              round(max(Life_Exp, na.rm = TRUE),1), " años"
            ),
            Calorias = paste0(
              round(min(Cal_diarias_p, na.rm = TRUE),0), " – ",
              round(max(Cal_diarias_p, na.rm = TRUE),0), " kcal"
            )
          )
      })
      #Renderizar el mapa
      output$mapa <- renderLeaflet({
        
        #Tomamos datos del kmeans para pintar el mapa
        df_k <- datos_k()
        
        #Tomamos datos filtrados para brindar la info de cada pais
        df_info <- datos_fil()
        
        #Generamos una paleta de colores en base a los clusters formados
        pal <- colorFactor(viridis::viridis(input$clusters), domain = df_k$Cluster)
        
        #Generar mapa
        leaflet(data = world, options = leafletOptions(zoomSnap = 0.5, zoomDelta = 0.5, maxZoom = 4, minZoom = 2)) %>%
          addTiles() %>%
          #Establecer la vista inicial del mapa
          setView(lng = 0, lat = 30, zoom = 2.25) %>%
          addPolygons(
            #Color de paises(matcheado usando los codigos ISO)
            fillColor = ~pal(df_k$Cluster[match(world$iso_a3_eh, rownames(df_k))]),
            #Color de limites
            color = "black", weight = 1, fillOpacity = 0.7,
            highlightOptions = highlightOptions(
              color = "white",
              weight = 2,
              fillOpacity = 1,
              bringToFront = TRUE
            ),
            #Popup con info de cada pais
            popup = ~paste("<strong>Country: </strong>",world$name,
                           "<br><strong>Expectativa de vida: </strong>", round(df_info$Life_Exp[match(world$iso_a3_eh,df_info$Code)]), " años",
                           "<br><strong>Cal. diarias p/persona: </strong>", df_info$Cal_diarias_p[match(world$iso_a3_eh,df_info$Code)],
                           "<br><strong>Poblacion: </strong>", df_info$Poblacion_historica[match(world$iso_a3_eh,df_info$Code)]
            )
          ) %>%
          #Leyenda con los colores por cluster
          addLegend("bottomright",
                    pal = pal,
                    values = df_k$Cluster,
                    title = "Clusters",
                    opacity = 0.7
          ) %>%
          #Fijar limites de desplazamiento
          setMaxBounds(lng1 = -180, lat1 = -60, lng2 = 180, lat2 = 85)
      })
      
      #Generar la DataTable datos_f para mostrar el dataset filtrado
      output$data_f <- renderDT(
        datos,
        options = list(lengthchange = TRUE)
      )
      
      #Generar la DataTable datos_k para mostrar el dataset filtrado
      output$data_k <- renderDT(
        datos_k(),
        options = list(lengthchange = TRUE)
      )
      
      #Generar la DataTable datos_o para mostrar el dataset filtrado
      output$data_o <- renderDT(
        datos_or,
        options = list(lengthchange = TRUE)
      )
      
      #Mostrar limites de clusters
      output$limites_clusters <- renderTable(
        cluster_limits()
      )
}





