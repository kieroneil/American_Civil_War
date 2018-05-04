gl_w_duration <- readRDS("acw_data_kao.RDS") %>%
  select(start_date, display_interval, lat, long, display_radius, result, fill, content)