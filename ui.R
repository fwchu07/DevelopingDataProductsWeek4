#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Family Heights"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("parentbox","Choose Parent(s)",choices=c("Mother"="mother","Father"="father"),
                         selected=c("mother","father")),
      checkboxGroupInput("childbox","Choose Child Gender(s)",choices=c("Female"="female","Male"="male"),
                         selected=c("female","male"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("heightPlot")
    )
  )
))
