
# <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="最後一個執行的express其結果會被回傳">????</span><!--/html_preserve-->
library(shiny)
library(shinyjs)
source("../utils/global.R",encoding="UTF-8")
 

#ui <- fluidPage(
ui <- myPage(
  titlePanel("reactiveValue"),
  sliderInput("x","x",0,10,3),
  verbatimTextOutput("outx"),
  verbatimTextOutput("outrv"),
  actionButton("go","go")
)

server <- function(input, output, session) {
  
  rv<-reactiveValues(invalid=0)
  observeEvent(input$go,{
    rv$invalid<-input$x
  })
  output$outx<-renderPrint({
    
    print(paste0(input$x,"without go"))
  })
  output$outrv<-renderPrint({
    
    print(paste0(rv$invalid," with go "))
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
