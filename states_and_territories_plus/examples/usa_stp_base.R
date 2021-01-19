# USA HEX MAP - STATES AND TERRITORIES 
# BASE

library(tidyverse)

####################
#import centers/fort from csv
centers   <- read_csv("states_and_territories_plus/hex_file/usa_stp_centers.csv")
spdf_fort <- read_csv("states_and_territories_plus/hex_file/usa_stp_fort.csv")


#######################
#plot using ggplot 
ggplot(spdf_fort) +
  geom_polygon(aes( x = long, y = lat, group = group), color = "white") +
  geom_text(data=centers, aes(x=x, y=y, label=abb_gpo), color = "white") +
  coord_fixed() + #keeps all items square (do not use coord_map(); causes issues)
  theme_void()

ggsave("states_and_territories_plus/img/usa_stp_base.png", width = 8, height = 5.75, units = c("in"))
