#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(mongolite)
not_sel <- "Not Selected"
# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("管理工具"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
      
        sidebarPanel(
          actionButton("btnRefresh","更新分數表"),
          fileInput("csv_input", "選擇CSV", accept = ".csv"),
          selectInput("emailCol", "email欄位", choices = c(not_sel)),
          actionButton("btnLoadEmail","載入email"),
          actionButton("btnRandom", "Run Analysis", icon = icon("play"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel("Inicio",
                    h3("Consulta de datos"),
                    p(HTML("Some info.")),
                    dataTableOutput("tblProjects")
                    ),
            # tabPanel("Ayuda", htmlOutput("ayuda"),id="ayuda"),
            # tabPanel('Tabla de datos', dataTableOutput("table1")),      
            # tabPanel('Medias', tableOutput("table2"))
          )           
        )
    )
)

mongouri = 'mongodb://mongo4/test?retryWrites=true&w=majority'
prjTable = mongo(collection="projects", db="test", url=mongouri)
projects = prjTable$find()

# Define server logic required to draw a histogram
server <- function(input, output) {
  if(!is.null(projects))
    output$tblProjects<- renderDataTable(projects)
  data_input <- reactive({
    req(input$csv_input)
    fread(input$csv_input$datapath)
  })
  # eventReactive
  observeEvent(input$btnRefresh,{
    output$tblProjects<- renderDataTable(prjTable$find())
  })
  observeEvent(input$btnLoadEmail,{
    list<-data_input()[[input$emailCol]]
    df<-data.frame(email=list,score=runif(length(list))*100)
    #str<-paste0('{email: "',list,'"}')
    #table<-testdb("projects")
    prjTable$insert(df)
     
    #projects.insertOne({email: "John", score1: 80, score2: 75})
  })
  #csv 資料載入後,把欄位輸出到欄位選擇,以便選擇email欄位
  observeEvent(data_input(),{
    choices <- c(not_sel,names(data_input()))
    updateSelectInput(inputId = "emailCol", choices = choices)
    #updateSelectInput(inputId = "num_var_2", choices = choices)
    #updateSelectInput(inputId = "fact_var", choices = choices)
  })


}

# Run the application 
shinyApp(ui = ui, server = server)
