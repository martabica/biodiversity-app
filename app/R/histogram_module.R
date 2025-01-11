# Define the timeline module
histogram_UI <- function(id) {
  ns <- NS(id)
  plotlyOutput(ns("histogram"), height = "200px")
}

histogram_server <- function(id, species_data) {
  moduleServer(id, function(input, output, session) {
  
    output$histogram <- renderPlotly({
      
      data <- species_data()
      if (nrow(data) == 48461){
        data <- data[data$vernacularName %in% c("Red-backed Shrike", "Common Crane"),]
      }
      
      data$eventDate <-  as.Date(data$eventDate)
      data$year <- format(data$eventDate, "%Y")
      data$year <- as.factor(data$year)
      
      p <- ggplot(data, aes(x=year)) + 
        geom_histogram(stat = "count",color = "#000000", fill = "#0099F8") + 
        theme(axis.title.x=element_blank(), 
              axis.text.x=element_blank(),
              axis.ticks.x=element_blank(),
              axis.title.y=element_blank(),
              axis.text.y=element_blank(),
              axis.ticks.y=element_blank()) 
      
      ggplotly(p) %>%
        layout(
          plot_bgcolor = 'white',  # Set background color to white
          paper_bgcolor = 'white' # Set the area around the plot to white
        ) %>%
        config(displayModeBar = FALSE) # Hide the modebar completely
    
      })    
  }) #close moduleServer
} #close server    










