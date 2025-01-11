# Define the link module
link_UI <- function(id) {
  ns <- NS(id)
}

link_server <- function(id, row, species_data, multimedia, selected_year) {
  moduleServer(id, function(input, output, session) {
    
    observeEvent(row(), {
      selected_row <- row()  # Get the selected row number
      data <- species_data()
      media <- multimedia()
      year <- selected_year()
      
      if (!is.null(selected_row) && length(selected_row) > 0) {
        
        if (nrow(data) == 48461){
          
         data <- data[data$vernacularName %in% c("Red-backed Shrike", "Common Crane"),]
        }
        
        if (!is.null(year)){
          data  <- data[grep(year, data$eventDate),]
        }
        
        id <- data[row(),]$id
        
        # Get the URL for the selected row (assuming 'data' contains a URL column)
        selected_url <- media[media$CoreId == id,]$Identifier
        if (length(selected_url) == 0){
          showNotification("No multimedia available", type = "message", duration = 2)
        }
        else{
        for (i in length(selected_url)){
          print(selected_url[i])
        
        shinyjs::runjs(sprintf("window.open('%s', '_blank');", selected_url[i]))
        }
        }
          
      }
    })
  })
}



