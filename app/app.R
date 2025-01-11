# Load required libraries
library(shiny)
library(shinyjs)
library(leaflet)
library(dplyr)
library(ggplot2)
library(plotly)
library(data.table)
library(waiter)

# Define the main UI
ui <- fluidPage(
  useShinyjs(),
  use_waiter(),  
  
  waiter_preloader(
    html = tagList(
      tags$h2("Welcome to Biodiversity in Poland!", style = "color: black;"),  
      img(src = "biodiversity.png", width = "800px", height = "400px")  
    ),
    color = "white"
  ),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  fluidRow(
    column(3, 
           div(class = "species-search", 
               species_search_UI("species_search")
           )
    ),
    column(9, 
           div(class = "timeline-container", 
               timeline_UI("timeline")
           ),
           div(class = "histogram-container",
               histogram_UI("histogram")
           )
    )
  ),
  
  fluidRow(
    column(3, 
           div(class = "observation-table", 
               observation_table_UI("observation_table")
           )
    ),
    column(9, 
           div(class = "map-container", 
               map_UI("map")
           )
    )
  )
)  
  
  
# Define the main server
server <- function(input, output, session) {
  Sys.sleep(2) #allow time to visualize waiter_preloader
  
  # Placeholder for filtered data (reactive)
  species_data <- reactiveVal()
  multimedia <- reactiveVal()
  
  # Default dataset (load observations for Poland)
  observe({
    # Loading filtered dataset for Poland
    species_data(readRDS(paste0(getwd(),"/data/poland_occurence.rds")))
    multimedia(readRDS(paste0(getwd(),"/data/poland_multimedia.rds"))
               ) 
    })
  
  # Search module
  filtered_data <- species_search_server("species_search", species_data)
  
  # Timeline module
  year <- timeline_server("timeline", filtered_data)
  
  # Histogram module
  histogram_server("histogram", filtered_data)
  
  # Map module
  map_server("map",  filtered_data, year)
  
  # Table module
  selected_row <- observation_table_server("observation_table", filtered_data, year)
  
  # Link module 
  selected_url <- link_server("link",  selected_row, filtered_data, multimedia, year)
  
}

# Run the application
shinyApp(ui = ui, server = server)  
  



