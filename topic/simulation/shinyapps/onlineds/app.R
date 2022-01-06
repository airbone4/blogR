library(shiny)
#library(shinythemes)
#library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)

not_sel <- "Not Selected"

about_page <- tabPanel(
  title = "About",
  titlePanel("About"),
  "Created with R Shiny",
  br(),
  "2021 April"
)

main_page <- tabPanel(
  title = "Analysis",
  titlePanel("Analysis"),
  sidebarLayout(
    sidebarPanel(
      title = "Inputs",
      fileInput("csv_input", "Select CSV File to Import", accept = ".csv"),
      selectInput("num_var_1", "Numerical Variable 1", choices = c(not_sel)),
      selectInput("num_var_2", "Numerical Variable 2", choices = c(not_sel)),
      selectInput("fact_var", "Factor Variable", choices = c(not_sel)),
      br(),
      actionButton("run_button", "Run Analysis", icon = icon("play")),
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("資料",fluidRow(column(width=4,textInput("rowfilter","rowfilter")),
                               column(width=4,textInput("colfilter","colselect"))),tableOutput("dfcontent")),
        tabPanel(
          title = "Plot",
          plotOutput("plot_1"),
          
        ),
        tabPanel(
          title = "Statistics",
          fluidRow(
            column(width = 4, strong(textOutput("num_var_1_title"))),
            column(width = 4, strong(textOutput("num_var_2_title"))),
            column(width = 4, strong(textOutput("fact_var_title")))
          ),
          fluidRow(
            column(width = 4, tableOutput("num_var_1_summary_table")),
            column(width = 4, tableOutput("num_var_2_summary_table")),
            column(width = 4, tableOutput("fact_var_summary_table"))
          ),
          fluidRow(
            column(width = 12, strong("Combined Statistics"))
          ),
          fluidRow(
            column(width = 12, tableOutput("combined_summary_table"))
          ),
          
          
        )
      )
    )
  )
)

draw_plot_1 <- function(data_input, num_var_1, num_var_2, fact_var){
 
  if(num_var_1 != not_sel & num_var_2 != not_sel & fact_var != not_sel){
    ggplot(data = data_input,
           aes_string(x = num_var_1, y = num_var_2, color = fact_var)) +
      geom_point(aes(size=1.6))
  }
  
}


ui <- navbarPage(
  title = "Data Analyser",
  #theme = shinytheme('united'),
  main_page,
  about_page
)

server <- function(input, output){
  
  options(shiny.maxRequestSize=10*1024^2) 
  
  data_input <- reactive({
    req(input$csv_input) 
    #ds<-fread(input$csv_input$datapath)
    ds<-read.csv(input$csv_input$datapath)
    output$dfcontent<-renderTable(ds)
    ds
  })
  
  observeEvent(data_input(),{
    choices <- c(not_sel,names(data_input()))
    updateSelectInput(inputId = "num_var_1", choices = choices)
    updateSelectInput(inputId = "num_var_2", choices = choices)
    updateSelectInput(inputId = "fact_var", choices = choices)
    
  })
  
sds<-eventReactive(input$rowfilter,{
  filter(data_input(),eval(parse(input$rowfilter)))
  })
  num_var_1 <- eventReactive(input$run_button,input$num_var_1) # num_var_1 不會立即反應
  num_var_2 <- eventReactive(input$run_button,input$num_var_2)
  fact_var <- eventReactive(input$run_button,input$fact_var)
  
  # plot
  
  plot_1 <- eventReactive(input$run_button,{
    draw_plot_1(data_input(), num_var_1(), num_var_2(), fact_var())
  })
  
  output$plot_1 <- renderPlot(plot_1())
  
  # 1-d summary tables
  
  output$num_var_1_title <- renderText(paste("Num Var 1:",num_var_1()))
  
  num_var_1_summary_table <- eventReactive(input$run_button,{
    create_num_var_table(data_input(), num_var_1())
  })
  
  output$num_var_1_summary_table <- renderTable(num_var_1_summary_table(),colnames = FALSE)
  
  output$num_var_2_title <- renderText(paste("Num Var 2:",num_var_2()))
  
  num_var_2_summary_table <- eventReactive(input$run_button,{
    create_num_var_table(data_input(), num_var_2())
  })
  
  output$num_var_2_summary_table <- renderTable(num_var_2_summary_table(),colnames = FALSE)
  
  output$fact_var_title <- renderText(paste("Factor Var:",fact_var()))
  
  fact_var_summary_table <- eventReactive(input$run_button,{
    create_fact_var_table(data_input(), fact_var())
  })
  
  output$fact_var_summary_table <- renderTable(fact_var_summary_table(),colnames = FALSE)
  
  # multi-d summary table
  
  combined_summary_table <- eventReactive(input$run_button,{
    create_combined_table(data_input(), num_var_1(), num_var_2(), fact_var())
  })
  
  output$combined_summary_table <- renderTable(combined_summary_table())
  
}

shinyApp(ui = ui, server = server)

#runApp("/Users/flatiron/Documents/R_Work/RShiny_Apps/data_analyser", display.mode = "showcase")