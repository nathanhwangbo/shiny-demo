library(shiny)
library(tidyverse)
library(plotly)
data("mtcars")




# ui <- fluidPage(
#   fluidRow(
#     h1(column(12, 'hello')),
#     h2(column(12, ''))
#   )
# )


ui <- fluidPage(
  tabsetPanel(
    tabPanel('Reactivity',
             mainPanel(
               actionButton(inputId = 'dice', label = 'Who is the best', style = 'background-color:green; color:white; font-size:50px; '),
               h1(textOutput(outputId = 'names'))
             )
             ),
    tabPanel("Interactive Plots",
             headerPanel(
               textOutput(outputId = 'header')#,
             ),
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


    )
  )
  

#input is the set of variables the user interacts with
#output are the elements that change based on input
server <- function(input, output, session){
  output$carsplot <- renderPlotly(
    ggplot(mtcars) +
      geom_point(aes(!!sym(input$x), !!sym(input$y)))
    )
  
  output$header <- renderText({
    'mtcars'
  })
  
  names <- c('Nathan','Lily', 'Jeremy', 'Julien', 'Robert', 'Meilin')
  output$names <- renderText('Click the button')
  
 # observeEvent(input$dice,{
 #    output$names <- renderText(sample(names,1))
 #  })
  
  # best <- reactive({
  #   if(input$dice){
  #     sample(names, 1)
  #   }
  #   else{
  #     'click the button'
  #   }
  # })
  
  best <- eventReactive(input$dice,{
    sample(names, 1)
  })
  
  
  output$names <- renderText({
    best()
  })
  
}




shinyApp(ui = ui, server = server)