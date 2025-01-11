# Define the table module
observation_table_UI <- function(id) {
  ns <- NS(id)
  DT::dataTableOutput(ns("observation_table"))  
}

observation_table_server <- function(id, species_data, selected_year) {
  moduleServer(id, function(input, output, session) {
    
    output$observation_table <- DT::renderDataTable({
      data <- species_data()
      year <- selected_year()

      if (nrow(data) == 48461){
        data <- data[data$vernacularName %in% c("Red-backed Shrike", "Common Crane"),]
      }
      
      if (!is.null(year)){
        data  <- data[grep(year, data$eventDate),]
      }
      
      data <- data[,c("id","locality", "eventDate")]
      colnames(data) <- c("ID","Locality", "Date of observation")
      data
        # The data to be shown in the table
    }, rownames = FALSE, selection = "single", options = list(pageLength = 7))
    
    # Return the selected row index as a reactive value
  
  reactive({
    input$observation_table_rows_selected
    })
    
})

}




