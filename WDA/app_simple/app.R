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

#one for each WQ, physical, bio 


#___________________________

#For TN as dependent variable, significant variables:
#at 0.05: RPRN_VEG_CNPY_CVR, RPRN_VEG_GC, RPRN_VEG_GC, LWD_FREQ, INCSN_HT, CHN_INCSN, WTTD_WT, Dams_per_sqkm 
#at 0.01: OBSRVD_INVRT_RCHNSS, WDRatio

#For TP as dependent variable, significant variables:
#at 0.05: WDRatio
#at 0.01: ReachLength, INSTNT_TEMP, LWD_FREQ, AMCROINVRTBRTE_CNT
#at 0.001: StreamOrder, BNK_STBLTY, D50

#For Observed Invertebrate Richness as dependent variable, significant variables:
#at 0.05: StreamOrder, RPRN_VEG_CNPY_CVR, RPRN_VEG_UNDRSTRY_CVR, RPRN_VEG_GC, NTVE_HRB, Number_of_dams_upstream.x, D50, Dams_per_sqkm
#at 0.01: LWD_FREQ, BNK_STBLTY, INCSN_HT, CHN_INCSN, WTTD_WT, WDRatio, Catchment_are_sqkm
#at 0.001: Non_NTVE_HRB, TotalN

#For Channel Geometry Ratio dependent variable, significant variables:
#at 0.05: RPRN_VEG_CNPY_CVR, RPRN_VEG_GC, NTVE_HRB, SDGE_RSH, BNK_STBLTY, TotalN, INCSN_HT, CHN_INCSN, WTTD_WT, Number_of_dams_upstream.x, D50, Dams_per_sqkm
#at 0.01: NON_NTVE_HRB, LWD_FREQ, OBSRVD_INVRT_RCHNSS

#For D50 as dependent variable, significant variables:
#at 0.05: StreamOrder, RPRN_VEG_CNPY_CVR, NON_NTVE_HRB, pH, INCSN_HT, OBSRVD_INVRT_RCHNSS, Dams_per_sqkm
#at 0.01: VEG_CMPLXTY, RPRN_VEG_GC, SDGE_RSH, LWD_FREQ, Number_of_dams_upstream.x, TotalN 
#at 0.001: WTTD_WT, WDRatio

#### Load data ----
dam_analysis <- read.csv("../FriedmanHerringOteroVanDerHout/New Data/dam_data_clean.csv")
AICResults <- read.csv("../FriedmanHerringOteroVanDerHout/New Data/AICresults.csv")

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
                         choices = unique(dam_analysis$D50),
                         selected = c(26)), #this is a guess
      
      # Bankfull Channel Ratio - not sure if necessary or just indicate in ggplot 
      checkboxGroupInput(inputId = "shape",
                         label = "Bankfull Channel Width / Depth Ratio",
                         choices = unique(dam_analysis$WDRatio),
                         selected = c(2, 16)), #this is also a guess, I wonder if too many variables for shape options?
      
      # AIC for table -- do I have to do anything to indicate that this is for a separate object? 
      checkboxGroupInput(inputId = "Table",
                         label = "Significant Variables",
                         choices = unique(AICResults$), ###need to fix this to select for the columns instead of rows
                         selected = c(26)), #this is a guess


    # Output
    mainPanel(
      plotOutput("scatterplot", brush = brushOpts(id = "scatterplot_brush")), 
      tableOutput("mytable")
    )))) #added an extra ) here not sure if this is the right place

#### Define server  ----
server <- function(input, output) {
  
  ## we can create multiple output files using render plot
  #put the code within the {}
  
    # Define reactive formatting for filtering within columns
    #not sure what is happening here tbh, from old code 
    #update to define y here as well? 
    filtered_dam_analysis <- reactive({
      dam_analysis %>%
         filter(DamVariables %in% input$x) %>% #update with column name
         filter() #unsure how to filter for WQ parameteres in multiple columns? 
         filter(D50 %in% input$fill) %>%
         filter(WDRatio %in% input$shape) 
     })
    
    # Create a ggplot object for the type of plot you have defined in the UI  
       output$scatterplot <- renderPlot({
        ggplot(dam_analysis(), 
               aes_string(x = input$x, y = input$y,  
                          fill = "depth_id", shape = "site_id")) + #update shape with column name
          geom_point(alpha = 0.6, size = 4) +
          theme_light(base_size = 14) +
          scale_shape_manual(values = c(21, 24)) +
          labs(x = "Upstream Dam Count", y = expression(Concentration ~ (mu*g / L)), shape = "Bankfull Chanell Ratio", fill = "D50") + #can you customize WQ parameter name? 
          scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1)
          #scale_fill_viridis_c(option = "viridis", begin = 0, end = 0.8, direction = -1)
      })
       
    # Create a table that generates data for each point selected on the graph  
       output$mytable <- renderTable({
         brush_out <- brushedPoints(dam_analysis(), input$scatterplot_brush)
       })
       
    #create new data table looking at just relevant variables and use RShiny to viz that on meta level as above!!!
       output$mytable <- renderTable({
         brush_out <- table(AICResults, input$)
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
