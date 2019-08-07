#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)
library(lubridate)
library(seasonal)

#this package is just for reading in the holiday script from github
library(RCurl)

## packges in more info tab
library(shinydashboard)
library(shinyjs)
library(shinyWidgets)

#sourcing a script from github
RCurl::getURL('https://raw.githubusercontent.com/LilianYou/lubridate_examples/master/When_Chinese_New_Year.R') %>%
  parse(text = .) %>%
  eval

lunar.newyear <- function(year){
  #check that the year is an integer
  # test_int <- all.equal(year, as.integer(year), check.attributes = FALSE)
  # test_digit <- all.equal(nchar(year), nchar(as.integer(year)), check.attributes = FALSE)
  # if(test_int == FALSE){
  #   stop('Year should be an integer')
  # }
  #check that the year is 4 digit number
  if(!(nchar(year) == 4)){
    stop('Year must be 4 digits')
  }
  #check that the year is 4 digit integer number
  # if(test_digit == FALSE){
  #   stop('Year should be a 4 digits integer')
  # }
  #check that the year is within the range of dataframe
  if(!(as.numeric(year) %in% c(1930:2030))){
    stop('Year must be between 1930 - 2030')
  }

  index = as.numeric(year) - 1929
  month_ny = month(ymd(cny[index]), label = T, abbr = F)
  day_ny = day(ymd(cny[index]))
  weekday_ny = wday(ymd(cny[index]), label = T, abbr = F)
  animals = c("Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig")
  if((index + 6)%%12 == 0){
    zodiac = animals[12]
  } else{
    zodiac = animals[(index + 6)%%12]
  }
  
  cat(paste0("The ", year, " Chinese New Year is ", weekday_ny, ", ", month_ny, " ", day_ny, ".",
               " It's a ", zodiac, " year!") )
}


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel('When is Chinese New Year?'),
   fluidRow(
     column(12, br()),
     column(4, 
            radioButtons(inputId = 'calendar', label = 'Holidays',
                         choices = c('Chinese Lunar New Year'))),
     column(4, textInput(inputId = 'year', 'Choose a year')),
     column(4, actionButton(inputId = 'update', label = 'GO!'))
   ),
   fluidRow(
     column(12, h1(textOutput(outputId = 'day'), style= 'color:orange'))
   ),
   shinyWidgets::useShinydashboard(),
   shinyjs::useShinyjs()

   )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  date <- eventReactive(input$update,{
    lunar.newyear(input$year)
  })
  
  output$day <- renderPrint({
    date()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

