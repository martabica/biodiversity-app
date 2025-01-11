# Define the timeline module
timeline_UI <- function(id) {
  ns <- NS(id)
  plotlyOutput(ns("timeline"), height = "150px")
}


timeline_server <- function(id, species_data) {
  moduleServer(id, function(input, output, session) {
    
    selected_year <- reactiveVal(NULL)
    
    output$timeline <- renderPlotly({
      selected_year(NULL)  
    data <- species_data()
    if (nrow(data) == 48461){
      data <- data[data$vernacularName %in% c("Red-backed Shrike", "Common Crane"),]
    }
    data$eventDate <-  as.Date(data$eventDate)
    data$year <- as.numeric(format(data$eventDate, "%Y"))
    

 df <- data.frame(year = unique(data$year))

 df$y_value <- rep(0.5, nrow(df))

 df <- df[order(df$year),]

 
 df$text_position <- rep(c('bottom center', 'top center'), ceiling(nrow(df)/2))[1:nrow(df)]
 
 
# Create the timeline
 plot_ly(df, x = ~year, y = ~y_value, type = 'scatter', mode = 'markers+text',
        text = ~year, 
        hoverinfo = 'none',
        textposition = ~text_position, 
        marker = list(size = 20, color = 'black', 
                      symbol = 'circle', line = list(color = 'darkgrey', width = 3))) %>%
  layout(
    title = '',
    xaxis = list(title = '', showgrid = FALSE,
                 zeroline = FALSE, showticklabels = FALSE, tickformat = "%Y"),
    yaxis = list(title ="",showgrid = FALSE, zeroline = FALSE, 
                 showticklabels = FALSE, range = c(0, 1)),
    showlegend = FALSE,
    plot_bgcolor = 'white', # Remove background
    paper_bgcolor = 'white', # Remove paper background
    shapes = list(
      list(
        type = 'line',
        x0 = min(data$year),
        x1 = max(data$year),
        y0 = 0.5,
        y1 = 0.5,
        line = list(color = 'black', width = 2)
      )
    )
  )  %>%
   config(displayModeBar = FALSE) # Hide the modebar completely
            

    })
    
    
    # Capture the click event and store the selected year
    observeEvent(event_data("plotly_click"), {
      click_data <- event_data("plotly_click")
      clicked_year <- click_data$x 
      
      # Update the selected year
      selected_year(clicked_year)

      })
    return(selected_year)
  }) #close moduleServer
} #close server















