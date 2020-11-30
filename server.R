#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

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
          stat_poly_eq(aes(label = paste(..eq.label.., sep = "~~~")), 
                        label.x.npc = "right", label.y.npc = 0.1,
                        eq.with.lhs = "italic(hat(y))~`=`~",
                        eq.x.rhs = "~italic(x)",
                        formula = myformula, parse = TRUE) +
           stat_poly_eq(aes(label = paste(..rr.label.., sep = "~~~")), 
                        label.x.npc = "right", label.y.npc = "bottom",
                        formula = myformula, parse = TRUE) +
          scale_shape_manual(values=c(1,3)) +
          scale_color_manual(values=c("red","blue")) +
          ggtitle("Predicting Child's Height from Height of Parents") +
          xlab("Parent Height") +
          ylab("Child Height")
  })    
})
