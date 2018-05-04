# datamaps package tutorial

library(datamaps)

datamaps(projection = "orthographic") %>%
  add_graticule()

# Add Cloropleth
data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
                   color = round(runif(6, 1, 10)))
data %>%
  datamaps() %>%
  add_choropleth(name, color, colors = c("skyblue", "yellow", "orangered"))

# categorical colors
cat <- data.frame(name = c("USA", "BRA", "COL", "CAN", "ARG", "CHL"),
                  col = rep(c("Yes", "No"), 6))
cat %>%
  datamaps(projection = "orthographic") %>%
  add_choropleth(name, col, colors = c("red", "blue"))

# # US states
states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
                     val = c(10, 5, 3, 8, 6, 7, 2))

states %>%
  datamaps(scope = "usa", default = "lightgray") %>%
  add_choropleth(st, val) %>%
  add_labels()

#=================================
# Add Data
# Using add_data() allows you to bring in new data as needed.
# Cities with long & lat and size
# The cities will be represented by bubbles
coords <- data.frame(city = c("London", "New York", "Beijing", "Sydney"),
                     lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
                     lat = c(51.49999, 40.74998, 39.92889, -33.92001),
                     values = c(11, 23, 29 , 42))

# The country names are constants but I don't see documentation
# on what abreviations are available. 
data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA",
                            "BRA", "AFG"),
                   color = round(runif(8, 1, 10)))

# Set the start and finish points of an arc by name
edges <- data.frame(origin = c("USA", "FRA", "BGD", "ETH", "KHM", "GRD",
                               "FJI", "GNB", "AUT", "YEM"),
                    target = c("BRA", "USA", "URY", "ZAF", "SAU", "SVK", "RWA", "SWE",
                               "TUV", "ZWE"),
                    strokeColor = rep(c("gray", "black"), 5))

data %>%
  datamaps(default = "lightgray") %>%
  add_choropleth(name, color) %>%
  add_data(coords) %>%
  add_bubbles(lon, lat, values, values, city, colors = c("skyblue", "darkblue")) %>%
  add_data(edges) %>%
  add_arcs_name(origin, target, strokeColor)

#
#===========================================

#==========================================
# Add Labels
# I like the fact that is you specify the scope as "usa" 
# it automatically knows to label the states

# Set target states and colors
states <- data.frame(st = c("AR", "NY", "CA", "IL", "CO", "MT", "TX"),
                     val = c(10, 5, 3, 8, 6, 7, 2))
states %>%
  datamaps("usa") %>%
  add_choropleth(st, val) %>%
  add_labels(label.color = "blue")

#
#====================================

#====================================
# Add a legend

# Set name/value pairs
data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
                   values = c("N. America", "EU", "Asia", "EU", "Africa", "Africa"))
data %>%
  datamaps() %>%
  add_choropleth(name, values, colors = c("skyblue", "yellow", "orangered")) %>%
  add_legend()

#
#===================================
# Configure Arcs

# Set start and end points
edges <- data.frame(origin = c("USA", "FRA", "BGD", "ETH", "KHM",
                               "GRD", "FJI", "GNB", "AUT", "YEM"),
                    target = c("BRA", "USA", "URY", "ZAF", "SAU", "SVK", "RWA", "SWE",
                               "TUV", "ZWE"))
edges %>%
  datamaps() %>%
  add_arcs_name(origin, target) %>%
  config_arcs(stroke.color = "blue", stroke.width = 2, arc.sharpness = 1.5,
              animation.speed = 1000)

#
#===================================

#===================================
# Configure Bubbles

# Set long/lat and size of bubble
coords <- data.frame(city = c("London", "New York", "Beijing", "Sydney"),
                     lon = c(-0.1167218, -73.98002, 116.3883, 151.18518),
                     lat = c(51.49999, 40.74998, 39.92889, -33.92001),
                     values = runif(4, 3, 20))
coords %>%
  datamaps(default = "lightgray") %>%
  add_bubbles(lon, lat, values * 2, values, city) %>%
  config_bubbles(highlight.border.color = "rgba(0, 0, 0, 0.2)",
                 fill.opacity = 0.6,
                 border.width = 0.7,
                 highlight.border.width = 5,
                 highlight.fill.color = "green")

#
#===================================

#===================================
# Configure Geo

data <- data.frame(name = c("USA", "FRA", "CHN", "RUS", "COG", "DZA"),
                   values = c("N. America", "EU", "Asia", "EU", "Africa", "Africa"),
                   letters = LETTERS[1:6])
data %>%
  datamaps(default = "lightgray") %>%
  add_choropleth(name, values) %>%
  config_geo(hide.antarctica = FALSE,
             border.width = 2,
             border.opacity = 0.6,
             border.color = "gray",
             highlight.border.color = "green",
             highlight.fill.color = "lightgreen")

#
#====================================

#====================================
