# USA HEX MAP - STATES AND TERRITORIES 
# BASE

library(tidyverse)
library(geojsonio)

####################
#import centers/fort from csv
centers   <- read_csv("state_and_territories/hex_file/usa_st_centers.csv")
spdf_fort <- read_csv("state_and_territories/hex_file/usa_st_fort.csv")


#######################
#plot using ggplot 
ggplot(spdf_fort) +
  geom_polygon(aes( x = long, y = lat, group = group), color = "white") +
  geom_text(data=centers, aes(x=x, y=y, label=abb_gpo), color = "white") +
  coord_fixed() + #keeps all items square (do not use coord_map(); causes issues)
  theme_void()

ggsave("state_and_territories/img/usa_st_base.png", width = 8, height = 5.75, units = c("in"))
