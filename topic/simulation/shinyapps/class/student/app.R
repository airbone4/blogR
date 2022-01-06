#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(mongolite)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("beta"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textOutput("userinfo")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

library(mongolite)
mongouri = 'mongodb://mongo4/test?retryWrites=true&w=majority'
prjTable = mongo(collection="projects", db="test", url=mongouri)
#projects = prjTable$find()

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  output$userinfo <- renderText({
    query <- parseQueryString(session$clientData$url_search)
    #query$user # 例如 ?user=xx@xx.com會傳回xx@xx.com
    # http://localhost:3838/class/student/?student=xx.com&score=5
    # student=xx.com, score=5
    paste(names(query), query, sep = "=", collapse=", ") #👍
  })
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    #x    <- query$score
	  
    projects<-prjTable$find()
    # draw the histogram with the specified number of bins
    hist(projects$score, breaks = 10, col = 'darkgray', border = 'white')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
