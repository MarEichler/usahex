# US Hex Map: States

```r
library(tidyverse)
states        <- readRDS("data/states/1_rds/states.RDS")
states_labels <- readRDS("data/states/1_rds/states_labels.RDS")
```

# Base Map   
```r
ggplot(states) + 
  geom_sf(color = "white", fill = "grey35") + 
  geom_sf_text(data=states_labels, aes(label=abb_gpo), color = "white") + 
  theme_void()
```
![USA Hex Map with States: Base](base.png)


# Color Example 
```r
extra_data <- read_csv("data/population_change.csv", show_col_types = FALSE) %>%
  mutate(
      pop_change = str_replace(pop_change, "%", "")
    , pop_change = str_replace(pop_change, "–", "-")
    , pop_change = as.numeric(pop_change)/100
  )

combined        <- left_join(states,        extra_data, by = c("abb_usps"="code"))
combined_labels <- left_join(states_labels, extra_data, by = c("abb_usps"="code"))

ggplot(combined) + 
  geom_sf(aes(fill = pop_change),     color = NA       ) +  #color (non-NA) hex
  geom_sf(    fill = NA,              color = "grey50" ) +  #hex borders 
  geom_sf_text(
      data = mutate(combined_labels, geometry=geometry+c(0, 5))
    , aes(label=abb_usps)
    , fontface="bold"
    , size=3.25
  ) + 
  geom_sf_text(
      data = mutate(combined_labels, geometry=geometry+c(0,-5))
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
```
![USA Hex Map with States: Color](color.png)


