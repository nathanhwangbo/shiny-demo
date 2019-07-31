##############################################

## this general purpose script would be in global.R ##

##############################################

library(shiny)
library(tidyverse)
#intearctive plots
library(plotly)

#mock data for app
data("mtcars")

#this package is just for reading in the holiday script from github
library(RCurl)

## packges in more info tab
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)

#sourcing a script from github
RCurl::getURL('https://raw.githubusercontent.com/nathanhwangbo/lubridate_examples/master/merry_christmas.R') %>%
  parse(text = .) %>%
  eval



####################################

## the ui assignment would be in ui.R

####################################


#alternatives to fluidPage include shinydashboard::dashboardPage, navbarPage, renderUI
ui <- fluidPage(
  #alternatives to tabsetPanel include navlistPanel (can be used indep of navbarPage), and other Page ui's have their own tab panels
  tabsetPanel(
    
    tabPanel("Interactive Plots",
             headerPanel(
               textOutput(outputId = 'header')
             ),
             #alternatives to sidebarLayout include fluidRow, flowLayout, splitLayout, verticalLayout
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
               
             ),
    
    
    
    
    
    
    shinyWidgets::useShinydashboard(),
    shinyjs::useShinyjs(),

    tabPanel('More info',
             titlePanel('Other Shiny Resources'),
             fluidRow(
               #you need the useShinydashboard() call above to use valueBoxes !
               valueBox(value = 'shinydashboard is a popular theme',
                        subtitle = 'shinyWidgets::useshinydashboard lets you use shinydashboard modules in other ui\'s',
                        color = "blue",
                        width =12)
               
               ),
             fluidRow(
               imageOutput(outputId = 'dashboard')
               ),
             fluidRow(
               column(1, actionButton(inputId = 'togglePic', label = 'Click Me!')),
               column(5,offset = 1, hidden(p(id = 'shinyjs_text' ,"shinyjs lets us use common javascript funtionality, like hiding objects")))
               ),
             br(),
             br(),
             fluidRow(
               column(12, a(href = "https://github.com/nanxstats/awesome-shiny-extensions","click here for Nan Xiao's compiled list of shiny extension packages"))
               )
             
             )



    )
  )




####################################

## the server function would be in server.R

####################################
  

#input is the set of variables the user interacts with
#output are the elements that change based on input
server <- function(input, output){
  output$carsplot <- renderPlotly({
    p <- ggplot(mtcars) +
      geom_point(aes(!!sym(input$x), !!sym(input$y)))
    ggplotly(p)
    })
  
  output$header <- renderText({
    'mtcars'
  })
  
  
  
 date <- eventReactive(input$update,{
    christmas_day(input$year)
  })

  output$day <- renderPrint({
    date()
  })
  
  
  
  
  
  
  output$dashboard <- renderImage({
    list(src = 'www/dashboard.png',
         contentType = 'image/png')
  }, deleteFile = FALSE)
  
  
  observeEvent(input$togglePic,{
    shinyjs::toggle(id = 'shinyjs_text')
  })

}




shinyApp(ui = ui, server = server)