if(!require(shinyjs)){
  library(shinyjs)  
}
if(!require(rhandsontable)){
  library(rhandsontable)  
}
if(!require(data.table)){
  library(data.table)  
}
if(!require(scoredevr)){
  library(scoredevr)  
}
if(!require(shiny)){
  library(shiny)  
}

pathName = "D:\\Demyd\\Personal\\R\\kaggle\\"
filename = "application_train.csv"
#install.packages('devtools')
#devtools::install_github('rstudio/shinyapps')

#rm(list =ls())



func <- function() {
  "hi there!"
}

# Define UI for application that draws a histogram
ui <- fluidPage(  useShinyjs()
                  , tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});')))
                  , tags$script(HTML('Shiny.addCustomMessageHandler("jsCode",function(message) {eval(message.value);});')),
                  
                  #    Application title
                  titlePanel("ScoreDevPlatform")
                  
                  # Sidebar with a slider input for number of bins 
                  ,mainPanel(
                    tabsetPanel(
                      tabPanel("Settings",
                               fluidRow(
                                 column(2, 
                                         wellPanel(
                                                   textInput(inputId = "currentWD", label = "Current work directory", width = '200%')
                                                  ,textInput(inputId = "newWD", label = "New work directory", width = '200%')
                                                  ,actionButton("defaultWD", "Save default work directory", width = '200px')
                                                  #,textInput(inputId = "saveSettings", label = "File to save settings", width = '200%')
                                         )
                                 )
                                 
                                 
                               )
                              ),
                      
                      tabPanel("Preprocessing", 
                               fluidRow(column(3, 
                                                textInput(inputId = "loadDR", label = "The directory to load data file", width = '800px') 
                                               ,textInput(inputId = "loadFileName", label = "The file to load data file", width = '800px')
                                               ,actionButton("loadDF", "Load data", width = '200px')
                                              ),
                                        column(4,
                                                rHandsontableOutput("loaded_table")
                                               )
                                        
                                       )        
                              ),
                      
                               tabPanel("Table", tableOutput("table"))
                      )
                    )   
                    
                    
                  
)                  
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  

  
  observeEvent(input$loadDF,{
    
    #if(is.null(input$loadDR)) input$loadDR <- getwd()
    print(input$loadDR)
    print(paste(input$loadDR,"\\",input$loadFileName, sep="",collapse=""))
    
    df <- fread(paste(input$loadDR,"\\\\", input$loadFileName, sep="",collapse=""),stringsAsFactor=FALSE)
    print(dim(df))
    
    output$loaded_table <-renderRHandsontable({
      
      rhandsontable(df[1:10, ], selectCallback = TRUE, height = 600) %>%
        hot_table(highlightCol = TRUE, highlightRow = TRUE) %>%
        hot_rows(rowHeights = list(18))
      
    })
    
  })
  #   output$distPlot <- renderPlot({
  # generate bins based on input$bins from ui.R
  #      x    <- faithful[, 2] 
  #      bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
  # draw the histogram with the specified number of bins
  #      hist(x, breaks = bins, col = 'darkgray', border = 'white')
  #   })
}

# Run the application 
shinyApp(ui = ui, server = server)

