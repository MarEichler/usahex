
library(tidyverse)
library(sf) 


# META DATA ON GEOGRAPHIES #####################################################

# Geo abbreviations ------------------------------------------------------------
# link: https://en.wikipedia.org/wiki/List_of_U.S._state_and_territory_abbreviations
geo_abbr_and_names <- read_csv(
  "./data-raw/geo_abbr_and_names.csv", 
  show_col_types = FALSE
  ) 

# ETA Regional Data -----------------------------------------------------------
# link: https://www.dol.gov/agencies/eta/regions
wioa_eta_regions <- read_csv(
  "./data-raw/wioa_eta_regions.csv", 
  show_col_types = FALSE
  ) |> 
  mutate_at(
    vars(eta_region_name, eta_region_city),
    ~fct_reorder(., eta_region)
  )

# only geo info (no WIOA ETA info) 
geo_info <- select(geo_abbr_and_names, -eta_region)

# combine geo info with WIOA ETA info
geo_info_wioaeta <- left_join(
  geo_abbr_and_names, wioa_eta_regions, 
  by = "eta_region", 
  relationship = "many-to-one"
)

  



# CREATE COORDINATES FOR HEX MAP ###############################################
# coordinates are taken from NPR's github
# https://github.com/nprapps/dailygraphics-templates/blob/master/state_grid_map/index.html

# usa50 - 50 states only  -----------------------------------------------------
c_usa50 <- list(
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
  
# usa51 - 50 states & DC ------------------------------------------------------
# add new hexagon for DC 
c_usa51 <- c_usa50
c_usa51$DC <- c( 364.615242 , -150, 381.93575  , -160, 381.93575  , -180, 364.615242 , -190, 347.294734 , -180, 347.294734 , -160, 364.615242 , -150)
  
# usa52 - 50 states, DC, & PR -------------------------------------------------
# add new hexagon for PR 
c_usa52 <- c_usa51
c_usa52$PR <- c( 416.576766 , -240, 433.897275 , -250, 433.897275 , -270, 416.576766 , -280, 399.256258 , -270, 399.256258 , -250, 416.576766 , -240)
# adjust HI to be in a horizontal line with PR; # note the even numbered items in the vector match PR 
c_usa52$HI <- c(  18.2050808, -240,  35.5255888, -250,  35.5255888, -270,  18.2050808, -280,  0.884572681,-270,  0.884572681,-250, 18.2050808, -240)

# usa53 - 50 states, DC,PR & VI -----------------------------------------------
# add new hexagon next to original PR hexagon 
# move PR in the new hexagon, put VI in the original PR hexagon 
c_usa53 <- c_usa52
c_usa53$VI <- c_usa53$PR
c_usa53$PR <-c( 381.93575  , -240, 399.256258 , -250, 399.256258 , -270, 381.93575  , -280, 364.615242 , -270, 364.615242 , -250, 381.93575  , -240)


# usa56 - 50 states, DC, PR, VI, AS, GU, & MP 
# add AS, GU, and MP -- move HI 
c_usa56 <- c_usa53
c_usa56$AS<-c(  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270)
c_usa56$GU<-c(  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270)
c_usa56$MP<-c( 35.5255888 , -240,  52.8460969, -250,  52.8460969, -270,  35.5255888, -280,  18.2050808, -270,  18.2050808, -250,  35.5255888, -240)
# change HI location, moving closer to lower 48 to make space for pacific islands 
c_usa56$HI<-c(  70.166605 , -240,  87.4871131, -250,  87.4871131, -270,  70.166605 , -280,  52.8460969, -270,  52.8460969, -250,  70.166605 , -240)



# usa59 - 50 states, DC, Territories (PR, VI, AS, GU, & MP) and freely associate states (FM, MH, PW) -----
# add FM, MH, PW-
c_usa59 <- c_usa56
# new position for PW - to the right of MP (-35 on x corrds, same y coords )
c_usa59$PW<-c(  0.5255888 , -240,  17.8460969, -250,  17.8460969, -270,   0.5255888, -280, -17.2050808, -270, -17.2050808, -250,   0.5255888, -240)
# new position for FM - two rows above GU (same x corrds, +60 to Y corrds)
c_usa59$FM<-c(  18.204981 , -210,  35.5254891, -220,  35.5254891, -240,  18.204981 , -250,   0.8844729, -240,   0.8844729, -220,  18.204981 , -210)
# new position for MH - two rows above AS (same x coords, +60 to Y corrds, same Y coords as PW)
c_usa59$MH<-c(  52.845997 , -210,  70.1665051, -220,  70.1665051, -240,  52.845997 , -250,  35.5254889, -240,  35.5254889, -220,  52.845997 , -210)



# usaETA- 50 states, DC, all outlying areas (territories) and Palau -----------
# Employment Training Administration geo's 
# https://www.dol.gov/agencies/eta/regions
c_usaETA <- c_usa56
# add Palau in Guam's spot 
c_usaETA$PW<-c(  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270)
# create new position to the left of original AS spot for new AS 
c_usaETA$AS<-c(  87.4871131, -270, 104.8075   , -280, 104.8075   , -300,  87.4871131, -310,  70.1665051, -300,  70.1665051, -280,  87.4871131, -270)
# put GU in old AS spot 
c_usaETA$GU<-c(  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270)


# Create coordinates for unified pacific islands for ETA regions 
c_unifiedPAislands <- c(
  35.5255888, -240, 52.8460969, -250, 70.166605 , -240, 87.4871131, -250, 87.4871131, -270, 104.8075   , -280, 104.8075   , -300, 
  87.4871131, -310, 70.1665051, -300, 52.845997 , -310, 35.5254889, -300, 18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  
  18.204981 , -270, 18.2050808, -270, 18.2050808, -250, 35.5255888, -240 
)


# Create sf hex data frame ######################################################


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


usa50  <- create_sf(c_usa50, geo_info)
usa51  <- create_sf(c_usa51, geo_info) 
usa52  <- create_sf(c_usa52, geo_info) 
usa53  <- create_sf(c_usa53, geo_info) 
usa56  <- create_sf(c_usa56, geo_info)
usa59  <- create_sf(c_usa59, geo_info)
usaETA <- create_sf(c_usaETA, geo_info_wioaeta)


# labels are not required; ggplot can automatically place labels in center of polygon
# creating the label df is a backup in case someone wants/needs it 
#' Create sf label data frame
#' 
#' @param hex_sf 
create_labels <- function(hex_sf){
  
  lab <- st_sf(hex_sf, geometry = st_centroid(hex_sf$geometry))
  
}


usa50_labels  <- create_labels(usa50)
usa51_labels  <- create_labels(usa51)
usa52_labels  <- create_labels(usa52)
usa53_labels  <- create_labels(usa53)
usa56_labels  <- create_labels(usa56)
usa59_labels  <- create_labels(usa59)
usaETA_labels <- create_labels(usaETA)


# ETAregions - combined hexagons for borders of ETA regions --------------------

gcol_ETAregions <- usaETA |>
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
gcol_ETAregions[6] <- sf::st_union(c(gcol_ETAregions[6], sf::st_geometry(make_hexagon(c_unifiedPAislands))))

ETAregions <- st_sf(wioa_eta_regions, geometry = gcol_ETAregions)

# create region labels  
ETAregions_labels <- create_labels(ETAregions)

# make adjustments to label location 
ETAregions_labels[1,]$geometry <- ETAregions_labels[1,]$geometry + c(-6, 25)
ETAregions_labels[2,]$geometry <- ETAregions_labels[2,]$geometry + c( 0,  4)
ETAregions_labels[3,]$geometry <- ETAregions_labels[3,]$geometry + c( 5,  0)
ETAregions_labels[4,]$geometry <- sf::st_geometry(sf::st_point(c(191.4102, -205)))
ETAregions_labels[5,]$geometry <- ETAregions_labels[5,]$geometry + c( 0,  5)
ETAregions_labels[6,]$geometry <- sf::st_geometry(sf::st_point(c(87.48711, -140)))



# EXPORT TO DATA FOLDER ########################################################

ut_overwrite <- TRUE 

usethis::use_data(usa50       , overwrite = ut_overwrite)
usethis::use_data(usa50_labels, overwrite = ut_overwrite)

usethis::use_data(usa51       , overwrite = ut_overwrite)
usethis::use_data(usa51_labels, overwrite = ut_overwrite)

usethis::use_data(usa52       , overwrite = ut_overwrite)
usethis::use_data(usa52_labels, overwrite = ut_overwrite)

usethis::use_data(usa53       , overwrite = ut_overwrite)
usethis::use_data(usa53_labels, overwrite = ut_overwrite)

usethis::use_data(usa56       , overwrite = ut_overwrite)
usethis::use_data(usa56_labels, overwrite = ut_overwrite)

usethis::use_data(usa59       , overwrite = ut_overwrite)
usethis::use_data(usa59_labels, overwrite = ut_overwrite)

usethis::use_data(usaETA       , overwrite = ut_overwrite)
usethis::use_data(usaETA_labels, overwrite = ut_overwrite)

usethis::use_data(ETAregions       , overwrite = ut_overwrite)
usethis::use_data(ETAregions_labels, overwrite = ut_overwrite)


# EXPORT ALL COORDINATES TO CSV FILE  ##########################################


create_csv_fortified_df <- function(sfobj, sfobj_labels){
  
  nm <-deparse(substitute(sfobj))

  # create dfs with info (remove geometry objects )
  info <- st_drop_geometry(sfobj) |> 
    # need to createa id for hexagons b/c multiple coordinates per geo 
    mutate(id = row_number() )
  info_labels <- st_drop_geometry(sfobj_labels) |> select(abbr_usps)
  
  # pull out coordinates into X, Y structure 
  hex_xy   <- st_coordinates(sfobj)        |> as_tibble() |> select(X, Y, id = L2)
  label_xy <- st_coordinates(sfobj_labels) |> as_tibble() |> select(cX = X, cY = Y) 
  
  
  # bind data frames together 
  df_hex <- full_join(info, hex_xy, by = "id") |> select(-id) 
  # labels, just cbind since there is 1 row for each geo 
  df_labels <- cbind(info_labels, label_xy) |> as_tibble()
  
  # join both df's together and add map label 
  df <- full_join(df_hex, df_labels, by = "abbr_usps", relationship = "many-to-one") |> 
    arrange(fips) |> 
    mutate(hexmap = nm, .before = 1)
  
  write_csv(df, file = file.path("data-raw", paste0(nm, ".csv")))
  
}


create_csv_fortified_df(usa50, usa50_labels)
create_csv_fortified_df(usa51, usa51_labels)
create_csv_fortified_df(usa52, usa52_labels)
create_csv_fortified_df(usa53, usa53_labels)
create_csv_fortified_df(usa56, usa56_labels)
create_csv_fortified_df(usa59, usa59_labels)
create_csv_fortified_df(usaETA, usaETA_labels)

# ggplot(df, aes(group=abbr_usps)) + 
#   geom_polygon(aes(x=X, y=Y), color = "white", fill = "grey35") + 
#   geom_text(data=distinct(df, abbr_usps, cX, cY), aes(label=abbr_usps, x = cX, y = cY), size = 3.25, color = "white") + 
#   coord_fixed() 



