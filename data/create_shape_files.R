
box::use(
    glue[glue]
  , magrittr[`%>%`]
  , dplyr[mutate, mutate_at, full_join, select, vars]
  , sf[st_polygon, st_sfc, st_sf, st_centroid, st_coordinates, write_sf]
  , tidyr[tribble, as_tibble]
  , forcats[fct_reorder]
  , readr[write_csv]
  )

#################################
#' Create geometry sf object when given 7 point coordinates
#'
#' @param VEC Double(14), vector of coordinates in the form of x1, y1, x2, y2, etc. 
#'
#' @return Polygon object, class(.) = c("XY", "POLYGON", "sfg")
#'
#' @examples
#' pol <- make_hex(c(6, 0, 3, 3*sqrt(3), -3, 3*sqrt(3), -6, 0, -3, -3*sqrt(3), 3, -3*sqrt(3), 6, 0))
#' plot(pol)
make_hex <-  function(VEC){
  geo <- st_polygon(list(matrix(VEC, ncol=2, byrow=TRUE)))
  return(geo)
}


#######################################
#' Create Data with names, abbreviations, etc. for geographies
#'  
#' @return A tibble (dataframe) that includes abbreviaitons (usps and gpo), names, other information 
create_data <- function(){
  # raw data 
  raw <- tribble(
   ~abb_usps,~abb_gpo,                      ~name, ~fips, ~eta_region, ~type
    , "AL", "Ala."   , "Alabama"                 ,  "01",           3, "state"
    , "AK", "Alaska" , "Alaska"                  ,  "02",           6, "state"
    , "AZ", "Ariz."  , "Arizona"                 ,  "04",           6, "state"
    , "AR", "Ark."   , "Arkansas"                ,  "05",           4, "state"
    , "CA", "Calif." , "California"              ,  "06",           6, "state"
    , "CO", "Colo."  , "Colorado"                ,  "08",           4, "state"
    , "CT", "Conn."  , "Connecticut"             ,  "09",           1, "state"
    , "DE", "Del."   , "Delaware"                ,  "10",           2, "state"
    , "DC", "D.C."   , "District of Columbia"    ,  "11",           2, "federal district"
    , "FL", "Fla."   , "Florida"                 ,  "12",           3, "state"
    , "GA", "Ga."    , "Georgia"                 ,  "13",           3, "state"
    , "HI", "Hawaii" , "Hawaii"                  ,  "15",           6, "state"
    , "ID", "Idaho"  , "Idaho"                   ,  "16",           6, "state"
    , "IL", "Ill."   , "Illinois"                ,  "17",           5, "state"
    , "IN", "Ind."   , "Indiana"                 ,  "18",           5, "state"
    , "IA", "Iowa"   , "Iowa"                    ,  "19",           5, "state"
    , "KS", "Kans."  , "Kansas"                  ,  "20",           5, "state"
    , "KY", "Ky."    , "Kentucky"                ,  "21",           3, "state"
    , "LA", "La."    , "Louisiana"               ,  "22",           4, "state"
    , "ME", "Maine"  , "Maine"                   ,  "23",           1, "state"
    , "MD", "Md."    , "Maryland"                ,  "24",           2, "state"
    , "MA", "Mass."  , "Massachusetts"           ,  "25",           1, "state"
    , "MI", "Mich."  , "Michigan"                ,  "26",           5, "state"
    , "MN", "Minn."  , "Minnesota"               ,  "27",           5, "state"
    , "MS", "Miss."  , "Mississippi"             ,  "28",           3, "state"
    , "MO", "Mo."    , "Missouri"                ,  "29",           5, "state"
    , "MT", "Mont."  , "Montana"                 ,  "30",           4, "state"
    , "NE", "Nebr."  , "Nebraska"                ,  "31",           5, "state"
    , "NV", "Nev."   , "Nevada"                  ,  "32",           6, "state"
    , "NH", "N.H."   , "New Hampshire"           ,  "33",           1, "state"
    , "NJ", "N.J."   , "New Jersey"              ,  "34",           1, "state"
    , "NM", "N. Mex.", "New Mexico"              ,  "35",           4, "state"
    , "NY", "N.Y."   , "New York"                ,  "36",           1, "state"
    , "NC", "N.C."   , "North Carolina"          ,  "37",           3, "state"
    , "ND", "N. Dak.", "North Dakota"            ,  "38",           4, "state"
    , "OH", "Ohio"   , "Ohio"                    ,  "39",           5, "state"
    , "OK", "Okla."  , "Oklahoma"                ,  "40",           4, "state"
    , "OR", "Oreg."  , "Oregon"                  ,  "41",           6, "state"
    , "PA", "Pa."    , "Pennsylvania"            ,  "42",           2, "state"
    , "RI", "R.I."   , "Rhode Island"            ,  "44",           1, "state"
    , "SC", "S.C."   , "South Carolina"          ,  "45",           3, "state"
    , "SD", "S. Dak.", "South Dakota"            ,  "46",           4, "state"
    , "TN", "Tenn."  , "Tennessee"               ,  "47",           3, "state"
    , "TX", "Tex."   , "Texas"                   ,  "48",           4, "state"
    , "UT", "Utah"   , "Utah"                    ,  "49",           4, "state"
    , "VT", "Vt."    , "Vermont"                 ,  "50",           1, "state"
    , "VA", "Va."    , "Virginia"                ,  "51",           2, "state"
    , "WA", "Wash."  , "Washington"              ,  "53",           6, "state"
    , "WV", "W. Va." , "West Virginia"           ,  "54",           2, "state"
    , "WI", "Wis."   , "Wisconsin"               ,  "55",           5, "state"
    , "WY", "Wyo."   , "Wyoming"                 ,  "56",           4, "state"
    , "AS", "A.S."   , "American Samoa"          ,  "60",           6, "outlying area" #under US sovereignty"
    , "GU", "Guam"   , "Guam"                    ,  "66",           6, "outlying area" #under US sovereignty"
    , "MP", "M.P."   , "Northern Mariana Islands",  "69",           6, "outlying area" #under US sovereignty"
    , "PR", "P.R."   , "Puerto Rico"             ,  "72",           1, "outlying area" #under US sovereignty"
    , "VI", "V.I."   , "Virgin Islands"          ,  "78",           1, "outlying area" #under US sovereignty"
    , "PW", "Palau"  , "Palau"                   ,  "70",           6, "freely associated state"
    ) 
   
  data <- raw %>% 
    #add id that matches column number (also used to create factor levels) 
    mutate(id = 1:nrow(raw), .before = abb_usps) %>% 
    #add factor levels based on id (so consistent accross abbreviations and names) 
    mutate_at(vars(abb_usps, abb_gpo, name), ~fct_reorder(., id)) %>%
    #add factors for type 
    mutate(type = factor(type, levels = unique(.$type))) %>% 
    #add in region data 
    dplyr::left_join(., select(create_rdata(), -id), by = "eta_region")
  
  return(data) 
  
} #end create_data


#######################################
#' Create Region Data 
#'  
#' @return A tibble (dataframe) 
create_rdata <- function(){
  # raw data 
  raw <- tribble( # https://www.dol.gov/agencies/eta/regions
    ~eta_region, ~eta_region_name, ~eta_region_city
    ,         1,       "Region 1", "Boston"
    ,         2,       "Region 2", "Philadelphia"
    ,         3,       "Region 3", "Atlanta"
    ,         4,       "Region 4", "Dallas" 
    ,         5,       "Region 5", "Chicago" 
    ,         6,       "Region 6", "San Francisco" 
  ) 
  
  data <- raw %>% 
    #add id that matches column number (also used to create factor levels) 
    mutate(id = eta_region) %>% 
    #add factor levels based on id (so consistent accross abbreviations and names) 
    mutate_at(vars(eta_region_name, eta_region_city), ~fct_reorder(., id)) 
  
  return(data) 
  
} #end create_data


#######################################
#' Create coordinates for hex map
#'
#' @return A list of each coordinates  
create_coord <- function(){
  
  ######
  ## 100 - States (including DC)
  # add 50 states and DC
  c100 <- list(
      AL = c( 278.012702 , -180, 295.33321  , -190, 295.33321  , -210, 278.012702 , -220, 260.692194 , -210, 260.692194 , -190, 278.012702 , -180)
    , AK = c(  35.5255888,    0,  52.8460969,  -10,  52.8460969,  -30,  35.5255888,  -40,  18.2050808,  -30,  18.2050808,  -10,  35.5255888,    0)
    , AZ = c( 139.448637 , -180, 156.769145 , -190, 156.769145 , -210, 139.448637 , -220, 122.128129 , -210, 122.128129 , -190, 139.448637 , -180)
    , AR = c( 226.051178 , -150, 243.371686 , -160, 243.371686 , -180, 226.051178 , -190, 208.73067  , -180, 208.73067  , -160, 226.051178 , -150)
    , CA = c(  87.4871131, -150, 104.807621 , -160, 104.807621 , -180,  87.4871131, -190,  70.166605 , -180,  70.166605 , -160,  87.4871131, -150)
    , CO = c( 139.448637 , -120, 156.769145 , -130, 156.769145 , -150, 139.448637 , -160, 122.128129 , -150, 122.128129 , -130, 139.448637 , -120)
    , CT = c( 399.256258 ,  -90, 416.576766 , -100, 416.576766 , -120, 399.256258 , -130, 381.93575  , -120, 381.93575  , -100, 399.256258 ,  -90)
    , DE = c( 381.93575  , -120, 399.256258 , -130, 399.256258 , -150, 381.93575  , -160, 364.615242 , -150, 364.615242 , -130, 381.93575  , -120)
    , DC = c( 364.615242 , -150, 381.93575  , -160, 381.93575  , -180, 364.615242 , -190, 347.294734 , -180, 347.294734 , -160, 364.615242 , -150)
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
  
  ######
  ## 120 - States + Territories/Outlying Areas 
  # add territories/outlying areas 
  c120 <- c100
  c120$AS<-c(  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270)
  c120$GU<-c(  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270)
  c120$MP<-c( 35.5255888 , -240,  52.8460969, -250,  52.8460969, -270,  35.5255888, -280,  18.2050808, -270,  18.2050808, -250,  35.5255888, -240)
  c120$PR<-c( 381.93575  , -240, 399.256258 , -250, 399.256258 , -270, 381.93575  , -280, 364.615242 , -270, 364.615242 , -250, 381.93575  , -240)
  c120$VI<-c( 416.576766 , -240, 433.897275 , -250, 433.897275 , -270, 416.576766 , -280, 399.256258 , -270, 399.256258 , -250, 416.576766 , -240)
  # change HI location, moving closer to lower 48 to make space for pacific islands 
  c120$HI<-c(  70.166605 , -240,  87.4871131, -250,  87.4871131, -270,  70.166605 , -280,  52.8460969, -270,  52.8460969, -250,  70.166605 , -240)
  
  ######
  ## 123 - States + Territories/Outlying Areas + Palau
  # add Palau in Guam's spot 
  c123 <- c120
  c123$PW<-c(  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270)
  # create new position to the left for AS 
  c123$AS<-c(  87.4871131, -270, 104.8075   , -280, 104.8075   , -300,  87.4871131, -310,  70.1665051, -300,  70.1665051, -280,  87.4871131, -270)
  # put GU in old AS spot 
  c123$GU<-c(  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270)
  
  coord_lst <- list("states"= c100, "states_outlyingareas" = c120, "wioa_eta" = c123)
  return(coord_lst)

} #end create_coord


#######################################
#' Create coordinates for unified pacific islands 
#'
#' @return A coordinates 
create_pacislands <- function(){
  pacislands <-  c(
    35.5255888, -240, 52.8460969, -250, 70.166605 , -240, 87.4871131, -250, 87.4871131, -270, 104.8075   , -280, 104.8075   , -300, 
    87.4871131, -310, 70.1665051, -300, 52.845997 , -310, 35.5254889, -300, 18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  
    18.204981 , -270, 18.2050808, -270, 18.2050808, -250, 35.5255888, -240 
  )
  return(pacislands)
}


#######################################
#' Create sf hex data frame
#'
#' @param hex_lst A list of each coordinates for hex map 
#'
#' @return A list of each sf hex data.frame 
#'
#' @examples
#' create_hex(coord_lst)
create_hex <- function(coord_lst){
  
  l              <- length(coord_lst)
  hex_lst        <- vector(mode='list', length=l)
  names(hex_lst) <- names(coord_lst)
  
  for (i in 1:l){
    coord <- coord_lst[[i]]
    gdat  <- data[which(data$abb_usps %in% names(coord)),]
    glst  <- lapply(coord, make_hex)
    gcol  <- st_sfc(glst[gdat$abb_usps])
    hex   <- st_sf(gdat[order(gdat$abb_usps),], geometry = gcol) 
    hex_lst[[i]] <- hex
  } #end for loop
  
  gdat_r <- rdata
  gcol_r <- hex_lst$wioa_eta  %>% 
    dplyr::filter(!abb_usps %in% c("MP", "HI", "PW", "GU", "AS")) %>% 
    dplyr::group_by(eta_region) %>% 
    dplyr::summarize(geometry = sf::st_union(geometry, is_coverage = TRUE)) %>%
    dplyr::arrange(eta_region) %>% 
    dplyr::pull(geometry) %>% 
    st_sfc()
  #add pacific islands 
  gcol_r[6] <- sf::st_union(c(gcol_r[6], sf::st_geometry(make_hex(create_pacislands() ) ) ) ) 
  hex_r <- st_sf(gdat_r, geometry = gcol_r)
  
  hex_lst[[l+1]] <- hex_r
  names(hex_lst)[l+1] <- "wioa_regions"
  
  return(hex_lst)
} #end create_hex


#######################################
#' Create sf label data frame
#'
#' @param hex_lst A list of each sf hex data.frame 
#'
#' @return A list of each sf label data.frame 
#'
#' @examples
#' create_lab(hex_lst)
create_lab <- function(hex_lst){
  
  l              <- length(hex_lst)
  lab_lst        <- vector(mode='list', length=l)
  names(lab_lst) <- names(hex_lst)
  
  for (i in 1:l){
    hex <- hex_lst[[i]]
    lab <- st_sf(hex, geometry = st_centroid(hex$geometry))
    lab_lst[[i]] <- lab
  } #end for loop
  
  #adjustment to wioa regions labels 
  lab_lst$wioa_regions[1,]$geometry <- lab_lst$wioa_regions[1,]$geometry + c(-6, 25)
  lab_lst$wioa_regions[2,]$geometry <- lab_lst$wioa_regions[2,]$geometry + c( 0,  4)
  lab_lst$wioa_regions[3,]$geometry <- lab_lst$wioa_regions[3,]$geometry + c( 5,  0)
  lab_lst$wioa_regions[4,]$geometry <- sf::st_geometry(sf::st_point(c(191.4102, -205)))
  lab_lst$wioa_regions[5,]$geometry <- lab_lst$wioa_regions[5,]$geometry + c( 0,  5)
  lab_lst$wioa_regions[6,]$geometry <- sf::st_geometry(sf::st_point(c(87.48711, -140)))
  
  return(lab_lst)
} #end create_lab



#######################################
#' Create fortified hex data frame
#'
#' @param hex_lst A list of each sf hex data.frame 
#'
#' @return A list of each fortified hex data.frame 
#'
#' @examples
#' create_fhex(hex_lst)
create_fhex <- function(hex_lst){
  
  reg_n           <- which(names(hex_lst) == "wioa_regions")
  l               <- length(hex_lst[-reg_n])
  fhex_lst        <- vector(mode='list', length=l+1)
  names(fhex_lst) <- c(names(hex_lst[-reg_n]), names(hex_lst[reg_n]))
  
  for (i in 1:l){
    hex  <- hex_lst[[i]]
    fdat <- select(as_tibble(hex), -geometry) 
    fcor <- st_coordinates(hex) %>% as_tibble() %>% mutate(id = L2) %>% select(-c(L1, L2))
    fhex <- full_join(fdat, fcor, by = "id")
    fhex_lst[[i]] <- fhex
  } #end for loop
  
  ## special case for regions fortified hex map (because multipolygon & polygon )
  one <- hex_lst$wioa_regions[1,] %>% st_coordinates() %>%
    as_tibble() %>%
    mutate(id = 1) %>%
    dplyr::rename(group = L2) %>%
    select(X, Y, id, group)
  
  two <- hex_lst$wioa_regions[2:5,] %>% st_coordinates() %>%
    as_tibble() %>%
    mutate(id = L2+1, group=L2+2) %>%
    select(X, Y, id, group)
  
  three <- hex_lst$wioa_regions[6,] %>% st_coordinates() %>%
    as_tibble() %>%
    mutate(id = 6, group = L2 + 6) %>%
    select(X, Y, id, group)
  
  fhex <- dplyr::bind_rows(one, two, three) %>% 
    dplyr::left_join(., rdata, by = "id")
  
  fhex_lst[[l+1]] <- fhex
  
  return(fhex_lst)
} #end create_fhex 


#######################################
#' Create fortified label data frame
#'
#' @param lab_lst A list of each sf labels data.frame 
#'
#' @return A list of each fortified labels data.frame 
#'
#' @examples
#' create_flab(lab_lst)
create_flab <- function(lab_lst){
  
  l               <- length(lab_lst)
  flab_lst        <- vector(mode='list', length=l)
  names(flab_lst) <- names(lab_lst)
  
  for (i in 1:l){
    lab  <- lab_lst[[i]]
    fdat <- select(as_tibble(lab), -geometry)  
    fcor <- st_coordinates(lab) %>% as_tibble() %>% mutate(id = 1:nrow(.))
    flab <- full_join(fdat, fcor, by = "id")
    flab_lst[[i]] <- flab
  } #end for loop
  
  return(flab_lst)

} #end create_flab


#######################################
#' Save shp file as RDS and shape file dbf/shp/shx
#'
#' @param lst   List() A list of each sf  data.frame 
#' @param label Logical(1) TRUE = labels shape; FALSE = hex shape
#'
#' @return Nothing, saves files 
#'
#' @examples
#' save_shp(hex_lst)
#' save_shp(lab_lst, label = TRUE)
save_shp <- function(lst, label = FALSE){
  
  l <- length(lst)                              #number of items in list 
  suffix <- ifelse(label == TRUE, "_labels", "") #create suffix of saved name objects
  
  for (i in 1:l){
    shp  <- lst[[i]]       
    name <- names(lst)[i] 
    saveRDS( shp, glue("data/{name}/1_rds/{name}{suffix}.RDS"))
    write_sf(shp, glue("data/{name}/2_shp/{name}{suffix}.shp"))
    logger::log_success("saved {name}{suffix} shape files")
  } #end for loop
  
} #end save_hex


#######################################
#' Save fortified file as csv
#'
#' @param lst   List() A list of each fortified data.frame 
#' @param label Logical(1) TRUE = labels shape; FALSE = hex shape
#'
#' @return Nothing, saves files 
#'
#' @examples
#' save_fort(fhex_lst)
#' save_fort(flab_lst, label = TRUE)
save_fort <- function(flst, label = FALSE){
  
  l <- length(flst)                              #number of items in list 
  suffix <- ifelse(label == TRUE, "_labels", "") #create suffix of saved name objects
  
  for (i in 1:l){
    fort <- flst[[i]]       
    name <- names(flst)[i] 
    write_csv(fort, glue("data/{name}/3_csv/{name}{suffix}.csv"))
    logger::log_success("saved {name}{suffix} fortified file")
  } #end for loop
  
} #end save_hex




#######################################
#' build and save all data files 
#'
  
  data      <- create_data()
  rdata     <- create_rdata()
  coord_lst <- create_coord()

  hex_lst  <- create_hex(coord_lst)
  lab_lst  <- create_lab(hex_lst)

  fhex_lst <- create_fhex(hex_lst)
  flab_lst <- create_flab(lab_lst)

  save_shp(hex_lst)
  save_shp(lab_lst, label = TRUE)

  save_fort(fhex_lst)
  save_fort(flab_lst, label = TRUE)
  
  

