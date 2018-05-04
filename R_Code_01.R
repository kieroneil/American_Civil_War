#=======================================================
#
# Temporal-spatial mapping of American Civil War Battles
# 
#=======================================================

library(tidyverse)
library(lubridate)
library(leaflet)


data_dir <- "acw_battle_data/"

nps_battles <- read_csv(paste0(data_dir, "nps_battles_condensed.csv"))
nps_campaigns <- read_csv(paste0(data_dir, "nps_campaigns.csv")) %>%
  select(CampaignCode, CampaignName)
nps_theaters <- read_csv(paste0(data_dir, "nps_theaters.csv")) %>%
  select(TheaterCode, TheaterName)

nps_battles_01 <- nps_battles %>%
  replace_na(list(casualties_kwm_mean = 0)) %>%
  filter(casualties_kwm_mean > 0) %>%
  left_join(nps_campaigns, by = c("campaign_code" = "CampaignCode")) %>%
  left_join(nps_theaters, by = c("theater_code" = "TheaterCode")) %>%
  select(-theater_code, -campaign_code) %>%
  rename("campaign_name" = "CampaignName") %>%
  rename("theater_name" = "TheaterName") %>%
  mutate(campaign_name = as.factor(campaign_name)) %>%
  mutate(theater_name = as.factor(theater_name)) %>%
  mutate(battle_type = as.factor(battle_type)) %>%
  mutate(state = as.factor(state)) %>%
  mutate(result = as.factor(result)) %>%
  mutate(significance = factor(significance, levels=c("A", "B", "C", "D"), ordered=TRUE)) %>%
  mutate(start_date = ymd(start_date)) %>%
  select(cwsac_id, theater_name, campaign_name, everything())

summary(nps_battles_01)
# Default (OpenStreetMap) Tiles
# The easiest way to add tiles is by calling addTiles() with no arguments; by default, OpenStreetMap tiles are used.

# This sets the base view of the map
m <- leaflet(nps_battles_01) %>% setView(lng = mean(nps_battles_01$long), 
                                         lat = mean(nps_battles_01$lat), 
                                         zoom = 5)
m %>% addTiles()

# Create clusters for number of casualties 
casualty_clusters <- kmeans(nps_battles_01, 10)
nps_battles_01$casualty_cluster <- casualty_clusters$cluster

nps_battles_02 <- nps_battles_01 %>% 
  filter(year(start_date) == 1862) %>%
  mutate(content = paste(sep = "<br/>",
                         paste("<b>", battle_name, "</b>"),
                         paste("<b>","Significance:", "</b>",significance), 
                         paste("<b>","Battle type:", "</b>", battle_type),
                         paste("Theater:", theater_name), 
                         paste("Campaign:", campaign_name), 
                         paste("Start date:", start_date), 
                         paste("<b>", "Winner:", result, "</b>"), 
                         paste("Result detail:", results_text),
                         paste("<b>", "Casualties:", casualties_kwm_mean, "</b>")))

leaflet(nps_battles_02) %>% addTiles() %>%
  addCircleMarkers(
    radius = ~sqrt(sqrt(casualties_kwm_mean)) * 2,
    weight = 1,
    fill = ~result,
    opacity = 1.0,
    fillOpacity = 0.20, 
    popup = ~content
  )


casualties_by_day <- nps_battles_02 %>%
  group_by(start_date) %>%
  summarise(ttl_cas = sum(casualties_kwm_mean)) %>%
  ungroup() %>%
  arrange(-ttl_cas) %>%
  top_n(10)

the_news_years_eve_battle <- nps_battles_02 %>%
  filter(start_date == "1862-12-31")

ggplot(casualties_by_day, aes(start_date, ttl_cas)) + 
  geom_line() + 
  geom_smooth()





summary(df$size)

# Create clusters for number of casualties 
casualty_clusters <- kmeans(df$size, 10)
nps_battles_01$casualty_cluster <- casualty_clusters$cluster

library(htmltools)


leaflet(nps_battles_02) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~htmlEscape(content))



leaflet(nps_battles_02) %>% addTiles() %>%
  addPopups(lng = long, lat = lat, popup = content) 


,
            options = popupOptions(closeButton = TRUE)
  )                   
                          
                          

leaflet(df) %>% addTiles() %>%
  addCircleMarkers(
    radius = ~size,
    fill = ~color,
    stroke = FALSE, fillOpacity = 0.25
)


leaflet(df) %>% addTiles() %>%
  addMarkers(~longitude, ~latitude, popup = ~htmlEscape(name))

