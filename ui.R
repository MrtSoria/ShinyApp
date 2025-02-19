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
                             sep = "")
               ),
               mainPanel(
                 leafletOutput("mapa", height = "800px")
                 )
               ),

      #Pestaña del dataset lifeExp
      tabPanel("Data", dataTableOutput("datos_")),
      
      tabPanel("Data_norm", dataTableOutput("data_k"))
    )
)