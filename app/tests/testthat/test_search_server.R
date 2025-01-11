library(testthat)
library(shiny)

test_that("species_search_server filters species correctly", {
  # Mock data for testing
  mock_data <- reactiveVal(data.frame(
    vernacularName = c("Red-backed Shrike", "Common Crane"),
    scientificName = c("Lanius collurio", "Grus grus"),
    stringsAsFactors = FALSE
  ))
  
  # Test server logic
  testServer(
    species_search_server,
    args = list(species_data = mock_data),
    {
      # Ensure reactivity is processed
      session$flushReact()
      
      # Validate that the input is NULL (no selection)
      expect_null(input$species_search)
      
      # Validate dropdown choices (available options)
      expect_equal(
        output$choices,
        "Red-backed Shrike Common Crane Lanius collurio Grus grus"
      )
    }
  )
})
