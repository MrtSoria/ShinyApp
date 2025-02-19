# ui.R
library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Life expectancy"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          #Slider de tiempo
            sliderInput("year", "Seleccione el año:",
                        min = min_year,
                        max = max_year,
                        value = max_year,
                        step = 1,
                        sep = "")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          #Pestañas
          tabsetPanel(
            #Pestaña del mapa
            tabPanel("Grafico", leafletOutput("mapa", height = "800px")),
            #Pestaña del dataset lifeExp
            tabPanel("Data", dataTableOutput("datos_"))
          )
        )
    )
)
