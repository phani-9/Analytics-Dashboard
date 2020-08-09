library(DT)
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
library(shinythemes)
library(shinyWidgets)

shinyUI(
  dashboardPage(skin = 'black',
    dashboardHeader(title = "FOOD DELIVERY"),
      dashboardSidebar(setBackgroundColor("black"),
        sidebarMenu(
         menuItem("SYSTEM",tabName = "system"),
         menuItem("RESTAURANTS",tabName = "restaurants"),
         menuItem("CUSTOMERS",tabName = "customers")
        )
      ),
      dashboardBody(setBackgroundColor("green"),
        tabItems(
          tabItem(tabName = "system",
                  dateInput(
                    inputId = "date",
                    label ="DATE",
                    format = "yyyy-mm-dd"
                  ),
                  fluidRow(
                    valueBoxOutput("fleet",width = 3),
                    valueBoxOutput("ordersperagent",width = 3),
                    valueBoxOutput("revenueperagent",width = 3),
                    valueBoxOutput("users",width = 3)
                  ),
                  fluidRow(
                    box(plotOutput("surge"),width = 12,setBackgroundColor("pink") )
                  ),
                  fluidRow(
                    box(plotOutput("toprestaurants"),solidHeader = T),
                    box(plotOutput("topfood"),solidHeader=T)
                  ),
                  fluidRow(
                   # plotOutput("scatterplot")
                  )
                  
                  ),
          tabItem(tabName="restaurants",
                  fluidRow(
                  selectInput("rest1","Restaurant 1",
                              unique(orders$`RESTAURANT NAME`)),
                  selectInput("rest2","Restaurant 2",
                              unique(orders$`RESTAURANT NAME`)),
                  dateRangeInput(
                    inputId = "rdaterange",
                    label ="Select the period",
                    start=min(orders$Created.Date),
                    end=max(orders$Created.Date),
                    format = "yyyy-mm-dd",
                    separator = "-"
                  ),
                  fluidRow(
                    box(plotOutput("ordercomp"),width=12),
                    box(plotOutput("foodcomp"),width=12)
                  ),
                  fluidRow(
                    valueBoxOutput("rev1"),
                    valueBoxOutput("time1",width=3),
                    valueBoxOutput("rev2",width=3),
                    valueBoxOutput("time2",width=3)
                    
                  )
                  )
                  ),
          tabItem(tabName = "customers",
                  dateRangeInput(
                    inputId = "daterange",
                    label ="Select the period",
                    start=min(orders$Created.Date),
                    end=max(orders$Created.Date),
                    format = "yyyy-mm-dd",
                    separator = "-"
                  ),
                  fluidRow(
                    box(plotOutput("user_trend"),solidHeader = T),
                    box(dataTableOutput("custs"),solidHeader = T,title = "CUSTOMER FREQUENCY")
                  )
                  )
        )
      ),
  ))