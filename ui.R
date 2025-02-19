
# UI
fluidPage(
  
  # Titulo
  titlePanel("Life expectancy"),
  
  tabsetPanel(
    #Pestaña del mapa
    tabPanel("Grafico",
             sidebarPanel(
               #Slider de tiempo
               sliderInput("year", "Seleccione el año:",
                           min = min_year,
                           max = max_year,
                           value = max_year,
                           step = 1,
                           sep = ""),
               sliderInput("clusters", "Seleccione el nro. de clusters:",
                           min = 2,
                           max = 10,
                           value = 6,
                           step = 1,
                           sep = ""),
               # Párrafo de texto debajo del slider
               p("Utilice los sliders para seleccionar el año que desea explorar en el mapa interactivo y el numero de clusters en los que desea agrupar los paises.")
             ),
             mainPanel(
               leafletOutput("mapa", height = "750px"),
               wellPanel(
                 p("En el mapa se muestran los países clasificados en clústers de acuerdo a su expectativa de vida y su consumo de alimentos.")
               ),
               p("UN, World Population Prospects (2024) – processed by Our World in Data. “Life Expectancy, age 0 – UN WPP”.", class = "text-muted")
             ),
    ),
    
    #Pestaña que muestra los datos filtrados 
    tabPanel("Data Filtrada", dataTableOutput("data_f")),
    
    #Pestaña que muestra los datos usados en el K Means
    tabPanel("Data K-Means", dataTableOutput("data_k")),
    
    #Pestaña que muestra el dataset original
    tabPanel("Data Original", dataTableOutput("data_o"))
  )
)