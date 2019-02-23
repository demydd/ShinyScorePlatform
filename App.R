if(!require(shinyjs)){
  library(shinyjs)  
}

#install.packages('devtools')
#devtools::install_github('rstudio/shinyapps')

#rm(list =ls())

library(shiny)

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
                                 column(2, textInput(inputId = "currentWD", label = "Current work directory", width = '200%')
                                        ,textInput(inputId = "newWD", label = "New work directory", width = '200%')
                                        , actionButton("defaultWD", "Run default work directory!", width = 200)
                                 )
                                 
                                 
                               ),
                               tabPanel("Summary", verbatimTextOutput("summary")),
                               tabPanel("Table", tableOutput("table"))
                      )
                    )   
                    
                    
                  )
)                  
# Define server logic required to draw a histogram
server <- function(input, output) {
  
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

