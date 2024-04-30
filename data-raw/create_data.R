
library(tidyverse)
library(sf) 


## META DATA ON GEOGRAPHIES #####################################################

# Geo abbreviations: https://en.wikipedia.org/wiki/List_of_U.S._state_and_territory_abbreviations
geo_abbr_and_names <- read_csv("./data-raw/geo_abbr_and_names.csv", show_col_types = FALSE) 

# WIOA Regional Data: https://www.dol.gov/agencies/eta/regions
wioa_eta_regions <- readr::read_csv("./data-raw/wioa_eta_regions.csv", show_col_types = FALSE) |> 
  mutate_at(vars(eta_region_name, eta_region_city), ~fct_reorder(., eta_region))

geo_info <- select(geo_abbr_and_names, -eta_region)
geo_info_wioaeta <- left_join(geo_abbr_and_names, wioa_eta_regions, by = "eta_region", relationship = "many-to-one")

  



################################################################################
# Create coordinates for hex map
# coordinates are taken from NPR's github
# https://github.com/nprapps/dailygraphics-templates/blob/master/state_grid_map/index.html

# 50 states only 
c_states50 <- list(
    AL = c( 278.012702 , -180, 295.33321  , -190, 295.33321  , -210, 278.012702 , -220, 260.692194 , -210, 260.692194 , -190, 278.012702 , -180)
  , AK = c(  35.5255888,    0,  52.8460969,  -10,  52.8460969,  -30,  35.5255888,  -40,  18.2050808,  -30,  18.2050808,  -10,  35.5255888,    0)
  , AZ = c( 139.448637 , -180, 156.769145 , -190, 156.769145 , -210, 139.448637 , -220, 122.128129 , -210, 122.128129 , -190, 139.448637 , -180)
  , AR = c( 226.051178 , -150, 243.371686 , -160, 243.371686 , -180, 226.051178 , -190, 208.73067  , -180, 208.73067  , -160, 226.051178 , -150)
  , CA = c(  87.4871131, -150, 104.807621 , -160, 104.807621 , -180,  87.4871131, -190,  70.166605 , -180,  70.166605 , -160,  87.4871131, -150)
  , CO = c( 139.448637 , -120, 156.769145 , -130, 156.769145 , -150, 139.448637 , -160, 122.128129 , -150, 122.128129 , -130, 139.448637 , -120)
  , CT = c( 399.256258 ,  -90, 416.576766 , -100, 416.576766 , -120, 399.256258 , -130, 381.93575  , -120, 381.93575  , -100, 399.256258 ,  -90)
  , DE = c( 381.93575  , -120, 399.256258 , -130, 399.256258 , -150, 381.93575  , -160, 364.615242 , -150, 364.615242 , -130, 381.93575  , -120)
  , FL = c( 295.33321  , -210, 312.653718 , -220, 312.653718 , -240, 295.33321  , -250, 278.012702 , -240, 278.012702 , -220, 295.33321  , -210)
  , GA = c( 312.653718 , -180, 329.974226 , -190, 329.974226 , -210, 312.653718 , -220, 295.33321  , -210, 295.33321  , -190, 312.653718 , -180)
  , HI = c(  18.2050808, -210,  35.5255888, -220,  35.5255888, -240,  18.2050808, -250,   0.884572681,-240,  0.884572681,-220, 18.2050808, -210)
  , ID = c(  87.4871131,  -90, 104.807621 , -100, 104.807621 , -120,  87.4871131, -130,  70.166605 , -120,  70.166605 , -100,  87.4871131,  -90)
  , IL = c( 226.051178 ,  -90, 243.371686 , -100, 243.371686 , -120, 226.051178 , -130, 208.73067  , -120, 208.73067  , -100, 226.051178 ,  -90)
  , IN = c( 260.692194 ,  -90, 278.012702 , -100, 278.012702 , -120, 260.692194 , -130, 243.371686 , -120, 243.371686 , -100, 260.692194 ,  -90)
  , IA = c( 191.410162 ,  -90, 208.73067  , -100, 208.73067  , -120, 191.410162 , -130, 174.089653 , -120, 174.089653 , -100, 191.410162 ,  -90)
  , KS = c( 191.410162 , -150, 208.73067  , -160, 208.73067  , -180, 191.410162 , -190, 174.089653 , -180, 174.089653 , -160, 191.410162 , -150)
  , KY = c( 243.371686 , -120, 260.692194 , -130, 260.692194 , -150, 243.371686 , -160, 226.051178 , -150, 226.051178 , -130, 243.371686 , -120)
  , LA = c( 208.73067  , -180, 226.051178 , -190, 226.051178 , -210, 208.73067  , -220, 191.410162 , -210, 191.410162 , -190, 208.73067  , -180)
  , ME = c( 416.576766 ,    0, 433.897275 ,  -10, 433.897275 ,  -30, 416.576766 ,  -40, 399.256258 ,  -30, 399.256258 ,  -10, 416.576766 ,    0)
  , MD = c( 347.294734 , -120, 364.615242 , -130, 364.615242 , -150, 347.294734 , -160, 329.974226 , -150, 329.974226 , -130, 347.294734 , -120)
  , MA = c( 381.93575  ,  -60, 399.256258 ,  -70, 399.256258 ,  -90, 381.93575  , -100, 364.615242 ,  -90, 364.615242 ,  -70, 381.93575  ,  -60)
  , MI = c( 278.012702 ,  -60, 295.33321  ,  -70, 295.33321  ,  -90, 278.012702 , -100, 260.692194 ,  -90, 260.692194 ,  -70, 278.012702 ,  -60)
  , MN = c( 174.089653 ,  -60, 191.410162 ,  -70, 191.410162 ,  -90, 174.089653 , -100, 156.769145 ,  -90, 156.769145 ,  -70, 174.089653 ,  -60)
  , MS = c( 243.371686 , -180, 260.692194 , -190, 260.692194 , -210, 243.371686 , -220, 226.051178 , -210, 226.051178 , -190, 243.371686 , -180)
  , MO = c( 208.73067  , -120, 226.051178 , -130, 226.051178 , -150, 208.73067  , -160, 191.410162 , -150, 191.410162 , -130, 208.73067  , -120)
  , MT = c( 104.807621 ,  -60, 122.128129 ,  -70, 122.128129 ,  -90, 104.807621 , -100,  87.4871131,  -90,  87.4871131,  -70, 104.807621 ,  -60)
  , NE = c( 174.089653 , -120, 191.410162 , -130, 191.410162 , -150, 174.089653 , -160, 156.769145 , -150, 156.769145 , -130, 174.089653 , -120)
  , NV = c( 104.807621 , -120, 122.128129 , -130, 122.128129 , -150, 104.807621 , -160,  87.4871131, -150,  87.4871131, -130, 104.807621 , -120)
  , NH = c( 399.256258 ,  -30, 416.576766 ,  -40, 416.576766 ,  -60, 399.256258 ,  -70, 381.93575  ,  -60, 381.93575  ,  -40, 399.256258 ,  -30)
  , NJ = c( 364.615242 ,  -90, 381.93575  , -100, 381.93575  , -120, 364.615242 , -130, 347.294734 , -120, 347.294734 , -100, 364.615242 ,  -90)
  , NM = c( 156.769145 , -150, 174.089653 , -160, 174.089653 , -180, 156.769145 , -190, 139.448637 , -180, 139.448637 , -160, 156.769145 , -150)
  , NY = c( 347.294734 ,  -60, 364.615242 ,  -70, 364.615242 ,  -90, 347.294734 , -100, 329.974226 ,  -90, 329.974226 ,  -70, 347.294734 ,  -60)
  , NC = c( 295.33321  , -150, 312.653718 , -160, 312.653718 , -180, 295.33321  , -190, 278.012702 , -180, 278.012702 , -160, 295.33321  , -150)
  , ND = c( 139.448637 ,  -60, 156.769145 ,  -70, 156.769145 ,  -90, 139.448637 , -100, 122.128129 ,  -90, 122.128129 ,  -70, 139.448637 ,  -60)
  , OH = c( 295.33321  ,  -90, 312.653718 , -100, 312.653718 , -120, 295.33321  , -130, 278.012702 , -120, 278.012702 , -100, 295.33321  ,  -90)
  , OK = c( 174.089653 , -180, 191.410162 , -190, 191.410162 , -210, 174.089653 , -220, 156.769145 , -210, 156.769145 , -190, 174.089653 , -180)
  , OR = c(  70.166605 , -120,  87.4871131, -130,  87.4871131, -150,  70.166605 , -160,  52.8460969, -150,  52.8460969, -130,  70.166605 , -120)
  , PA = c( 329.974226 ,  -90, 347.294734 , -100, 347.294734 , -120, 329.974226 , -130, 312.653718 , -120, 312.653718 , -100, 329.974226 ,  -90)
  , RI = c( 416.576766 ,  -60, 433.897275 ,  -70, 433.897275 ,  -90, 416.576766 , -100, 399.256258 ,  -90, 399.256258 ,  -70, 416.576766 ,  -60)
  , SC = c( 329.974226 , -150, 347.294734 , -160, 347.294734 , -180, 329.974226 , -190, 312.653718 , -180, 312.653718 , -160, 329.974226 , -150)
  , SD = c( 156.769145 ,  -90, 174.089653 , -100, 174.089653 , -120, 156.769145 , -130, 139.448637 , -120, 139.448637 , -100, 156.769145 ,  -90)
  , TN = c( 260.692194 , -150, 278.012702 , -160, 278.012702 , -180, 260.692194 , -190, 243.371686 , -180, 243.371686 , -160, 260.692194 , -150)
  , TX = c( 191.410162 , -210, 208.73067  , -220, 208.73067  , -240, 191.410162 , -250, 174.089653 , -240, 174.089653 , -220, 191.410162 , -210)
  , UT = c( 122.128129 , -150, 139.448637 , -160, 139.448637 , -180, 122.128129 , -190, 104.807621 , -180, 104.807621 , -160, 122.128129 , -150)
  , VT = c( 364.615242 ,  -30, 381.93575  ,  -40, 381.93575  ,  -60, 364.615242 ,  -70, 347.294734 ,  -60, 347.294734 ,  -40, 364.615242 ,  -30)
  , VA = c( 312.653718 , -120, 329.974226 , -130, 329.974226 , -150, 312.653718 , -160, 295.33321  , -150, 295.33321  , -130, 312.653718 , -120)
  , WA = c(  70.166605 ,  -60,  87.4871131,  -70,  87.4871131,  -90,  70.166605 , -100,  52.8460969,  -90,  52.8460969,  -70,  70.166605 ,  -60)
  , WV = c( 278.012702 , -120, 295.33321  , -130, 295.33321  , -150, 278.012702 , -160, 260.692194 , -150, 260.692194 , -130, 278.012702 , -120)
  , WI = c( 208.73067  ,  -60, 226.051178 ,  -70, 226.051178 ,  -90, 208.73067  , -100, 191.410162 ,  -90, 191.410162 ,  -70, 208.73067  ,  -60)
  , WY = c( 122.128129 ,  -90, 139.448637 , -100, 139.448637 , -120, 122.128129 , -130, 104.807621 , -120, 104.807621 , -100, 122.128129 ,  -90) 
  )
  
# 50 states and DC
c_statesDC <- c_states50
c_statesDC$DC = c( 364.615242 , -150, 381.93575  , -160, 381.93575  , -180, 364.615242 , -190, 347.294734 , -180, 347.294734 , -160, 364.615242 , -150)
  
# States, dc + Territories/Outlying Areas 
c_statesTerr <- c_statesDC
c_statesTerr$AS<-c(  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270)
c_statesTerr$GU<-c(  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270)
c_statesTerr$MP<-c( 35.5255888 , -240,  52.8460969, -250,  52.8460969, -270,  35.5255888, -280,  18.2050808, -270,  18.2050808, -250,  35.5255888, -240)
c_statesTerr$PR<-c( 381.93575  , -240, 399.256258 , -250, 399.256258 , -270, 381.93575  , -280, 364.615242 , -270, 364.615242 , -250, 381.93575  , -240)
c_statesTerr$VI<-c( 416.576766 , -240, 433.897275 , -250, 433.897275 , -270, 416.576766 , -280, 399.256258 , -270, 399.256258 , -250, 416.576766 , -240)
# change HI location, moving closer to lower 48 to make space for pacific islands 
c_statesTerr$HI<-c(  70.166605 , -240,  87.4871131, -250,  87.4871131, -270,  70.166605 , -280,  52.8460969, -270,  52.8460969, -250,  70.166605 , -240)
  
# wioa eta geo's (50 states, dc, outlying areas + Palau) 
c_WIOAETA <- c_statesTerr
# add Palau in Guam's spot 
c_WIOAETA$PW<-c(  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270)
# create new position to the left for AS 
c_WIOAETA$AS<-c(  87.4871131, -270, 104.8075   , -280, 104.8075   , -300,  87.4871131, -310,  70.1665051, -300,  70.1665051, -280,  87.4871131, -270)
# put GU in old AS spot 
c_WIOAETA$GU<-c(  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270)


# Create coordinates for unified pacific islands 
c_unifiedPAislands <- c(
  35.5255888, -240, 52.8460969, -250, 70.166605 , -240, 87.4871131, -250, 87.4871131, -270, 104.8075   , -280, 104.8075   , -300, 
  87.4871131, -310, 70.1665051, -300, 52.845997 , -310, 35.5254889, -300, 18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  
  18.204981 , -270, 18.2050808, -270, 18.2050808, -250, 35.5255888, -240 
)


###############################################################################
#' Create geometry sf object when given 7 point coordinates
#'
#' @param vec A vector of 14 numeric values, vector of 7 coordinates in the form
#'  \code{c(x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7)} 
#'  
#' @importFrom sf st_polygon
#'
#' @return Polygon object, class(.) = c("XY", "POLYGON", "sfg")
#'
#' @examples
#' pol <- make_hex(c(6, 0, 3, 3*sqrt(3), -3, 3*sqrt(3), -6, 0, -3, -3*sqrt(3), 3, -3*sqrt(3), 6, 0))
#' plot(pol)
#' class(pol)
make_hexagon <-  function(vec){
  geo <- st_polygon(list(matrix(vec, ncol=2, byrow=TRUE)))
  return(geo)
}


#######################################
# Create sf hex data frame


# 
coords <- c_statesDC
metadata <- geo_info

#' Create simple features object that has geo hexagon coordinates and meta data (names, abbreviaitons) 
#'
#' @param coords A list of coordinates, the named objects within the list need to use USPS abbrevaitions 
#' @param metadata A data frame with geo names and abbreviations 
#'
#' @return A simple features objects (a 'data frame' that includes the coordinates in one column) 
#'
#' @examples
create_sf <- function(coords, metadata){
  
  # make sure coordinates are ordered alphabetically by abbreviation 
  coords <- coords[sort(names(coords))]
  
  # pull geo abbr/names based on what is included in coordinates
  gdat  <- metadata[which(metadata$abbr_usps %in% names(coords)),] |> 
    # arrange by USPS (to match coordinate names) 
    arrange(abbr_usps)
  
  # make coords into shape objects (hexagons)  
  glst  <- lapply(coords, make_hexagon)
  
  # create simple features shape object with coordinates 
  gcol  <- st_sfc(glst[gdat$abbr_usps])
  
  # combine meta data (names, abbreviations) with shape coordinates 
  gsf <- st_sf(gdat[order(gdat$abbr_usps),], geometry = gcol) 
  
  # add factor levels based on fips code (so consistent across abbreviations and names) 
  hexsf <- mutate_at(gsf, vars(abbr_usps, abbr_gpo, abbr_ap, name), ~fct_reorder(., as.numeric(fips))) 
  
}


states50   <- create_sf(c_states50, geo_info)
statesDC   <- create_sf(c_statesDC, geo_info) 
statesTerr <- create_sf(c_statesTerr, geo_info)
WIOAETA    <- create_sf(c_WIOAETA, geo_info_wioaeta)


#######################################
#' Create sf label data frame
#' 
#' @param hex_sf 
create_labels <- function(hex_sf){
  
  lab <- st_sf(hex_sf, geometry = st_centroid(hex_sf$geometry))
  
}


states50_labels   <- create_labels(states50)
statesDC_labels   <- create_labels(statesDC) 
statesTerr_labels <- create_labels(statesTerr)
WIOAETA_labels    <- create_labels(WIOAETA)


# create WIOA regions sf object 

gcol_WIOAETAregions <- WIOAETA |>
  # remove pacific islands
  # trying to unify pacific island using st_union doesn't work
  filter(!abbr_usps %in% c("MP", "HI", "PW", "GU", "AS")) |>
  # group by eta region
  arrange(eta_region) |>
  group_by(eta_region) |>
  # create unified polygons by WIOA ETA region
  summarize(geometry = sf::st_union(geometry, is_coverage = TRUE)) |>
  # make sure coordinates are ordered by eta region
  dplyr::arrange(eta_region) |>
  # pull the geometry coordinates
  dplyr::pull(geometry) |>
  # create a simple features geometry list column
  st_sfc()

# add coordinates for unified pacific islands
gcol_WIOAETAregions[6] <- sf::st_union(c(gcol_WIOAETAregions[6], sf::st_geometry(make_hexagon(c_unifiedPAislands))))

WIOAETAregions <- st_sf(wioa_eta_regions, geometry = gcol_WIOAETAregions)

# create region labels  
WIOAETAregions_labels <- create_labels(WIOAETAregions)

# make adjustments to label location 
WIOAETAregions_labels[1,]$geometry <- WIOAETAregions_labels[1,]$geometry + c(-6, 25)
WIOAETAregions_labels[2,]$geometry <- WIOAETAregions_labels[2,]$geometry + c( 0,  4)
WIOAETAregions_labels[3,]$geometry <- WIOAETAregions_labels[3,]$geometry + c( 5,  0)
WIOAETAregions_labels[4,]$geometry <- sf::st_geometry(sf::st_point(c(191.4102, -205)))
WIOAETAregions_labels[5,]$geometry <- WIOAETAregions_labels[5,]$geometry + c( 0,  5)
WIOAETAregions_labels[6,]$geometry <- sf::st_geometry(sf::st_point(c(87.48711, -140)))





# export to data folder 

usethis::use_data(states50)
usethis::use_data(states50_labels)

usethis::use_data(statesDC)
usethis::use_data(statesDC_labels)

usethis::use_data(statesTerr)
usethis::use_data(statesTerr_labels)

usethis::use_data(WIOAETA)
usethis::use_data(WIOAETA_labels)

usethis::use_data(WIOAETAregions)
usethis::use_data(WIOAETAregions_labels)




