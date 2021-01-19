## USA HEX MAP - STATES AND TERRITORIES 
# ETA FACET 
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
combined_center    <- left_join(centers,   extra_data)


#######################
#plot using ggplot 


ggplot(combined_spdf_fort, aes(fill = eta_region)) + 
  geom_polygon(aes(x=long, y = lat, group = group), color = "grey50", show.legend = FALSE) +
  facet_grid(.~eta_region, space = "free_x", scales = "free_x") +
  geom_text(data = combined_center, aes(x=x, y =y, label = id), fontface = "bold", size = 3) +
 theme_void() +
  labs(
      title = "US Department of Labor (DOL) Employment and Training Administration (ETA Regions)"
    , caption = "Source: https://www.dol.gov/agencies/eta/regions as of January 14, 2021"
  ) +
  theme(
      strip.text.x = element_text(size = 12)
    , strip.background.x = element_rect(fill = "grey80")
    , plot.title = element_text(margin = margin(0, 0, 7, 0, unit = "pt"),hjust = 0.5)
    , aspect.ratio = 370 
  )
  

ggsave("states_and_territories_plus/img/usa_stp_eta_facet.png", width = 8, height = 5.75, units = c("in"))
