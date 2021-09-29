library(readr)
options(stringsAsFactors = FALSE)
read_csv("example_files/japanese_utf8.csv",
         locale = locale(encoding = "UTF-8"))
read_csv("example_files/japanese_shiftjis.csv",
         locale = locale(encoding = "SHIFT-JIS"))

print.listof(read_csv("example_files/japanese_shiftjis.csv",
                      locale = locale(encoding = "SHIFT-JIS")))

read.csv("example_files/japanese_utf8.csv")

read.csv("example_files/japanese_shiftjis.csv", fileEncoding = "SHIFT-JIS")

read.csv("example_files/japanese_utf8.csv")

read.csv("example_files/japanese_utf8.csv", fileEncoding = "UTF-8")

read.csv("example_files/japanese_utf8.csv", encoding = "UTF-8")

print.listof(read.csv("example_files/japanese_utf8.csv", encoding = "UTF-8"))



setlocale("LC_ALL", "English_United States.932")
read.csv("example_files/japanese_shiftjis.csv")
read.csv("example_files/japanese_utf8.csv", fileEncoding = "UTF-8")

x <- read.csv("example_files/japanese_shiftjis.csv", 
              encoding = "UTF-8", 
              check.names = FALSE # otherwise R will mangle the names
              )
charcols <- !sapply(x, is.numeric)
x[charcols] <- lapply(x[charcols], iconv, from = "SHIFT-JIS", to = "UTF-8")
names(x) <- iconv(names(x), from = "SHIFT-JIS", to = "UTF-8")
print.listof(x)

print.listof(read_csv("example_files/arabic_utf-8.csv"), locale = locale(encoding = "UTF-8"))
print.listof(read_csv("example_files/japanese_utf8.csv"), locale = locale(encoding = "UTF-8"))
print.listof(read_csv("example_files/japanese_utf8.csv"), locale = locale(encoding = "SHIFT-JIS"))
