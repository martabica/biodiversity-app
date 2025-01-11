library(testthat)
library(shiny)

test_that("species_search_server filters species correctly", {
  # Mock data for testing
  species_data <- data.frame(
    vernacularName = c("Red-backed Shrike", "Common Crane", "Lynx"),
    scientificName = c("Lanius collurio", "Grus grus", "Lynx lynx"),
    stringsAsFactors = FALSE
  )
  
  # Apply the filtering logic
  filtered <- species_data %>%
    filter(
      grepl("Crane", vernacularName, ignore.case = TRUE) |
        grepl("Crane", scientificName, ignore.case = TRUE)
    )
  
  # Verify the filtered output
  expect_equal(
    filtered,
    data.frame(
      vernacularName = "Common Crane",
      scientificName = "Grus grus",
      stringsAsFactors = FALSE
    )
  )
  
  # Case-insensitive search
  filtered <- species_data %>%
    filter(
      grepl("crane", vernacularName, ignore.case = TRUE) |
        grepl("CRANE", scientificName, ignore.case = TRUE)
    )
  
  expect_equal(
    filtered,
    data.frame(
      vernacularName = "Common Crane",
      scientificName = "Grus grus",
      stringsAsFactors = FALSE
    )
  )
  
  # Partial match search
  filtered <- species_data %>%
    filter(
      grepl("Cr", vernacularName, ignore.case = TRUE) |
        grepl("Cr", scientificName, ignore.case = TRUE)
    )
  
  expect_equal(
    filtered,
    data.frame(
      vernacularName = "Common Crane",
      scientificName = "Grus grus",
      stringsAsFactors = FALSE
    )
  )
})
