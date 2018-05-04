#==================================
#
# American Civil War
#
# Exploratory Data Analysis
#
#==================================

library(tidyverse)
library(lubridate)
library(leaflet)


data_dir <- "acw_battle_data/"

nps_battles <- read_csv(paste0(data_dir, "nps_battles_condensed.csv"))
nps_campaigns <- read_csv(paste0(data_dir, "nps_campaigns.csv")) %>%
  select(CampaignCode, CampaignName)
nps_theaters <- read_csv(paste0(data_dir, "nps_theaters.csv")) %>%
  select(TheaterCode, TheaterName)

nps_people <- read_csv(paste0(data_dir, "nps_people.csv")) 
nps_forces <- read_csv(paste0(data_dir, "nps_forces.csv")) 
nsp_commanders <- read_csv(paste0(data_dir, "nps_commanders.csv"))

# Break out Union and Confederate
union_commanders <- nsp_commanders %>%
  filter(belligerent == "US")

colnames(union_commanders)[2:12] <- paste("union", 
                                          colnames(union_commanders[,c(2:12)]), 
                                          sep = "_")

union_commanders <- union_commanders[, -2]

#

confed_commanders <- nsp_commanders %>%
  filter(belligerent == "Confederate")

colnames(confed_commanders)[2:12] <- paste("confederate", 
                                          colnames(confed_commanders[,c(2:12)]), 
                                          sep = "_")

confed_commanders <- confed_commanders[, -2]

# Join both side's commanders to the main battles dataset
battles_02 <- nps_battles %>%
  left_join(union_commanders, by = "cwsac_id") %>%
  left_join(confed_commanders, by = "cwsac_id") %>%
  left_join(nps_theaters, by = c("theater_code" = "TheaterCode")) %>%
  left_join(nps_campaigns, by = c("campaign_code" = "CampaignCode")) %>%
  rename(theater_name = TheaterName) %>%
  rename(campaign_name = CampaignName) %>%
  select(start_date, end_date, theater_name, campaign_name, 
         battle_name, battle_type, result, significance, 
         lat, long, union_last_name, confederate_last_name, 
         result, results_text, casualties_kwm_mean)

# Which battles did US Grant command for the Union?
# grant_battles <- battles_02 %>%
#   filter(union_last_name == "Grant")
# 
# lee_battles <- battles_02 %>%
#   filter(confederate_last_name == "Lee" & confederate_first_name == "Robert")
# 
# grant_lee_battles <- battles_02 %>%
#   filter((confederate_last_name == "Lee" & confederate_first_name == "Robert") |
#            union_last_name == "Grant")

# Buld content for map
gl_w_content <- battles_02 %>%
  mutate(
    content = paste(
      sep = "<br/>",
      paste("<b>", battle_name, "</b>"),
      paste("<b>", "Union commander:", union_last_name, "</b>"),
      paste("<b> Confederate commander:", confederate_last_name, "</b>"),
      paste("<br>", "Significance:", "</br>", significance),
      paste("<br>", "Battle type:", "</br>", battle_type),
      paste("Theater:", theater_name),
      paste("Campaign:", campaign_name),
      paste("Start date:", start_date),
      paste("<b>", "Winner:", result, "</b>"),
      paste("Result detail:", results_text),
      paste("<b>", "Casualties:", casualties_kwm_mean, "</b>")
    ) 
  ) %>%
  mutate(fill = as.character(NA)) %>%
  mutate(display_radius = as.integer(NA)) %>%
  mutate(duration_adj = as.integer(NA)) %>%
  mutate(duration = as.duration(NA)) %>%
  select(fill, result, display_radius, duration_adj, duration, everything())

# Determine the fill color of each circle
for(i in 1:nrow(gl_w_content)) {
  gl_w_content[i, ]$fill =
    if (gl_w_content[i, ]$result == "Union") {
      "blue"
    } else if (gl_w_content[i, ]$result == "Confederate") {
      "red"
    } else if (gl_w_content[i, ]$result == "Inconclusive") {
      "gray"
    }
}

# Calculate my display radius of the circles
for (i in 1:nrow(gl_w_content)) {
  gl_w_content[i,]$display_radius =
    if (gl_w_content[i,]$significance == "D") {
      2
    } else if (gl_w_content[i,]$significance == "C") {
      4
    } else if (gl_w_content[i,]$significance == "B") {
      8
    } else if (gl_w_content[i,]$significance == "A") {
      12
    }
}

# Calculate the duration to show the circles
for (i in 1:nrow(gl_w_content)) {
  gl_w_content[i,]$duration_adj =
    if (gl_w_content[i,]$significance == "D") {
      6
    } else if (gl_w_content[i,]$significance == "C") {
      12
    } else if (gl_w_content[i,]$significance == "B") {
      24
    } else if (gl_w_content[i,]$significance == "A") {
      48
    }
}

gl_w_duration <-
  mutate(gl_w_content, display_interval = interval(start_date,
                                           end_date + duration_adj)) 

saveRDS(gl_w_duration, "acw_data_kao.RDS")
gl_w_duration <- readRDS("acw_data_kao.RDS") %>%
  select(start_date, display_interval, lat, long, display_radius, result, fill, content)

# Let's use a test date to see if we can filter on durations
battle_date <- ymd("1863-08-01")
battle_date <- min(gl_w_duration$start_date)


display_active_battles <- function(battle_date = ymd("1863-07-03")) {
  
  active_battle_ind <- battle_date %within% gl_w_duration$display_interval
  #sum(active_battle_ind)
  active_battles <- gl_w_duration[active_battle_ind, ]
  
  # Map out battles
  leaflet(active_battles) %>% 
    setView(lng = -82.46, lat = 36.62, zoom = 5) %>%
    addTiles() %>%
    addCircleMarkers(
      lat = ~ lat,
      lng = ~ long,
      radius = ~ display_radius,
      color = ~ result,
      weight = 2,
      opacity = 1.0,
      fill = TRUE,
      fillColor = ~ fill,
      fillOpacity = 0.40,
      popup = ~ content
    )
}

display_active_battles(battle_date)
# Whoo hoo!!  I can map battles according to their date



union_colnames <- paste("union", colnames(union_commanders[, -1]), sep = "_")
names(union_commanders[, -1]) <- union_colnames

uc_01 <- colnames(union_commanders[, -1]) <- paste("union", 
                                          colnames(union_commanders[, -1]), 
                                          sep = "_")


%>%
  rename(union_beligerent = belligerent) %>%
  rename(union_commander_number = commander_number)

# Merge campaign and theotre text into battles
battles_01 <- nps_battles %>%
  left_join(nps_theaters, by = c("theater_code" = "TheaterCode")) %>%
  left_join(nps_campaigns, by = c("campaign_code" = "CampaignCode")) %>%
  select(-theater_code, -campaign_code) %>%
  rename("theater_name" = "TheaterName") %>%
  rename("campaign_name" = "CampaignName") %>%
  select(cwsac_id, theater_name, campaign_name, battle_name, 
         significance, casualties_kwm_mean, everything()) %>%
  replace_na(list(casualties_kwm_mean = 0)) %>%
  filter(casualties_kwm_mean > 0)

# What was the first battle?
first_battle <- battles_01 %>%
  filter(start_date == min(start_date))

# What was the first battle?
last_battle <- battles_01 %>%
  filter(end_date == max(end_date))

# What is the span from start to finish?
last_battle$end_date - first_battle$start_date
# Interesting, a difference of 1492 days

# Total casualties
total_casualties <- sum(battles_01$casualties_kwm_mean)
# 910,483




