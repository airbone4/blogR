library(shiny)
library(shinyWidgets)

shinyApp(
  ui = fluidPage(
    numericInput("n", "n", 1),
    plotOutput("plot")
  ),
  server = function(input, output, session) {
    
    counter <- reactiveValues(value = 0)
    
    observe({
      counter$value <- isolate(counter$value) + 1 #必須要有isolate()否則無限觸發
      invalidateLater(1000, session) # 1秒後,自動觸發這個observe函數裡面的方塊,因此會加1
      if (counter$value == 3) {
        sendSweetAlert(
          session = session,
          title = "Success !!",
          text = "Now you can see the plot.",
          type = "success"
        )
      }
    })
    
    output$plot <- renderPlot({
      if (counter$value >= 3) plot(head(cars, input$n))
    })
    
  }
)