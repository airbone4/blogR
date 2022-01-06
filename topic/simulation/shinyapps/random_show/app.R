
# <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="最後一個執行的express其結果會被回傳">????</span><!--/html_preserve-->
library(shiny)
library(shinyjs)
source("../utils/global.R",encoding="UTF-8")

commonPanel<-function() {tabPanel("commonPanel",
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
                        
                      ))
}
normPanel<-function(){
  tabPanelBody("rnorm","",  
           numericInput("mean","平均", value = 0),
           numericInput("std","標準差", value = 1))
}
tPanel<-function(){
  tabPanelBody("rt","",
           numericInput("degree","自由度", value = 10)
          )
}

unifPanel<-function(){
  tabPanelBody("runif","",
           numericInput("min","最小", value = 0),
           numericInput("max","最大", value = 1)
           
  )
}


#ui <- fluidPage(
ui <- myPage(
  titlePanel("抽亂數"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("distType", "分布名稱", c("rnorm","rt","runif"), "rnorm"),
      actionButton("draw","抽"),
      width=2
    ),
    mainPanel(
      commonPanel(),
      tabsetPanel(
        id = "dist_tabs",
        # Hide the tab values.
        # Can only switch tabs by using `updateTabsetPanel()`
        type = "hidden",
        normPanel(),
        tPanel(),
        unifPanel()
        
      ),
      
      fluidRow( 
        column(6,plotOutput("histPlot")),
        column(6,plotOutput("qqPlot"))
      ),
      verbatimTextOutput("sum"),       

    ) 
   
  )
)

server <- function(input, output, session) {
  #addResourcePath("assets","/var/assets/")
  
  status<-reactiveValues(draw=F)
  
  data<-reactive({
    status$draw
    switch(input$distType,
           "rnorm"={rnorm(input$num,input$mean,input$std)  },
           "rt"={rt(input$num,input$degree)},
           "runif"={runif(input$num,input$min,input$max)}
    )    
    
  })  
  
  observeEvent(input$distType, {
    updateTabsetPanel(session, "dist_tabs", selected =  input$distType)
  })
  
  
  observeEvent(input$draw,{ 
    status$draw<-!status$draw

  })
  
  output$histPlot <- renderPlot({
    status$draw
    binnum<-input$bins
    isolate(
    hist(data(),breaks=binnum,freq=F,col='darkgray',border='white') 
    )
  })
  output$qqPlot<-renderPlot({
    status$draw
    isolate({
    qqnorm(data())
    qqline(data(), qtype = 7)
    })
  })
  
  output$sum <- renderPrint({
    status$draw
    isolate(
    summary(data())
    )
    })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
