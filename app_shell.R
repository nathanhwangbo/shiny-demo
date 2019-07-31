##############################################

## this general purpose script would be in global.R ##

##############################################
library(shiny)
library(tidyverse)
library(plotly)
data("mtcars")


####################################

## the ui assignment would be in ui.R

####################################
ui <- fluidPage(
  
  

  )




####################################

## the server function would be in server.R

####################################

server <- function(input, output, session){

  
  }

shinyApp(ui = ui, server = server)
