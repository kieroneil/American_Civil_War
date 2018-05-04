#===================
#
# Leaflet tutorial
#
#===================
library(tidyverse)
library(leaflet)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
m  # Print the map

# Set value for the minZoom and maxZoom settings.
leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))

# You can always explicitly identify latitude/longitude columns 
# by providing lng and lat arguments to the layer function.

# For example, we do not specify the values for the arguments 
# lat and lng in addCircles() below, but the columns Lat and Long 
# in the data frame df will be automatically used:
  
# add some circles to a map
df = data.frame(Lat = 1:10, Long = rnorm(10))
leaflet(df) %>% addCircles()

# You can also explicitly specify the Lat and Long columns 
# (see below for more info on the ~ syntax):
  
leaflet(df) %>% addCircles(lng = ~Long, lat = ~Lat)

# A map layer may use a different data object to override the data 
# provided in leaflet(). We can rewrite the above example as:
  
leaflet() %>% addCircles(data = df)
leaflet() %>% addCircles(data = df, lat = ~ Lat, lng = ~ Long)

# Below are examples of using sp and maps, respectively:
  
library(sp)
Sr1 = Polygon(cbind(c(2, 4, 4, 1, 2), c(2, 3, 5, 4, 2)))
Sr2 = Polygon(cbind(c(5, 4, 2, 5), c(2, 3, 2, 2)))
Sr3 = Polygon(cbind(c(4, 4, 5, 10, 4), c(5, 3, 2, 5, 5)))
Sr4 = Polygon(cbind(c(5, 6, 6, 5, 5), c(4, 4, 3, 3, 4)), hole = TRUE)
Srs1 = Polygons(list(Sr1), "s1")
Srs2 = Polygons(list(Sr2), "s2")
Srs3 = Polygons(list(Sr4, Sr3), "s3/4")
SpP = SpatialPolygons(list(Srs1, Srs2, Srs3), 1:3)
leaflet(height = "300px") %>% addPolygons(data = SpP)

# Mapping the US
library(maps)
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

# 
m = leaflet() %>% addTiles()
df = data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m = leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c('red'))
