library(shiny)
library(tidyverse)
library(plotly)
data("mtcars")

source('../lubridate_examples/merry_christmas.R')


#alternatives to fluidPage include shinydashboard::dashboardPage, navbarPage.
ui <- fluidPage(
  tabsetPanel(
    
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
             
             
    ),
    
    tabPanel('Inputs and Buttons',
             titlePanel('When is your favorite holiday'),
             fluidRow(
               column(12, br()),
               column(4, 
                      radioButtons(inputId = 'calendar', label = 'Holidays',
                                       choices = c('Christmas'))),
               column(4, textInput(inputId = 'year', 'Choose a year')),
               column(4, actionButton(inputId = 'update', label = 'GO!'))
               ),
             fluidRow(
               column(12, h1(textOutput(outputId = 'day'), style= 'color:green'))
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
  
 date <- eventReactive(input$update,{
    christmas_day(input$year)
  })

  output$day <- renderPrint({
    date()
  })
  
}




shinyApp(ui = ui, server = server)