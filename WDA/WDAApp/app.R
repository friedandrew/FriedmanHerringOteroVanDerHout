#### Load packages ----
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

#TO DO 
##Tabs 
  #introduction to the app with maps and images, data sources
  #WA tab
  #phys tab
  #bio tab
  #AIC variables data table tab 
  #credits tab class name, student names, shoutout to CDVS Drew and John 
##rename x and y axis based on selected dropdown in ggplot with dynamic labels (paste(input$yaxis,collapse = " ") )

#### Load data ----
dam_analysis <- read.csv("Data/dam_data_clean.csv")
AICResults <- read.csv("Data/AICresults.csv")
                      

#### Define UI ----
ui <- fluidPage(theme = shinytheme("superhero"),
                titlePanel("Effects of Dams on Stream Physical Habitat, Water Quality, & Biology in Washington State BLM Lands"),
                sidebarLayout( 
                  mainPanel(
                    h6("This project was completed for Water Data Analytics in Spring 2022 at Duke University's Nicholas School of the Environment", align = "center"),
                    h6("Open access data utilized from the Washington State Department of Ecology and the Bureau of Land Managment", align = "center"),
                    #imageOutput("preImage"),
                    plotlyOutput("scatterplotWQ"),
                    plotlyOutput("scatterplotBio"),
                    plotlyOutput("scatterplotPhys"),
                    h6("Analysis and design by Jackie Van Der Hout, Catherine Otero, and Andrew Friedman-Herring", align = "center"),
                    h6("Thank you to Kateri Salk-Gunderson, John Fay, John Little, Drew Keener, and Nicholas Bruns for your guidance in all things R", align = "center"),
                  ),
                  sidebarPanel(
                    
                    # Select WQ parameters to plot (updated) 
                    
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
                                choices = c("Vegetation Complexity" = "VEG_CMPLXTY","Riparian Canopy Cover" ="RPRN_VEG_CNPY_CVR", "Riparian Understory Cover" = "RPRN_VEG_UNDRSTRY_CVR","Riparian Groundcover" = "RPRN_VEG_GC","Non-Native Woody" = "NON_NTVE_WDY","Native Woody" = "NTVE_WDY","Native Herbacious" = "NTVE_HRB","Percent Sedges and Rushes" = "SDGE_RSH","Observed Invertibrate Richness" = "OBSVRD_INVRT_RCHNSS"), 
                                selected = "Vegetation Complexity")
                    
                    
                    ##could add a feature to change color of a selected site for an interested user 
                    ##do later if this thing actually works 
                    
                    # Output
                   )))   

#### Define server  ----
server <- function(input, output){

  #output$preImage <- renderImage({
    #flowlines <-  img(src="www/AIMflowlines_yes.png", align = "right")
  #}) 
  
  # Create a ggplot object for the type of plot you have defined in the UI  
  output$scatterplotWQ <- renderPlotly({
    ggplotly(ggplot(data = dam_analysis, 
                    aes_string(x = input$x, y = input$y1, color = "OBJECTID")) + #can add fill and shape by site id
               geom_point(alpha = 0.6, size = 4) +
               theme_light(base_size = 14) +
               theme(legend.position = "none")+
               geom_smooth(method = "lm")+
               #scale_shape_manual(values = c(21, 24)) +
               labs(title = "Water Quality and Dams", x = "Selected Dam Variable", y = "Selected Water Quality Variable", color = "Sample Site") + #can you customize WQ parameter name? 
               scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1))
  })
  
  output$scatterplotBio <- renderPlotly({
  ggplotly(ggplot(data = dam_analysis, 
                  aes_string(x = input$x, y = input$y2, color = "OBJECTID")) + 
             geom_point(alpha = 0.6, size = 4) +
             theme_light(base_size = 14) +
             theme(legend.position = "none")+
             geom_smooth(method = "lm")+
             labs(title = "Biological Variables and Dams", x = "Selected Dam Variable", y = "Selected Biological Variable", color = "Sample Site") + 
             scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1))
  })
  
  output$scatterplotPhys <- renderPlotly({
    ggplotly(ggplot(data = dam_analysis, 
                    aes_string(x = input$x, y = input$y3, color = "OBJECTID")) + #update shape with column name
               geom_point(alpha = 0.6, size = 4) +
               theme_light(base_size = 14) +
               theme(legend.position = "none")+
               geom_smooth(method = "lm")+
               labs(title = "Physical Habitat and Dams",x = "Selected Dam Variable", y = "Selected Physical Habitat Variable", color = "Sample Site") + 
               scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1))
  })
  
} 


#### Create the Shiny app object ----
shinyApp(ui = ui, server = server)

#img(src= 'Data/AIMflowlines_yes.png', align = "left"), 
#img(src= 'Data/dams_catchments_aim_yes.png', align = "left"), 
#img(src= 'Data/wa_damz_yes.png', align = "left")
#tableOutput("mytable")
