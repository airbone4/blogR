

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("常態分配亂數"),
  fluidRow( # 第一行,兩個column各佔3個格子
    column(3, 
           sliderInput("bins",
                       "Number of bins:",
                       min = 1,
                       max = 50,
                       value = 30)
    ),
    column(3, 
           numericInput("num", 
                        "亂數個數", 
                        value = 1000))         
    
  ),
  fluidRow( # 第一行,分配用
    selectInput("distType", "分配",
                c(normal = "rnorm", t = "rt",unif="runif") # 參數名稱,參數標題,選項 
    ),
    conditionalPanel(
      condition = "input.distType == 'rnorm'",
      numericInput("mean","平均", value = 0),
      numericInput("std","標準差", value = 1)
      
    ),
    conditionalPanel(
      condition = "input.distType == 'rt'",
      numericInput("degree","自由度", value = 10),
    ),
    conditionalPanel(
      condition = "input.distType == 'runif'",
      numericInput("min","最小", value = 0),
      numericInput("max","最大", value = 1)
    )
    
    
  ),
  fluidRow(column(12,plotOutput("distPlot")))
)    

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    num<-input$num
    switch(input$distType,
           "rnorm"={x<-rnorm(num,input$mean,input$std)  },
           "rt"={x<-rt(num,input$degree)},
           "runif"={x<-runif(num,input$min,input$max)}
    )

    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
