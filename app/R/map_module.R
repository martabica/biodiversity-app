# Define the map module
map_UI <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("map"), height = "600px")
}

map_server <- function(id, species_data, selected_year) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  
      output$map <- renderLeaflet({
      data <- species_data()
      year <- selected_year()
      
      
        if (nrow(data) == 48461){
      
        # Calculate top observed species
        top_species <- data %>%
          count(vernacularName, sort = TRUE) %>%
          top_n(2, n) %>%
          pull(vernacularName)
        
        # Filter data for top species
        filtered_data <- data %>%
          filter(vernacularName %in% top_species)
        
        # Generate the map
        leaflet(filtered_data) %>%
          addTiles() %>%
          #addMarkers(~longitudeDecimal, 
          #           ~latitudeDecimal, 
          #           popup = ~paste(vernacularName, 
          #                          "(", scientificName, ") - ", eventDate)) %>%
          addCircleMarkers(
            ~longitudeDecimal, ~latitudeDecimal,
            color = ~ifelse(vernacularName == top_species[1], "blue", "green"),
            popup = ~paste(vernacularName, "(", scientificName, ") - ", eventDate)
          ) %>%
          addLegend(
            "topright",
            colors = c("blue", "green"),
            labels = top_species,
            title = "Top Observed Species"
          )
        } #close if nrow
        else{
          data <- species_data()
          if (!is.null(year)){
             data <- data[grep(year, data$eventDate),]
          }
          
          leaflet(data) %>%
            addTiles() %>%
            
            #addMarkers(~longitudeDecimal, 
            #           ~latitudeDecimal, 
            #           popup = ~paste(vernacularName, 
            #                          "(", scientificName, ") - ", eventDate)) %>%
            addCircleMarkers(~longitudeDecimal, 
                             ~latitudeDecimal,
                             color = "blue",
                             popup = ~paste(vernacularName, "(", scientificName, ") - ", eventDate)
          ) %>%
            
      
            setView(lng = 19.1451, lat = 51.9194, zoom = 6)
        }
      }) #close output    
    #} #close if is null
    
  }) #close module
} #close server  





    
