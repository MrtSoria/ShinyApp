
# UI
fluidPage(
  
  # Titulo
  titlePanel("Life expectancy"),
  
  tabsetPanel(
    #Pestaña principal
    tabPanel("Inicio",
             HTML("
             <h2>Cisneros Ian - Soria Martin</h2>
             <h3>Dataset</h3>
                <a href='https://ourworldindata.org/grapher/food-supply-vs-life-expectancy'>Food supply vs Life expectancy</a> 
              <h4>Variables</h4>
              <ul>
                <li><strong>Country:</strong> nombre del pais(en ingles)</li>
                <li><strong>Code:</strong> codigo segun el estandar ISO 3166-1 alfa-3</li>
                <li><strong>Year:</strong> año en el que fueron tomados los datos del pais</li>
                <li><strong>Life_Exp:</strong> expectativa de vida al nacer, medida en la edad de muerte esperada(en ingles)</li>
                <li><strong>Cal_diarias_p:</strong> aporte calorico diario per capita, correspondiente a la cantidad de calorias disponibles para una persona promedio, no necesariamente corresponde con el consumo</li>
                <li><strong>Poblacion_historica:</strong> poblacion del pais</li>
                <li><strong>W:</strong> regiones segun Our World In Data</li>
              </ul>
              
             <h3>Modificacion del dataset</h3>
             <p>Para poder utilizar el dataset tuvimos que potabilizarlo para llevar a cabo el kmeans</p>
              <ol>
              <li>Quitar la ultima columna, ya que no contenia datos de interes</li>
              <li>Quitar las filas que contengan algun campo como NA(motivo por el cual algunos paises quedaron afuera)</li>
              <li>Filtrar el dataset, quitando aquellas filas cuyo año este fuera del rango 1961-2021, esto ya que segun lo que observamos este rango abarca la mayoria de paises</li>
              <li>Filtrar el dataset quitando aquellas filas cuyo codigo no cumpla con el estandar ISO 3166-1 alfa-3</li>
              </ol>
                
             <h3>Caracteristicas</h3>
              <ul>
              <li><strong>Slider de tiempo:</strong> permite seleccionar el año a partir del cual se toman los datos(desde 1961 hasta 2021)</li>
              <li><strong>Slider de clusters:</strong> permite seleccionar el numero de clusters a aplicar en el kmeans(desde 2 hasta 10)</li>
              <li><strong>Mapa interactivo:</strong> permite visualizar todos los paises del mundo, coloreados segun el cluster en que fueron organizados por el algoritmo de k-means, dejando en gris aquellos cuyos datos no hayan sido tomados, permtiendo ver los valores del pais que seleccione</li>
              </ul>
              
              <h3>Librerias principales</h3>
              <ul>
              <li><strong>Leaflet:</strong> para la personalizacion y renderizado del mapa</li>
              <li><strong>RNaturalLearnEarth:</strong> para obtener los datos para la construccion del mapa</li>
              </ul>
                  ")
             ),
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