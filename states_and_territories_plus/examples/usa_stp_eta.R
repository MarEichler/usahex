## USA HEX MAP - STATES AND TERRITORIES 
# ETA
library(tidyverse)

####################
#import centers/fort from csv
centers   <- read_csv("states_and_territories_plus/hex_file/usa_stp_centers.csv")
spdf_fort <- read_csv("states_and_territories_plus/hex_file/usa_stp_fort.csv")


####################
# US Department of Labor (DOL) Employment and Training Administration (ETA Regions)
#source: https://www.dol.gov/agencies/eta/regions
extra_data <- read_csv("example_data/eta_regions.csv") %>%
  mutate(eta_region = factor(eta_region, levels = c(6, 4, 5, 3, 2, 1)))

####################
#combine with data sets 
combined_spdf_fort <- left_join(spdf_fort, extra_data)


#######################
#plot using ggplot 
ggplot(combined_spdf_fort) +
  geom_polygon(aes( x = long, y = lat, group = group, fill = eta_region), color = "grey50") +
  geom_text(
    data=centers
    , aes(x=x, y=y, label=id)
    , fontface = "bold"
    , size = 4
  ) +
  coord_fixed() + #keeps all items square (do not use coord_map(); causes issues)
  theme_void() +
  labs(
    title = "US Department of Labor (DOL) Employment and Training Administration (ETA Regions)"
    , caption = "Source: https://www.dol.gov/agencies/eta/regions as of January 14, 2021"
  ) +
  scale_fill_discrete(name = "ETA\nRegion")

ggsave("states_and_territories_plus/img/usa_stp_eta.png", width = 8, height = 5.75, units = c("in"))