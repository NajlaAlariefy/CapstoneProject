
library(ggplot2)
require(markdown)

shinyUI(     
        navbarPage("Predicting Your Next Word",
                   tabPanel("Predictions",
                            sidebarLayout(
                                    sidebarPanel( h3("Instructions"), em("This application will help you type faster!"), HTML("<p>Start typing, suggestions will appear next to the text box by probability. The top most will be the most probable suggestion. <b>Click</b> on any of the suggestions and they will be added to your text in an instant.</p>")),
                                    mainPanel( fluidPage(
                                            
                                           
                                            fluidRow(
                                                    column(8, 
                                                           HTML(' <textarea id="sentence" rows="5" cols="50" style="   border:1px solid #c7c3b2; -webkit-border-radius: 5px;  -moz-border-radius: 5px;  border-radius: 5px;"></textarea>')
                                                           
                                                    ),
                                                    column(2
                                                          
                                                           ,fluidRow(  uiOutput("prediction")   ),
                                                           fluidRow(   uiOutput("prediction2")  ),
                                                           fluidRow( uiOutput("prediction3")  )
                                                     
                                                    )  
                                            )
                                    ) 
                                               
                                             
                            )),
                            fluidPage(
                                   
                                    fluidRow( column(12, hr())),
                                    fluidRow(
                                            column(8,   plotOutput("cloud")),
                                            sidebarPanel( h3("For Fun!"),
                                                          p("Because who doesn't love them? Explore word clouds of bigrams, just insert a word below, and get the most likely next words in a cloud!
"),                                                        sliderInput("n", "Maximum number of words:", min=0, max=500, value = 250),

                                                          textInput("word", "", width= 200)),
                                            actionButton("wc", "Generate!", width=150  )
                                            )
                            ) 
                            
                            
                   ),
                   tabPanel("Exploratory Report",     
                            mainPanel(
                                    includeHTML("Capstone_Project.html")
                            )
                            
                   ) 
                   
                   
                   
        )
        )


