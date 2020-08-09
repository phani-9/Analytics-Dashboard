library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(tidyverse)
library(reshape2)
library(leaflet)
library(chron)
library(data.table)
library(ggthemes)

shinyServer(function(input,output){
{  
  daywise_restaurant <- reactive({
    filter(performing_rest,Created.Date==as.Date(input$date)) 
  })
  
  daywise_food <- reactive({
    filter(performing_food,Created.Date==as.Date(input$date))
  })
  
  daily_summary <- reactive({
    filter(summary,Created.Date==as.Date(input$date))
  })
  
  daily_orders <- reactive({
    filter(orders,Created.Date==as.Date(input$date))
  })
  
  range_summary <- reactive({
    filter(summary,Created.Date>=as.Date(input$daterange[1]) & 
             Created.Date<=as.Date(input$daterange[2]))
  })
  
  range_orders <- reactive({
    filter(orders,Created.Date>=as.Date(input$daterange[1]) & 
             Created.Date<=as.Date(input$daterange[2]))
  })
  
  restaurant <- reactive({
    filter(performing_rest,`RESTAURANT NAME`==input$rest1 | `RESTAURANT NAME`==input$rest2  &
             (Created.Date>=as.Date(input$rdaterange[1]) & 
             Created.Date<=as.Date(input$rdaterange[2])))
  })
  
  rest_food_date <- reactive({
    filter(rest_food,`RESTAURANT NAME`==input$rest1 | `RESTAURANT NAME`==input$rest2  &
             (Created.Date>=as.Date(input$rdaterange[1]) & 
                Created.Date<=as.Date(input$rdaterange[2])))
  })
  r1 <- reactive({
    filter(orders,`RESTAURANT NAME`==input$rest1 & ((Created.Date>=as.Date(input$rdaterange[1]) & 
                                                       Created.Date<=as.Date(input$rdaterange[2]))))
  })
  
}
  
{  
  output$fleet <- renderValueBox({
    valueBox(daily_summary()$FLEET,"FLEET SIZE",color = 'olive')
  })
  
  output$ordersperagent <- renderValueBox({
    valueBox(daily_summary()$orders_per_agent,"ORDERS PER AGENT",color = 'olive')
  })
  
  output$revenueperagent <- renderValueBox({
    valueBox(daily_summary()$revenue_per_agent,"REVENUE PER AGENT",color = 'olive')
  })
  
  output$users <- renderValueBox({
    valueBox(daily_summary()$Users,"USERS",color = 'olive')
  })
  
  output$surge <- renderPlot({
    ggplot(daily_orders()) + 
      geom_bar(aes(Created.time/3600),fill="darkslategrey",alpha=0.5,bins=24,width = 0.75)+
      scale_x_binned()+ggtitle("ORDERS SURGE")+
      theme(plot.title = element_text(hjust = 0.5,face="bold",size = 24))+
      xlab("TIME")+ylab("ORDERS")
  })
  
  output$toprestaurants <- renderPlot({
    test1 <- daywise_restaurant() %>% arrange(desc(daywise_restaurant()$Amount))
    test2 <- head(test1,5)
    ggplot(test2)+ 
      geom_bar(aes(x=`RESTAURANT NAME`,y=Orders),fill="steelblue",alpha=0.75,stat = "identity",width = .4)+
      ggtitle("Top Restaurants of the day")+ylim(0,100)+
      labs(x='RESTAURANT NAME',y='ORDERS')+
      theme_bw()+theme(plot.title = element_text(hjust = 0.5,face="bold",size=18))
  })
  
  output$topfood <- renderPlot({
    test1  <- daywise_food() %>% arrange(desc(daywise_food()$Orders))
    test2 <- head(test1,5)
    ggplot(test2)+ ylim(0,200)+
      geom_bar(aes(x=`FOOD TYPE`,y=Orders),fill="seagreen",alpha=0.85,stat = "identity",width = .4)+
      ggtitle("Fast moving category")+labs(x='CATEGORY',y='ORDERS')+
      theme_bw()+theme(plot.title = element_text(hjust = 0.5,face="bold",size=18))
    
  })
  
 # output$scatterplot <- renderPlot({
  #  ggplot(daily_orders())+ 
   #   geom_hline(aes(yintercept = mean(daily_orders()$`Delivery. Time`),color=daily_orders()$`FOOD TYPE`)) 
  #})
  
  output$user_trend <- renderPlot({
    
    ggplot(range_summary()) + geom_line(aes(Created.Date,Users))+
      ggtitle("DAILY ACTIVE USERS")+theme(plot.title = element_text(hjust = 0.5,face="bold"))+
      labs(x="DATE",y="USERS")
  })
  
  output$custs <- renderDataTable({
    range_orders() %>% group_by(`Customer ID`,`Customer Name`) %>% 
                summarize(Amount=sum(`TOTAL PRICE`),Frequency = n())
  })
  
  output$ordercomp <- renderPlot({
    
    ggplot(restaurant()) + 
      geom_line(aes(x=Created.Date,y=Orders,color=`RESTAURANT NAME`),size=1.2)+
      ggtitle("ORDERS TREND")+theme(plot.title = element_text(hjust = 0.5,face="bold",size = 20))+
      scale_color_manual("",values=c("olivedrab4","lightseagreen"))
  })
  
  output$foodcomp <- renderPlot({
    ggplot(rest_food_date()) +
      geom_bar(aes(x=`FOOD TYPE`,y=Orders,fill=`RESTAURANT NAME`),
               stat = "identity",position = "dodge",width = .6)+
      ggtitle("RESTAURANT-SPECIALS")+scale_fill_manual("",values=c("olivedrab4","lightseagreen"))+
      theme(plot.title = element_text(hjust = 0.5,face="bold",size = 20))
  })
  
  output$time1 <- renderValueBox({
    valueBoxOutput(mean(r1()$`Acceptance time`),"RESPONSE(mins)")
  })
  
  
}  
})