#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)


# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          #Slider de tiempo
            sliderInput("year", "Seleccione el año:",
                        min = min(data1$year),
                        max = max(data1$year),
                        value = max(data1$year),
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
            tabPanel("Data", dataTableOutput("data1_"))
          )
        )
    )
)

