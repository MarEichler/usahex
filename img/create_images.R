
library(tidyverse)

#########################################
#import shape files 
states        <- readRDS("data/states/1_rds/states.RDS")
states_labels <- readRDS("data/states/1_rds/states_labels.RDS")

states_outlyingareas        <- readRDS("data/states_outlyingareas/1_rds/states_outlyingareas.RDS")
states_outlyingareas_labels <- readRDS("data/states_outlyingareas/1_rds/states_outlyingareas_labels.RDS")

wioa_eta        <- readRDS("data/wioa_eta/1_rds/wioa_eta.RDS")
wioa_eta_labels <- readRDS("data/wioa_eta/1_rds/wioa_eta_labels.RDS")

wioa_regions        <- readRDS("data/wioa_regions/1_rds/wioa_regions.RDS")
wioa_regions_labels <- readRDS("data/wioa_regions/1_rds/wioa_regions_labels.RDS") 

#########################################
# PLAIN PLOTS  

# states
ggplot(states) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=states_labels, aes(label=abb_gpo), color = "white") + 
  theme_void()

ggsave("img/plain-states.png", width = 8, height = 5.75, units = c("in"))

# states and outlying areas 
ggplot(states_outlyingareas) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=states_outlyingareas_labels, aes(label=abb_gpo), color = "white") + 
  theme_void()

ggsave("img/plain-states_outlyingareas.png", width = 8, height = 5.75, units = c("in"))

# wioa eta   
ggplot(wioa_eta) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=wioa_eta_labels, aes(label=abb_gpo), color = "white") + 
  theme_void()

ggsave("img/plain-wioa_eta.png", width = 8, height = 5.75, units = c("in"))

# wioa regions 
Pwioaregions <- ggplot(wioa_regions) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=wioa_regions_labels, aes(label=eta_region_city), color = "white", fontface="bold") +
  theme_void()

Pwioaregions
ggsave("img/plain-wioa_regions.png", width = 8, height = 5.75, units = c("in"))



#######################
# data (add additional data)

#estimated population change, 2010-2020
#data taken from Wikipedia on 2021-01-14
#source: https://en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population
other_data <- read_csv("data/population_change.csv", show_col_types = FALSE) %>%
  mutate(
    pop_change = str_replace(pop_change, "%", "")
    , pop_change = str_replace(pop_change, "–", "-")
    , pop_change = as.numeric(pop_change)/100
  )

combined        <- left_join(wioa_eta,        other_data, by = c("abb_usps"="code"))
combined_labels <- left_join(wioa_eta_labels, other_data, by = c("abb_usps"="code"))

NA_color <- "grey80"

ggplot(combined) + 
  geom_sf(aes(fill = pop_change),     color = NA       ) +  #color (non-NA) hex
  geom_sf(    fill = NA,          aes(color = "NA")    ) +  #dummy legend for NA values 
  geom_sf(    fill = NA,              color = "grey50" ) +  #hex borders 
  geom_sf_text(
      data=mutate(combined_labels, geometry=geometry+c(0, 5))
    , aes(label=abb_usps)
    , fontface="bold"
    , size=3.25
  ) + 
  geom_sf_text(
      data=mutate(combined_labels, geometry=geometry+c(0,-5))
    , aes(label=scales::percent(pop_change, accuracy=0.1))
    , size=2.75
  ) + 
  scale_fill_gradient2(
      name = "Population\nChange"
    , low  = RColorBrewer::brewer.pal(3, "PiYG")[1]
    , mid  = RColorBrewer::brewer.pal(3, "PiYG")[2]
    , high = RColorBrewer::brewer.pal(3, "PiYG")[3]
    , midpoint = 0
    , labels = scales::percent
    , na.value = NA_color
  ) + 
  scale_color_manual( #dummy legend for NA color 
      name = NULL
    , values = NA_color
    , labels = 'No data'
  ) +
  guides(
      fill  = guide_colorbar(order = 1)
    , color = guide_legend(override.aes = list(fill =NA_color))
  ) +
  labs(
      title = "Population Change, 2010 - 2020"
    , caption = paste(
      c(
        "Source:",
        "en.wikipedia.org/wiki/List_of_states_and_territories_of_the_United_States_by_population",
        "as of January 14, 2021"
      ), 
      collapse="\n")
  ) +
  theme_void()

ggsave("img/plot-wioa_eta-otherdata.png", width = 8, height = 5.75, units = c("in"))


#######################
# type 

ggplot(wioa_eta) + 
  geom_sf(color = "white", aes(fill = type)) + 
  geom_sf_text(data=wioa_eta_labels, aes(label=abb_gpo)) + 
  scale_fill_discrete(name = "Geography Type") + 
  theme_void()

ggsave("img/type-wioa_eta.png", width = 10.25, height = 5.75, units = c("in"))


#######################
# region 

Pregionwioeta <- ggplot(wioa_eta) + 
  geom_sf(color = "white", aes(fill = as.character(eta_region))) + 
  geom_sf_text(data=wioa_eta_labels, aes(label=abb_gpo)) + 
  geom_sf(data=wioa_regions, fill = NA, color = "grey35", size = 0.75) + 
  scale_fill_discrete(name = "ETA Region") + 
  guides(fill = guide_legend(override.aes = list(color = "grey35", size = 0.75))) +
  theme_void()

Pregionwioeta
ggsave("img/region-wioa_eta.png", width = 9, height = 5.75, units = c("in"))


##########################
#combine plain-wioa_regions and region-wioa_eta

cowplot::plot_grid(
    Pwioaregions 
  , Pregionwioeta 
  , align = "hv"
  , axis = "tblr"
  )
ggsave("img/region-2-plots.png", width = 17, height = 5.75, units = c("in"))




################
## plot different types of files 

states        <- readRDS("data/states/1_rds/states.RDS")
states_labels <- readRDS("data/states/1_rds/states_labels.RDS")

ggplot(states) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=states_labels, aes(label=abb_gpo), size = 3.25, color = "white") 

ggsave("img/plot-states-rds.png", width = 8, height = 5.75, units = c("in"))

states        <- sf::read_sf("data/states/2_shp/states.shp")
states_labels <- sf::read_sf("data/states/2_shp/states_labels.shp")

ggplot(states) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=states_labels, aes(label=abb_gpo), size = 3.25, color = "white") 

ggsave("img/plot-states-shp.png", width = 8, height = 5.75, units = c("in"))


states        <- readr::read_csv("data/states/3_csv/states.csv"       , show_col_types = FALSE)
states_labels <- readr::read_csv("data/states/3_csv/states_labels.csv", show_col_types = FALSE)

ggplot(states, aes(x=X, y=Y, group=id)) + 
  geom_polygon(color = "white", fill = "grey35") + 
  geom_text(data=states_labels, aes(label=abb_gpo), size = 3.25, color = "white") + 
  coord_fixed()  #don't use coord_map(), only coord_fixed()

ggsave("img/plot-states-csv.png", width = 8, height = 5.75, units = c("in"))
