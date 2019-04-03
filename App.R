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
fileName = "application_train.csv"
#install.packages('devtools')
#devtools::install_github('rstudio/shinyapps')

#rm(list =ls())


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
                                        br(),
                                        column(8,
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
    

    observe({
      pathDR <- input$loadDR
      filename <- input$loadFileName
        
      if (input$loadDR == "" | is.na(input$loadDR)){
        updateTextInput(session, "loadDR", value = pathName)
        pathDR <- pathName
      }
  
      if(input$loadFileName == "" | is.na(input$loadFileName)){
        updateTextInput(session, "loadFileName", value = fileName)
        filename <- fileName
      }
    })
  

    full_path <- paste(pathName, fileName, sep="",collapse="")
  
    df <- fread(full_path, stringsAsFactor=FALSE)[1:10]
    #browser()
    #debugonce(calcDescStat)
    descStat <- calcDescStat(df)
    
    output$loaded_table <- renderRHandsontable({

      if (!is.null(descStat))
        rhandsontable(descStat)
    })

  })

}

# Run the application 
shinyApp(ui = ui, server = server)

