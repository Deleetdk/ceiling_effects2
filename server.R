
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(grid)
library(MASS)
library(psych)
library(stringr)

n = 10000

shinyServer(function(input, output) {
  
  reac_data = reactive({
    #update
    input$update
    #this is to avoid spamming the server with generate data requests
    
    isolate({
      #generate data
      set.seed(1)
      d = data.frame(
        A = rnorm(n, input$A_mean, 15),
        B = rnorm(n, input$B_mean, 15)
      )

      d = stack(d)

      #add mor
      d$group = rep("Within limits", n * 2)
      
      #ceiling
      above.ceiling = d$values > input$celing
      d[above.ceiling, "values"] = input$celing - 0.000001
      d[above.ceiling, "group"] = "Above ceiling"
      
      #floor
      below.ceiling = d$values < input$floor
      d[below.ceiling, "values"] = input$floor + 0.000001
      d[below.ceiling, "group"] = "Below ceiling"
      
      #fix levels
      d$group = factor(d$group, levels = c("Within limits", "Above ceiling", "Below ceiling") )
    })
    
    
    return(d)
  })
  
  output$plot1 <- renderPlot({
    #data
    d = reac_data()
    
    #summary
    s = describeBy(d$values, d$ind)
    A_sample_mean = s$A$mean
    A_sample_sd = s$A$sd
    B_sample_mean = s$B$mean
    B_sample_sd = s$B$sd
    sample_sd = mean(A_sample_sd, B_sample_sd)
    sample_diff = A_sample_mean - B_sample_mean
    sample_d = sample_diff / sample_sd
    
    #text
    t = str_c("Difference between groups ", round(sample_diff, 2))
    
    t_object = grobTree(textGrob(t, x=.5,  y=.33), #text position
                        gp = gpar(fontsize=11)) #text size
    
    ggplot(d, aes(values, group = ind, color = ind)) +
      geom_density() +
      xlab("Test score") + ylab("Density") +
      annotation_custom(t_object) +
      scale_color_manual(name = "Group", values = c("#390ae3", "#e3390a"))
  })
  
})
