hugocmd <- function(m,arg,autoend=F,end=F){
  if (end){
    cat(paste("{{<",paste0("/",m),">}}",sep=" "))
  }
  else{
  cmdstr = paste("{{<",m,arg, ">}}",sep=" ")
  cat(cmdstr)
  
  if (autoend){
       cat(paste("{{<",paste0("/",m),">}}",sep=" "))
  }
  }
  return (invisible())
}