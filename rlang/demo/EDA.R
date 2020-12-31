EDA <- function (x)
{ 
  par(mfrow=c(2,2))              
  hist(x)                        
  dotchart(x)                    
  boxplot(x,horizontal=T)        
  qqnorm(x);qqline(x)            
  par(mfrow=c(1,1))              
}