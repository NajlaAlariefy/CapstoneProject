library(shiny)
library(httr)
library(caret)
#library(swirl)
library(RSQLite)
library(stringr)
library(tm)
library(dplyr)
library("wordcloud")
library("RColorBrewer")
source("predict.R")

shinyServer(function(input, output,session) {
       
            db <- dbConnect(SQLite(), dbname="AllGrams")        
        output$prediction <- renderUI({   actionLink("action1", width=150, label =  nextWord(input$sentence,db)[1] )  })
        output$prediction2 <- renderUI({  actionLink("action2", width=150,label =   nextWord(input$sentence,db)[2])  })
        output$prediction3 <- renderUI({  actionLink("action3", width=150,label =   nextWord(input$sentence,db)[3])  })
        
        observeEvent(input$action1,{  
                text <- input$sentence
                word <- nextWord(input$sentence,db)[[1]]
                updateTextInput(session,  "sentence",
                                label = "", value = paste(text, word)  )
        })
        observeEvent(input$action2,{  
                text <- input$sentence
                word <- nextWord(input$sentence,db)[[2]]
                updateTextInput(session,  "sentence",
                                label = "", value = paste(text, word)  )
        })
        observeEvent(input$action3,{  
                text <- input$sentence
                word <- nextWord(input$sentence,db)[[3]]
                updateTextInput(session,  "sentence",
                                label = "", value = paste(text, word)  )
        })
        
        
        
        output$cloud <-  renderPlot({input$wc
                                     isolate(wordCloud(input$word,input$n,db))})
        
        
        
        #  output$p <- renderUI({  actionButton("action", label = nextWord(input$sentence)[[1]])  })
        
        #renderText({   nextWord(input$sentence)[[3]] })
        
        
  
      
       })
        
 