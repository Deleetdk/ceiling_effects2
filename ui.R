
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Ceiling effects and criteria validity"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("celing",
                  "Test ceiling:",
                  min = 0,
                  max = 200,
                  value = 105),
      sliderInput("floor",
                  "Test floor:",
                  min = 0,
                  max = 200,
                  value = 60),
      sliderInput("A_mean",
                  "Mean score of the blue group",
                  min = 50,
                  max = 150,
                  value = 100,
                  step = 1),
      sliderInput("B_mean",
                  "Mean score of the red group",
                  min = 50,
                  max = 150,
                  value = 85,
                  step = 1),
      actionButton("update", "Update!")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      HTML("<p>As we saw in <a HREF='http://emilkirkegaard.dk/understanding_statistics/?app=ceiling_effects'>the first visualization on ceiling/floor effects</a>, the presence of such artifacts may change the mean and SDs in a sample compared to the population. In this visualization, we will see that this can effect the estimates of group differences.</p>",
           "<p>Below we see two distributions, one for the blue group and one for the red group. We can imagine that the blue represents adults and the red group are young children. We see that there are substantial ceiling and floor effects. The test is much too easy for the blue group and their scores pile up near the top score, while for some of the members of the red group, the test is too difficult and for others too easy. The actual difference between the groups on this test is 15 points (100-85), but in the sample it is only 11.52. If one is looking to estimate group differences on some trait, one should check for the presenece of ceiling/floor effects.",
      "<p>Try playing around with the sliders on the left to see how things change.</p>"),
      plotOutput("plot1"),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available on <a href='https://github.com/Deleetdk/ceiling_effects2'>Github</a>.")
    )
  )
)
)
