
# <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="最後一個執行的express其結果會被回傳">👍👏</span><!--/html_preserve-->
library(shiny)
library(shinyjs)

# Define UI for application that draws a histogram
ui <- fluidPage(
  useShinyjs(),
  
  theme = bslib::bs_theme(version = 5),
  suppressDependencies("highlight.js"),
  tags$head(tags$script(src="assets/js/highlight.min.js")),
  tags$link(rel="stylesheet",type="text/css",href="assets/css/theme.css"),
  tags$link(rel="stylesheet",type="text/css",href="assets/css/theme-mine.css"),
  tags$link(rel="stylesheet",type="text/css",href="assets/css/atom-one-dark-reasonable.css"),
  tags$link(rel="stylesheet",type="text/css",href="assets/css/mystyle.css"),
  tags$script(src="assets/js/hugohelper.js"),
    

    # Application title
    
    fluidRow(column(11,titlePanel("測試tags")),
             column(1,actionButton("codeswitch","code"))),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
    
)
 
# Define server logic required to draw a histogram
server <- function(input, output) {
    addResourcePath("assets","../../assets/")
    #shinyjs::runjs('toggleCodePosition();')
    hide("showcase-well")
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    observeEvent(input$codeswitch,{
      toggle(id="showcase-well") # showcase-well
    })
    

    
}

# Run the application 
shinyApp(ui = ui, server = server)
