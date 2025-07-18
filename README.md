
# usahex

## Installation

``` r
# install.packages("devtools")
devtools::install_github("mareichler/usahex")
```

## Hex Maps

I’ve copied the coordinates from the NPR Graphics team:
[github.com/nprapps/dailygraphics-templates](https://github.com/nprapps/dailygraphics-templates/blob/129967a4ae36f14cf299f434f9814f7314a00cde/state_grid_map/index.html#L50-L110).
The y values have been reversed so that the plot is not upside down.

``` r
library(usahex)
library(tidyverse)
```

``` r
get_coordinates(map = "WIOAETA", coords = "hexmap") |> 
  ggplot() + 
  geom_sf(aes(fill = geo_type)) + 
  geom_sf_text(aes(label = abbr_usps)) + 
  theme_void()
```

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
