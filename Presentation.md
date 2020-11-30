<style>
.small-code pre code {
  font-size: 0.85em;
}
</style>

Developing Data Products: Week 4 Presentation
========================================================
author: Felicia Chu
date: 11/29/2020
autosize: true

Overview of Project
========================================================
This project requires creating a Shiny Application that includes the following:

1) Some form of input (widget: textbox, radio button, checkbox, ...)

2) Some operation on the ui input in server.R

3) Some reactive output displayed as a result of server calculations

4) You must also include enough documentation so that a novice user could use your application.

5) The documentation should be at the Shiny website itself. Do not post to an external link.



Data and App
========================================================
<small>
Data
- The apps uses "GaltonFamilies" from the "HistData" package
- Data consists of observations for 934 children in 205 families
- Observations include the heights of parents and their children

The app uses user inputs to do the following:
- Filters dataset to only include selected inputs
- Create plot, with heights of selected parent(s) along X-axis and selected child gender(s) along y-axis
- Plot uses different symbols to indicate parent gender and different colors to indicate child gender
- Calculates regression model and r-squared for selected inputs; displays calculations in bottom right corner of plot</small>

ui.R Code
========================================================
class: small-code


```r
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
```

server.R Code
========================================================
class: small-code


```r
library(shiny); library(tidyr); library(HistData); library(plotly); library(ggplot2); library(ggpmisc)

data("GaltonFamilies")
GaltonFamilies_long <- gather(GaltonFamilies,parent,parentHeight,father:mother,factor_key = TRUE)
familyheight<- GaltonFamilies_long[with(GaltonFamilies_long, order(family, childNum)),]

# Define server logic required to draw scatterplot - use selected inputs as x (parent) and y (child) values
shinyServer(function(input,output) {
  mydata <- reactive({
    df <- familyheight %>%
      filter(parent %in% input$parentbox) %>%
      filter(gender %in% input$childbox)
  })
  output$heightPlot <- renderPlot ({
      myformula <- mydata()$childHeight ~ mydata()$parentHeight
      ggplot(mydata(),aes(x=parentHeight,y=childHeight)) +
          geom_point(aes(shape=parent,color=gender)) +
          geom_smooth(method = "lm", se = FALSE) + 
          stat_poly_eq(aes(label = paste(..eq.label.., sep = "~~~")),label.x.npc = "right", label.y.npc = 0.1,
                        eq.with.lhs = "italic(hat(y))~`=`~", eq.x.rhs = "~italic(x)",
                        formula = myformula, parse = TRUE) +
          stat_poly_eq(aes(label = paste(..rr.label.., sep = "~~~")),label.x.npc = "right", label.y.npc = "bottom",
                        formula = myformula, parse = TRUE) +
          scale_shape_manual(values=c(1,3)) +
          scale_color_manual(values=c("red","blue")) +
          ggtitle("Predicting Child's Height from Height of Parents") +
          xlab("Parent Height") +
          ylab("Child Height")
  })    
})
```
