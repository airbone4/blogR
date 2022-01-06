
# <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="最後一個執行的express其結果會被回傳">????</span><!--/html_preserve-->
library(shiny)
library(shinyjs)
source("../utils/global.R",encoding="UTF-8")

commonPanel<-function() {
  p("只有抽這個按鈕敲下時候才要有動作,這個版本不是")
  tabPanel("commonPanel",
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
      actionButton("draw","抽")
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
        column(8,plotOutput("distPlot")),
        column(4,verbatimTextOutput("sum")),       
      )
      
    )
  )
)

server <- function(input, output, session) {
  #addResourcePath("assets","../assets/")
  rv<-reactiveValues()
  rv$invalid<-0
  # 亂數資料,除非reactive 的值,有改變,否則不會重新抽樣(因此直方圖的bin個數不會導致重新抽樣)
  data<-reactive({
    print(rv$invalid)
    switch(input$distType,
           "rnorm"={rnorm(input$num,input$mean,input$std)  },
           "rt"={rt(input$num,input$degree)},
           "runif"={runif(input$num,input$min,input$max)}
    )    
    
  })
  observeEvent(input$distType, {
    updateTabsetPanel(session, "dist_tabs", selected =  input$distType)
  })
  
  ## 利用eventReactive
  #dohist<-eventReactive(input$draw,{
  #  rv$invalid=rv$invalid+1 #強迫產生新資料
  #  hist(data(),breaks=input$bins,freq=F,col='darkgray',border='white')
  #})
  #output$distPlot<-renderPlot(dohist())
  ## 不用eventReactive,和前面的差別是,前者會累積其他控制向的改變,直到按了按鈕
  ## 而後者,除了按鈕以外,其他控制項也會導致改變
  observeEvent(input$draw, {
    rv$invalid=rv$invalid+1 #強迫產生新資料
    output$distPlot <- renderPlot( hist(data(),breaks=input$bins,freq=F,col='darkgray',border='white') )
    output$sum <- renderPrint(summary(data()))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
