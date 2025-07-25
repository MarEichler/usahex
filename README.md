
# usahex

This is a simple packages that includes hex maps of the United States
with multiple options of different geographies. Other hex maps available
for public use only have the 50 states + DC: [R Graph
Gallery](https://r-graph-gallery.com/328-hexbin-map-of-the-usa.html) and
[Datawrapper](https://www.datawrapper.de/basemaps/usa-states-hexagons.html).

However, this ignores territories (also referred to as outlying areas)
and freely associated states. The [CDC Open-Source Visualization Editor
(COVE)](https://www.cdc.gov/cove/data-visualization-types/hex-map.html)
addresses this by putting hexagons in a line at the bottom of the 50
states + DC hex map. However, the coordinates provided on the [json file
available on cdc-open-vis
GitHub](https://github.com/CDCgov/cdc-open-viz/blob/main/packages/map/src/components/UsaMap/data/us-hex-topo.json)
only has the 50 states + DC and **does not provide** coordinates for
territories or freely associated states.

## Benefits of this package

- includes hex maps **with** territories and freely associate states
- simple hexagon coordinates (not based on lat/long coordinates): which
  makes it much easier to add/subtract/move hexagons so if you want a
  map with different permutations, you can make it yourself!

## WHY?

Hex maps are much better when displaying information on a state-by-state
basis. Most of the US choropleth maps are not using metrics that relate
to land size, so there is no need to use a traditional lat/long map.
Traditional maps over emphasis large-land geographies and makes
small-land geographies difficult to see.

Hex maps are easier for displaying data on a unique state basis and
allow for enough space to put actual values on the map FOR EVERY
GEOGRAPHY (not just the large-land geographies)

## Original Coordinates Source

Back during covid times, [NPR used hex maps (that included US
territories)](https://www.npr.org/2021/12/27/1068303629/covid-19-omicron-maps-data-states)
to show different covid related metrics. I reached out to [Alyson Hurt,
Supervising Graphics
Editor](https://www.npr.org/people/348735573/alyson-hurt) who pointed me
to the [dailygraphics-templates file on
GitHub](https://github.com/nprapps/dailygraphics-templates/blob/129967a4ae36f14cf299f434f9814f7314a00cde/state_grid_map/index.html#L49-L110)
that contained the coordinates for the map. I’ve made some small
adjustments, moving some of the pacific island hexagons around and
adding some new ones; but these coordinates are the basis for all of the
maps in this package. The y values have been reversed so that the plot
is not upside down.

## R Installation

The packages uses [sf](https://r-spatial.github.io/sf/) package (sf =
simple features) to create shape objects that are easy to plot using the
[ggplot2](https://ggplot2.tidyverse.org/) package, my preferred medium
for data visualizations.

``` r
# install.packages("devtools")
devtools::install_github("mareichler/usahex")
```

## Hex Maps

| geos / map name | `usa50` | `usa51` | `usa52` | `usa53` | `usa56` | `usa59` | `usaETA`/`usaETAregions` |
|:---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 50 states | X | X | X | X | X | X | X |
| District of Columbia | \- | X | X | X | X | X | X |
| Puerto Rico - *territory* | \- | \- | X | X | X | X | X |
| U.S. Virgin Islands - *territory* | \- | \- | \- | X | X | X | X |
| GU, AS, MP - *territories* | \- | \- | \- | \- | X | X | X |
| Palau - *freely associate state* | \- | \- | \- | \- | \- | X | X |
| FM & MH - *freely associate states* | \- | \- | \- | \- | \- | X | \- |

``` r
library(usahex)
library(ggplot2)
```

``` r
allgeos <- get_coordinates(map = "usa59", coords = "hexmap") |> 
  ggplot() + 
  geom_sf(aes(fill = geo_type)) + 
  ## don't need to use usa59_labels df, ggplot2 automatically finds center 
  ## labels df can be used if interested, mostly there for back-up 
  # geom_sf_text(data = get_coordinates("usa59", "labels"), aes(label = abbr_usps)) + 
  geom_sf_text(aes(label = abbr_usps)) + 
  theme_void()
```

``` r
allgeos
```

<figure>
<img src="man/figures/example_map_showing_all_geos.png"
alt="usa59 hex map showing all geographies available" />
<figcaption aria-hidden="true">usa59 hex map showing all geographies
available</figcaption>
</figure>

## Don’t Use R?

### geojson files

These files can be found in the
[data-raw/geojson](https://github.com/MarEichler/usahex/tree/main/data-raw/geojson)
folder on GitHub.

``` r
geojson <- "https://raw.githubusercontent.com/MarEichler/usahex/refs/heads/main/data-raw/geojson/usa56.geojson"

library(sf)
```

    ## Warning: package 'sf' was built under R version 4.4.3

    ## Linking to GEOS 3.13.0, GDAL 3.10.1, PROJ 9.5.1; sf_use_s2() is TRUE

``` r
read_sf(geojson)[1:5,]
```

    ## Simple feature collection with 5 features and 8 fields
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: 18.20508 ymin: -310 xmax: 295.3332 ymax: 0
    ## Geodetic CRS:  WGS 84
    ## # A tibble: 5 × 9
    ##   abbr_usps abbr_gpo abbr_ap abbr_short abbr_long name           fips  geo_type 
    ##   <chr>     <chr>    <chr>   <chr>      <chr>     <chr>          <chr> <chr>    
    ## 1 AK        Alaska   Alaska  Ak.        Alaska    Alaska         02    state    
    ## 2 AL        Ala.     Ala.    Ala.       Alab.     Alabama        01    state    
    ## 3 AR        Ark.     Ark.    Ark.       Arkan.    Arkansas       05    state    
    ## 4 AS        A.S.     A.S.    A.S.       Am.Sa.    American Samoa 60    territory
    ## 5 AZ        Ariz.    Ariz.   Arz.       Ariz.     Arizona        04    state    
    ## # ℹ 1 more variable: geometry <POLYGON [°]>

``` r
df <- read_sf(geojson) 

gggeojson <- ggplot(df) + 
  geom_sf() +
  geom_sf_text(aes(label = abbr_short)) + 
  theme_void()
```

ggplot2 gets a lil angry when adding labels because geojson files are
supposed to be lat/long coordinates, and these are clearly not.

``` r
gggeojson
```

    ## Warning in st_is_longlat(x): bounding box has potentially an invalid value
    ## range for longlat data

    ## Warning in st_point_on_surface.sfc(sf::st_zm(x)): st_point_on_surface may not
    ## give correct results for longitude/latitude data

<figure>
<img src="man/figures/geojson_example_map.png"
alt="usa56 hex map created from geojson file" />
<figcaption aria-hidden="true">usa56 hex map created from geojson
file</figcaption>
</figure>

### CVS Files

These files can be found in the
[data-raw/csv](https://github.com/MarEichler/usahex/tree/main/data-raw/csv)
folder on GitHub.

``` r
csv <- "https://raw.githubusercontent.com/MarEichler/usahex/refs/heads/main/data-raw/csv/usa53.csv"
read.csv(csv)[1:14,]
```

    ##    hexmap abbr_usps abbr_gpo abbr_ap abbr_short abbr_long    name fips geo_type
    ## 1   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 2   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 3   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 4   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 5   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 6   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 7   usa53        AL     Ala.    Ala.       Ala.     Alab. Alabama    1    state
    ## 8   usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ## 9   usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ## 10  usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ## 11  usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ## 12  usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ## 13  usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ## 14  usa53        AK   Alaska  Alaska        Ak.    Alaska  Alaska    2    state
    ##            X    Y        cX   cY
    ## 1  278.01270 -180 278.01270 -200
    ## 2  295.33321 -190 278.01270 -200
    ## 3  295.33321 -210 278.01270 -200
    ## 4  278.01270 -220 278.01270 -200
    ## 5  260.69219 -210 278.01270 -200
    ## 6  260.69219 -190 278.01270 -200
    ## 7  278.01270 -180 278.01270 -200
    ## 8   35.52559    0  35.52559  -20
    ## 9   52.84610  -10  35.52559  -20
    ## 10  52.84610  -30  35.52559  -20
    ## 11  35.52559  -40  35.52559  -20
    ## 12  18.20508  -30  35.52559  -20
    ## 13  18.20508  -10  35.52559  -20
    ## 14  35.52559    0  35.52559  -20

The `X` and `Y` coordinates are the 7 coordinates for each state that
create the hexagon. The `cX` and `cY` are repeated center coordinates
that create a single point in the center of the given hexagons.

These raw files can also be used to create ggplot2 items if you don’t
want to work with simple features (sf) objects:

``` r
df <- read.csv(csv) 

ggcsv <- ggplot(df, aes(group=abbr_usps)) +
  geom_polygon(aes(x=X, y=Y), color = "white", fill = "grey35") +
  geom_text(
    data=dplyr::distinct(df, abbr_usps, cX, cY), # only need 1coord per state
    aes(label=abbr_usps, x = cX, y = cY), 
    size = 3.25, 
    color = "white"
  ) +
  coord_fixed() + 
  theme_void() 
```

``` r
ggcsv
```

<figure>
<img src="man/figures/csv_example_map.png"
alt="usa53 hex map created from csv file" />
<figcaption aria-hidden="true">usa53 hex map created from csv
file</figcaption>
</figure>
