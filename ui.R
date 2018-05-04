# More info:
#   https://github.com/jcheng5/googleCharts
# Install:
# devtools::install_github("jcheng5/googleCharts")
library(leaflet)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
start_date <- min(gl_w_duration$start_date) 
end_date <- max(gl_w_duration$start_date) + 30

shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  #googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  # tags$link(
  #   href=paste0("http://fonts.googleapis.com/css?",
  #               "family=Source+Sans+Pro:300,600,300italic"),
  #   rel="stylesheet", type="text/css"),
  # tags$style(type="text/css",
  #            "body {font-family: 'Source Sans Pro'}"
  # ),
  
  h2("American Civil War"),
  
  #========================
  # Put leaflet code here
  
  # googleBubbleChart("chart",
  #                   width="100%", height = "475px",
  #                   # Set the default options for this chart; they can be
  #                   # overridden in server.R on a per-update basis. See
  #                   # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
  #                   # for option documentation.
  #                   options = list(
  #                     fontName = "Source Sans Pro",
  #                     fontSize = 13,
  #                     # Set axis labels and ranges
  #                     hAxis = list(
  #                       title = "Health expenditure, per capita ($USD)",
  #                       viewWindow = xlim
  #                     ),
  #                     vAxis = list(
  #                       title = "Life expectancy (years)",
  #                       viewWindow = ylim
  #                     ),
  #                     # The default padding is a little too spaced out
  #                     chartArea = list(
  #                       top = 50, left = 75,
  #                       height = "75%", width = "75%"
  #                     ),
  #                     # Allow pan/zoom
  #                     explorer = list(),
  #                     # Set bubble visual props
  #                     bubble = list(
  #                       opacity = 0.4, stroke = "none",
  #                       # Hide bubble label
  #                       textStyle = list(
  #                         color = "none"
  #                       )
  #                     ),
  #                     # Set fonts
  #                     titleTextStyle = list(
  #                       fontSize = 16
  #                     ),
  #                     tooltip = list(
  #                       textStyle = list(
  #                         fontSize = 12
  #                       )
  #                     )
  #                   )
  # ),
  fluidRow(
    shiny::column(4, offset = 4,
                  sliderInput("date", "Date",
                              min = start_date, max = end_date,
                              value = start_date, animate = TRUE), 
                  animationOptions(interval = 1, loop = FALSE, playButton = TRUE,
                                   pauseButton = TRUE)
    )
  )
))