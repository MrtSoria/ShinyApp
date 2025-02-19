#UI
# 
# fluidPage(
#   titlePanel("Clustering de países por indicadores de salud"),
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("year", "Selecciona un año:",
#                   min = 1961, max = 2021,
#                   value = 2021, step = 1,
#                   animate = TRUE)
#     ),
#     mainPanel(
#       leafletOutput("clusterMap", height = "800px")

# UI
fluidPage(

    # Título
    titlePanel("Life expectancy"),

    tabsetPanel(
      # Pestaña del mapa
      tabPanel("Grafico",
               sidebarPanel(
                 # Slider de tiempo
                 sliderInput("year", "Seleccione el año:",
                             min = min_year,
                             max = max_year,
                             value = max_year,
                             step = 1,
                             sep = ""),
                 # Párrafo de texto debajo del slider
                 p("Utilice el slider para seleccionar el año que desea explorar en el mapa interactivo.")
               ),
               mainPanel(
                 leafletOutput("mapa", height = "750px"),
                 wellPanel(
                   p("En el mapa se muestran los países clasificados en clústers de acuerdo a su expectativa de vida y su consumo de alimentos.")
                 ),
                 p("UN, World Population Prospects (2024) – processed by Our World in Data. “Life Expectancy, age 0 – UN WPP”.", class = "text-muted")
               ),
               
      ),

      # Pestaña del dataset lifeExp
      tabPanel("Data", dataTableOutput("datos_")),
      
      tabPanel("Data_norm", dataTableOutput("data_k"))
    )
)