#### Load packages ----
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
#library(sf)
#library(nhdplusTools)
#library(mapview)

#### Load data ----
dam_analysis <- read.csv("Data/dam_data_clean.csv")
AICResults <- read.csv("Data/AICresults.csv")

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Effects of Dams on Stream Physical Habitat, Water Quality, & Biology in Washington State BLM Lands"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      selectInput(inputId = "x",
                  label = "Upstream Dam Impact",
                  choices = c("Number of Dams Upstream" = "Number_of_dams_upstream.x","Dams Per Square Km Upstream" = "Dams_per_sqkm"), 
                  selected = "Number of Dams Upstream"),
      
      selectInput(inputId = "y1", 
                  label = "Water Quality",
                  choices = c("Total Nitrogen" = "TotalN","Total Phosphorous" = "TotalP","Specific Conductivity" = "SpC", "pH","Temperature" = "INSTNT_TEMP"), 
                  selected = "Temperature"),
      
      selectInput(inputId = "y2", 
                  label = "Physical Habitat",
                  choices = c("Stream Order" = "StreamOrder","Large Woody Debri Frequency" = "LWD_FREQ", "Large Woody Debri Volume" = "LWDVolume","Bank Stabilty" = "BNK_STBLTY","Incision Height" = "INCSN_HT","Channel Incision" = "CHN_INCSN","Wetted Width" = "WTTD_WD","Bankfull Channel Ratio" = "WDRatio", "D50"), 
                  selected = "Bank Stability"),
      
      selectInput(inputId = "y3", 
                  label = "Biological Assessment",
                  choices = c("Vegetation Complexity" = "VEG_CMPLXTY","Riparian Canopy Cover" ="RPRN_VEG_CNPY_CVR", "Riparian Understory Cover" = "RPRN_VEG_UNDRSTRY_CVR","Riparian Groundcover" = "RPRN_VEG_GC","Non-Native Woody" = "NON_NTVE_WDY","Native Woody" = "NTVE_WDY","Native Herbacious" = "NTVE_HRB","% Sedges and Rushes" = "SDGE_RSH","Observed Invertibrate Richness" = "OBSVRD_INVRT_RCHNSS"), 
                  selected = "Vegetation Complexity"),
      
    ),

    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      shiny::tabsetPanel(type = "tabs",
                    tabPanel("Introduction", verbatimTextOutput("summary")),
                    tabPanel("Water Quality", plotlyOutput("scatterplotWQ")),
                    tabPanel("Biological Variables"), plotlyOutput("scatterplotBio")),
                    tabPanel("Physical Habitat", plotlyOutput("scatterplotPhys")),
                    tabPanel("Significant Variables Summary", verbatimTextOutput("summary")),
                    tabPanel("Credits", verbatimTextOutput("summary"))
                  ),
          )
      
    )


# Define server logic for random distribution app ----
server <- function(input, output) {
 
  #here 
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  output$scatterplotWQ <- renderPlotly({
    ggplotly(ggplot(data = dam_analysis, 
                    aes_string(x = input$x, y = input$y1, color = "OBJECTID")) + #can add fill and shape by site id
               geom_point(alpha = 0.6, size = 4) +
               theme_light(base_size = 14) +
               geom_smooth(method = "lm", SE = TRUE)+
               #scale_shape_manual(values = c(21, 24)) +
               labs(x = "Selected Dam Variable", y = "Selected Water Quality Variable", color = "Sample Site") + #can you customize WQ parameter name? 
               scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1))
  })
  
  output$scatterplotBio <- renderPlotly({
    ggplotly(ggplot(data = dam_analysis, 
                    aes_string(x = input$x, y = input$y2, color = "OBJECTID")) + 
               geom_point(alpha = 0.6, size = 4) +
               theme_light(base_size = 14) +
               geom_smooth(method = "lm", SE = TRUE)+
               #scale_shape_manual(values = c(21, 24)) +
               labs(x = "Selected Dam Variable", y = "Selected Biological Variable", color = "Sample Site") + 
               scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1))
  })
  
  output$scatterplotPhys <- renderPlotly({
    ggplotly(ggplot(data = dam_analysis, 
                    aes_string(x = input$x, y = input$y3, color = "OBJECTID")) + #update shape with column name
               geom_point(alpha = 0.6, size = 4) +
               theme_light(base_size = 14) +
               #scale_shape_manual(values = c(21, 24)) +
               geom_smooth(method = "lm", SE = TRUE)+
               labs(x = "Selected Dam Variable", y = "Selected Physical Habitat Variable", color = "Sample Site") + 
               scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1))
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)
