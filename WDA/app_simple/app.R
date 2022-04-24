#### Load packages ----
library(shiny)
library(shinythemes)
library(tidyverse)
#library(sf)
#library(nhdplusTools)
#library(mapview)

#questions:
# one plot for all AIM Sites or multiple graphs selectable for each?
# can dam type be included as a bar plot? or data shape mismatch?
# what variables make sense as the two checkbox options below? 


#### Load data ----
PracticeFile <- read.csv("../FriedmanHerringOteroVanDerHout/WDA/app_simple/data/PrF_Ratio.csv") 

#### Define UI ----
ui <- fluidPage(theme = shinytheme("superhero"),
  titlePanel("Effects of Dams on Stream Physical Habitat, Water Quality, & Biology in Washington State BLM Lands"),
  sidebarLayout(
    sidebarPanel(
      
      # Select WQ parameters to plot (updated) 
      selectInput(inputId = "y", 
                  label = "Water Quality",
                  choices = c("TotalN", "TotalP", "SpC", "pH", "INSTNT_TEMP"), 
                  selected = "INSTNT_TEMP"),
      
      #Select dam variables on x axis - does this have to be done by site to work?? or will all sites together still generate a useful plot?
      selectInput(inputId = "x",
                  label = "Dam Variables",
                  choices = c("Dams per Square Mile", "Upstream Dam Count"), #update with real names 
                  selected = "Upstream Dam Count"),
      
      # D50
      checkboxGroupInput(inputId = "fill",
                         label = "D50",
                         choices = unique(PracticeFile$D50),
                         selected = c(26)), #this is a guess
      
      # Bankfull Channel Ratio - not sure if necessary or just indicate in ggplot 
      checkboxGroupInput(inputId = "shape",
                         label = "Bankfull Channel Width / Depth Ratio",
                         choices = unique(PracticeFile$WDRatio),
                         selected = c(2, 16)), #this is also a guess, I wonder if too many variables for shape options?


    # Output
    mainPanel(
      plotOutput("scatterplot", brush = brushOpts(id = "scatterplot_brush")), 
      tableOutput("mytable")
    )))) #added an extra ) here not sure if this is the right place

#### Define server  ----
server <- function(input, output) {
  
    # Define reactive formatting for filtering within columns
    #not sure what is happening here tbh, from old code 
    #update to define y here as well? 
    filtered_PracticeFile <- reactive({
       PracticeFile %>%
         filter(DamVariables %in% input$x) %>% #update with column name
         filter() #unsure how to filter for WQ parameteres in multiple columns? 
         filter(D50 %in% input$fill) %>%
         filter(WDRatio %in% input$shape) 
     })
    
    # Create a ggplot object for the type of plot you have defined in the UI  
       output$scatterplot <- renderPlot({
        ggplot(PracticeFile(), 
               aes_string(x = input$x, y = input$y,  
                          fill = "depth_id", shape = "site_id")) + #update shape with column name
          geom_point(alpha = 0.6, size = 4) +
          theme_light(base_size = 14) +
          scale_shape_manual(values = c(21, 24)) +
          labs(x = "Upstream Dam Count", y = expression(Concentration ~ (mu*g / L)), shape = "Bankfull Chanell Ratio", fill = "D50") + #can you customize WQ parameter name? 
          scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1)
          #scale_fill_viridis_c(option = "viridis", begin = 0, end = 0.8, direction = -1)
      })
       
    ## we can create multiple output files using render plot
       #put the code within the {}
    # Create a table that generates data for each point selected on the graph  
       #would be cool if this table showed summaries of dam stats for each AIM site 
       #what is the difference between reactive and render?  
       output$mytable <- renderTable({
         brush_out <- brushedPoints(PracticeFile(), input$scatterplot_brush)
       })
       
  }


#### Create the Shiny app object ----
shinyApp(ui = ui, server = server)

#share by visiting shinyapp.io and saving the ui an server as seperate files 
#you need to use shinyapps package from github

#### Questions for coding challenge ----
#1. Play with changing the options on the sidebar. 
    # Choose a shinytheme that you like. The default here is "yeti"
    # How do you change the default settings? 
    # How does each type of widget differ in its code and how it references the dataframe?
#2. How is the mainPanel component of the UI structured? 
    # How does the output appear based on this code?
#3. Explore the reactive formatting within the server.
    # Which variables need to have reactive formatting? 
    # How does this relate to selecting rows vs. columns from the original data frame?
#4. Analyze the similarities and differences between ggplot code for a rendered vs. static plot.
    # Why are the aesthetics for x, y, fill, and shape formatted the way they are?
    # Note: the data frame has a "()" after it. This is necessary for reactive formatting.
    # Adjust the aesthetics, playing with different shapes, colors, fills, sizes, transparencies, etc.
#5. Analyze the code used for the renderTable function. 
    # Notice where each bit of code comes from in the UI and server. 
    # Note: renderTable doesn't work well with dates. "sampledate" appears as # of days since 1970.
