library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Long Run"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      actionButton('run', 'Run')
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("result")
    )
  )
)

server <- function(input, output) {
  N <- 10
  
  result_val <- reactiveVal()
  observeEvent(input$run,{
    result_val(NULL)
    withProgress(message = 'Calculation in progress', {
      for(i in 1:N){
        
        # Long Running Task
        Sys.sleep(1)
        
        # Update progress
        incProgress(1/N)
      }
      result_val(quantile(rnorm(1000)))
    })
  })
  output$result <- renderTable({
    result_val()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)