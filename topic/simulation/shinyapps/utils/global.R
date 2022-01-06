
myPage<-function (...,  theme = NULL, lang = NULL) {
  
  bootstrapPage(
    
    suppressDependencies("highlight.js"),
    
    #tags$head(tags$script(src="/assets/js/highlight.min.js")),
    #tags$link(rel="stylesheet",type="text/css",href="/assets/css/theme.css"),
    #tags$link(rel="stylesheet",type="text/css",href="/assets/css/theme-mine.css"),
    #tags$link(rel="stylesheet",type="text/css",href="/assets/css/atom-one-dark-reasonable.css"),
    #tags$link(rel="stylesheet",type="text/css",href="/assets/css/mystyle.css"),
    #tags$script(src="/assets/js/hugohelper.js"),    
    tags$head(tags$script(src="https:/rmilab.nkust.edu.tw/js/highlight.min.js")),
    tags$link(rel="stylesheet",type="text/css",href="https:/rmilab.nkust.edu.tw/css/theme.css"),
    tags$link(rel="stylesheet",type="text/css",href="https:/rmilab.nkust.edu.tw/css/theme-mine.css"),
    tags$link(rel="stylesheet",type="text/css",href="https:/rmilab.nkust.edu.tw/css/atom-one-dark-reasonable.css"),
    tags$link(rel="stylesheet",type="text/css",href="https:/rmilab.nkust.edu.tw/css/mystyle.css"),
    tags$script(src="https:/rmilab.nkust.edu.tw/js/hugohelper.js"),    
    
    div(class = "container-fluid",...),
    tags$button("expand", class="btn btn-primary",`data-bs-toggle`="collapse",`data-bs-target`="#appcode"),
    {    str<-readLines("app.R")
         pre(code(paste0(str,collapse="\n"),class="language-r"),id="appcode",class="collapse")
    },
    theme = bslib::bs_theme(version = 5),
    title = "test"
  )
}
