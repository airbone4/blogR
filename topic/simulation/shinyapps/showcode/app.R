

library(shiny)
library(shinyjs)
source("../utils/global.R") # <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="無關">😛</span><!--/html_preserve-->


#ui <- fluidPage(
# htmlOutput("code")
  
#)
ui<-myPage( # <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="用上面代替">😛</span><!--/html_preserve-->
  htmlOutput("code")
)

server <- function(input, output,session) {
  addResourcePath("assets","/var/www/assets/") #<!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="無關本程式">👏</span><!--/html_preserve-->
  output$code<-renderUI({
    str<-readLines("app.R") # <!--html_preserve--><span  data-bs-toggle="tooltip" data-bs-html="true" data-bs-placement="bottom" title="後面兩行是自行寫出PRE CODE">👏</span><!--/html_preserve-->
    #str<-paste("<pre><code class='language-r'>", paste0(str,collapse="\n"),"</pre></code>", sep="\n"  )   
    #HTML(str)
    pre(code(paste0(str,collapse="\n"),class="language-r"))
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
