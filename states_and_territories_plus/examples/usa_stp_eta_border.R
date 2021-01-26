## USA HEX MAP - STATES AND TERRITORIES 
# ETA FACET 
library(tidyverse)

####################
#import centers/fort from csv
centers     <- read_csv("states_and_territories_plus/hex_file/usa_stp_centers.csv")
spdf_fort   <- read_csv("states_and_territories_plus/hex_file/usa_stp_fort.csv")
eta_borders <- read_csv("states_and_territories_plus/hex_file/usa_stp_eta_borders.csv")


####################
# US Department of Labor (DOL) Employment and Training Administration (ETA Regions)
#source: https://www.dol.gov/agencies/eta/regions
extra_data <- read_csv("example_data/eta_regions.csv") %>%
  mutate(eta_region = factor(eta_region, levels = c(6, 4, 5, 3, 2, 1)))
  

####################
#combine with data sets 
combined_spdf_fort <- left_join(spdf_fort, extra_data)
combined_center    <- left_join(centers,   extra_data)


#######################
#plot using ggplot 
ggplot(combined_spdf_fort)+ 
  geom_polygon(data = combined_spdf_fort, aes(x=long, y = lat, group = group, fill = eta_region), color = NA,show.legend = FALSE) +
  geom_polygon(data = combined_spdf_fort, aes(x=long, y = lat, group = group), fill = NA, color = "white", show.legend = NA, size = 2) +
  geom_text(data = combined_center, aes(x=x, y =y, label = id), fontface = "bold", color = "white") +
  geom_path(data = eta_borders, aes(x=long, y=lat, group = group), color = "grey20", size = 0.5, show.legend = FALSE) +
  theme_void() +
  labs(
    title = "US Department of Labor (DOL) Employment and Training Administration (ETA Regions)"
    , caption = "Source: https://www.dol.gov/agencies/eta/regions as of January 14, 2021"
  ) +
  coord_fixed()


ggsave("states_and_territories_plus/img/usa_stp_eta_border.png", width = 8, height = 5.75, units = c("in"))
