library(shiny)
library(tidyverse)
library(plotly)
data("mtcars")

ui <- fluidPage(
  headerPanel('Hello World'),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = 'x',
        label = 'X-axis',
        choices = names(mtcars),
        selected = 'mpg'
      ),
      selectInput(
        inputId = 'y',
        label = 'Y-axis',
        choices = names(mtcars),
        selected = 'cyl'
      )
    ),
    mainPanel(
      plotlyOutput(outputId = 'carsplot')
    )
    
  )
  
  
)

#input is the set of variables the user interacts with
#output are the elements that change based on input
server <- function(input, output){
  output$carsplot <- renderPlotly(
    ggplot(mtcars) +
      geom_point(aes(!!sym(input$x), !!sym(input$y)))
    )
  
}


shinyApp(ui = ui, server = server)