# Define the species search module
species_search_UI <- function(id) {
  ns <- NS(id)
  tagList(
    selectizeInput(inputId = ns("species_search"), 
                   label = "Search Species:",
                   choices = NULL, 
                   options = list(placeholder = "Type to search...")),
    h5("Instructions:"),
    p("Type a species vernacular or scientific name to display its observations on the map and timeline.")
  )
}


species_search_server <- function(id, species_data) {
  moduleServer(id, function(input, output, session) {
    
    # Reactive to store dropdown choices
    dropdown_choices <- reactive({
      data <- species_data()
      unique(c(data$vernacularName, data$scientificName))
    })
    
    # Update choices for selectizeInput
    observe({
      data <- species_data()
      updateSelectizeInput(
        session, "species_search", 
        choices =  dropdown_choices(), 
        selected = "",
        server = TRUE
      )
    
      # Expose choices for testing
      output$choices <- renderText({ dropdown_choices()})

      })
    
    reactive({
      if (is.null(input$species_search)){
        species_data()
      }
      else{
      
      species_data() %>%
        filter(
          grepl(input$species_search, vernacularName, ignore.case = TRUE) |
            grepl(input$species_search, scientificName, ignore.case = TRUE)
        )
      } #close else
      
      
    })
  })
}



