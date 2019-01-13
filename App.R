library(shiny)
library(shinyjs)
library(shinyBS)

initialValues <- c(25, 25, 25, 25)

# Define UI for application that draws a histogram
ui <- fluidPage(
  useShinyjs(),
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      p(id = "coords", "Click me to see the mouse coordinates"), ## Example of the mouse click feedback
      
      div(style='display: inline-block;',
          "Click here for info",
          img(id = "image", src='https://www.zorro.com/wp-content/uploads/cc_resize/005-1200x542.jpg',height='30px',style='display: inline-block;', click = "image_click")
      ),
      uiOutput("plotClickInfo"),
      numericInput("bins",NULL,min = 1,max = 50,value = 30)
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot", click = "plotclick")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  v <- reactiveValues()
  
  onclick("coords", function(event) { alert(event) })
  
  ## Examples of other events we might use
  #onclick("bins", v$click <- rnorm(1))
  #onevent("hover", "bins", v$click <- rnorm(1))
  #onevent("dblclick", "bins", v$click <- rnorm(1))
  #onevent("mousedown", "bins", v$click <- rnorm(1))
  
  ## The actual event we have used.
  onclick("image", function(event) {v$clickX <- event$pageX
  v$clickY <- event$pageY
  ## Store the initial values of the controls.
  if (!is.null(input$perc1)) {
    initialValues[1] <- input$perc1
  }
  else {
    v$perc1Value <- initialValues[1]
  }
  
  if (!is.null(input$perc2)) {
    initialValues[2] <- input$perc2
  }
  else {
    v$perc2Value <- initialValues[2]
  }
  
  if (!is.null(input$perc3)) {
    initialValues[3] <- input$perc3
  }
  else {
    v$perc3Value <- initialValues[3]
  }
  
  if (!is.null(input$perc4)) {
    initialValues[4] <- input$perc4
  }
  else {
    v$perc4Value <- initialValues[4]
  } 
  })
  
  output$plotClickInfo <- renderUI({
    
    if (!is.null(v$clickX)){
      style <- paste0("position:absolute; z-index:100; background-color: rgba(100, 245, 245, 0.85); max-width: 250px; width: 250px;",
                      "left:", v$clickX + 2, "px; top:", v$clickY - 50, "px;")
      
      # actual tooltip created as wellPanel
      wellPanel(
        style = style,
        p(HTML(paste0("<b> KPI: </b>", "bla", "<br/>",
                      "<b> Information: </b>", "aText"))),
        numericInput("perc1", "Percentage1", v$perc1Value, 0, 100, width="100%"),
        numericInput("perc2", "Percentage2", v$perc2Value, 0, 100, width="100%"),
        numericInput("perc3", "Percentage3", v$perc3Value, 0, 100, width="100%"),
        numericInput("perc4", "Percentage4", v$perc4Value, 0, 100, width="100%"),
        conditionalPanel(style = "color: red;", condition = "(input.perc1 + input.perc2 + input.perc3 +
                         input.perc4 > 100)",
                         "Total of percentages cannot exceed 100%"),
        conditionalPanel(style = "color: red;", condition = "(input.perc1 + input.perc2 + input.perc3 +
                         input.perc4 < 100)",
                         "Total of percentages must add up to 100%"),
        actionButton("myAction", "Go"), actionButton("myCancel", "Cancel")
        )
    }
    else return(NULL)
  })
  
  observeEvent(input$myAction, {
    ## Only disappear this popup
    if (input$perc1 + input$perc2 + input$perc3 + input$perc4 == 100) {
      v$perc1Value <- input$perc1
      v$perc2Value <- input$perc2
      v$perc3Value <- input$perc3
      v$perc4Value <- input$perc4
      v$clickX = NULL
    }
  })
  
  observeEvent(input$myCancel, {
    ## Revert to original values.
    updateNumericInput(session, "perc1", initialValues[1])
    updateNumericInput(session, "perc2", initialValues[2])
    updateNumericInput(session, "perc3", initialValues[3])
    updateNumericInput(session, "perc4", initialValues[4])
    v$clickX = NULL
  })
}

# Run the application 
shinyApp(ui = ui, server = server)