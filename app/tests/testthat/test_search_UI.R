library(testthat)
library(shiny)

test_that("species_search_UI contains the correct selectizeInput", {
  ui <- species_search_UI("test")
  
  # Convert the UI object to character for debugging
  ui_as_char <- as.character(ui)
  
  # Check for the select element with the correct ID
  expect_true(any(grepl('<select.*id="test-species_search"', ui_as_char))) 
  
  # Check for all namespaced IDs
  expect_true(any(grepl('id="test-species_search"', ui_as_char)))
  expect_true(any(grepl('id="test-species_search-label"', ui_as_char)))
  
  # Check for the presence of instructions
  expect_true(any(grepl('<h5>Instructions:</h5>', ui_as_char)))
  expect_true(any(grepl('Type a species vernacular or scientific name to display its observations on the map and timeline.', ui_as_char)))
 
  # Test Modular Reusability
  ui1 <- species_search_UI("namespace1")
  ui2 <- species_search_UI("namespace2")
  
  # Check for namespaced IDs in both instances
  expect_true(any(grepl('id="namespace1-species_search"', as.character(ui1))))
  expect_true(any(grepl('id="namespace2-species_search"', as.character(ui2))))
  
})

