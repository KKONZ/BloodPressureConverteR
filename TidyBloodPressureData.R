
x <- read.csv("BP20160227.csv", header = T)
x <- x[which(x$Measurement == "Blood Pressure"), ]

x$Month <- ifelse(substring(x$Date, 2 ,4)== "Feb", "02", substring(x$Date, 2 ,4))
x$Day <- substring(x$Date, 6,7)


x$TimeOfDay <- substring(x$Date, 23, 25)
x$TimeOfDay <- ifelse(x$TimeOfDay == "AM ", "AM",
                      ifelse(x$TimeOfDay == " AM", "AM",
                             ifelse(x$TimeOfDay == "PM ", "PM", "PM")))
x$Hour <- ifelse(substring(x$Date, 18, 19) == "10", "10", 
                ifelse(substring(x$Date, 18, 19) == "11", "11",
                                 ifelse(substring(x$Date, 18, 19) == "12", "12", 
                                                  substring(x$Date, 18, 18))))
x$Hour <- as.numeric(x$Hour)
x$Hour <- ifelse(x$TimeOfDay == "PM", x$Hour + 12, x$Hour)

x$Minute <- substring(x$Date, 18)
x$Minute <- ifelse(substring(x$Minute,2,2)==":", substring(x$Minute, 3, 4), substring(x$Minute, 4 ,5))


x$DateTime <- paste("2016/", x$Month, "/", x$Day, " ", x$Hour, ":", x$Minute, ":00", sep="")


x$DateTime <- strptime(x$DateTime,"%Y/%m/%d %H:%M:%S") 
  
  
x$Sys <- as.numeric(substring(x$Data, 2, 4))
x$Dia <-as.numeric(substring(x$Data, 8, 9))
meanSys <- mean(x$Sys)

head(x)
p <- ggplot(x) 
p <- p + geom_point(aes(DateTime, Sys), colour = "Blue", size = 2) 
p <- p +geom_point(aes(DateTime, Dia), colour = "Green", size = 2)
p <- p + theme_minimal() # +coord_cartesian(ylim = c(150, 50))
p <- p + geom_hline(aes(yintercept=meanSys, colour = "Orange"))
p
