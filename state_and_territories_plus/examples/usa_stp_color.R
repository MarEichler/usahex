## USA HEX MAP - STATES AND TERRITORIES 
# COLOR
library(tidyverse)

####################
#import centers/fort from csv
centers   <- read_csv("state_and_territories_plus/hex_file/usa_stp_centers.csv")
spdf_fort <- read_csv("state_and_territories_plus/hex_file/usa_stp_fort.csv")


####################
# estimated population change, 2010-2020
# data taken from Wikipedia on 2021-01-14
#source: https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population
extra_data <- read_csv("example_data/population_change.csv") %>%
  #convert character to numeric 
  mutate(
      pop_change = str_replace(pop_change, "%", "")
    , pop_change = str_replace(pop_change, "–", "-")
    , pop_change = as.numeric(pop_change)/100
  )


####################
#combine with data sets 
combined_spdf_fort <- left_join(spdf_fort, extra_data, by = c("id" = "code"))
combined_centers   <- left_join(centers,   extra_data, by = c("id" = "code"))




#######################
#plot using ggplot 
ggplot(combined_spdf_fort) +
  geom_polygon(aes( x = long, y = lat, group = group, fill = pop_change), color = "grey50") +
  geom_text(
      data=combined_centers
    , aes(x=x, y=y+5, label=id)
    , fontface = "bold"
    , size = 4
  ) +
  geom_text(
      data=combined_centers
    , aes(x=x, y=y-5, label=scales::percent(pop_change, accuracy = 0.1))
    , size = 3
  ) +
  coord_fixed() + #keeps all items square (do not use coord_map(); causes issues)
  theme_void() +
  labs(
    title = "Population Change, 2010 - 2020"
    , caption = "Source: https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population as of January 14, 2021"
  ) + 
  scale_fill_gradient2(
      name = "Population\nChange"
    , low = "red"
    , mid = "white"
    , high = "green"
    , midpoint = 0
    , labels = scales::percent
    , na.value = "grey70"
  )

ggsave("state_and_territories_plus/img/usa_stp_color.png", width = 8, height = 5.75, units = c("in"))
