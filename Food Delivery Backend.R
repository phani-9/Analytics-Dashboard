library(dplyr)
library(tidyr)
library(lubridate)
library(ggplots2)
library(tidyverse)
library(reshape2)
library(leaflet)
library(chron)
library(data.table)
library(readxl)


orders<- read_excel(file.choose())
orders$Created.time <- strftime(orders$Created.time,format = "%H:%M:%S")
orders$Created.time <- as.ITime(orders$Created.time)
 
orders <- orders %>% select(-Issues)

summary <- orders %>% group_by(Created.Date) %>% 
            summarize(Orders =n(),Revenue = sum(Revenue*10),
                      FLEET=length(unique(`Delivery Guy`)),
                      orders_per_agent = round(Orders/FLEET),
                      revenue_per_agent = round(Revenue/FLEET),
                      Users = length(unique(`Customer ID`)) ) 

performing_rest <- orders %>% group_by(Created.Date,`RESTAURANT NAME`) %>%
                        summarize(Orders=n(),Revenue=sum(Revenue),Amount =sum(`ORDER PRICE`))

performing_food <- orders %>% group_by(Created.Date,`FOOD TYPE`) %>%
                      summarize(Orders=n())
rest_food <- orders %>% group_by(Created.Date,`RESTAURANT NAME`,`FOOD TYPE`) %>% 
                          summarize(Orders =n())

drivers <- orders %>% group_by(Created.Date) %>% 
                summarize(FLEET=length(unique(`Delivery Guy`)),
                          orders_per_agent = n()/length(unique(`Delivery Guy`)))
ggplot(t) + geom_bar(aes(Created.time/3600),bins=24)+scale_x_binned()