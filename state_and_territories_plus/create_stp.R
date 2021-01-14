####### HEX MAP THAT INCLUDES TERRITORIES 
####### CREATE .SHP/.CSV files THAT CAN BE USED TO CREATE HEX MAP

######################
#required packages 

library(sp) # SpatialPolygons(); SpatialPolygonsDataFrame();  Polygon(); 
  #used to create and edit polygon shape files 
library(rgeos) #gCentroid() 
  #calculate center of polygons (for labeling)
library(broom) #tidy() 
  #to move from spatial to 'regular' dataframe 
library(tibble) #tribble() 
  #I like how I can create tibbles using tribble() (easier for me to check data)
  #sometimes easier to convert tibble to base R data frame 
library(dplyr) #left_join() 
library(readr) #write_csv()
library(raster) #shapefile() 
  #used for writing data to shape file


###########################
# create Spatial Polygons list with coordinates  

# https://github.com/nprapps/dailygraphics-templates/blob/master/state_grid_map/index.html
# polygon location taken from NPR graphic's team 
#y values are reversed (i.e. NPR = 10; mine = -10); if don't reverse map will be upside down 

spdf <- SpatialPolygons(list(
    Polygons(list(Polygon(tribble( ~x, ~y, 278.012702 , -180, 295.33321  , -190, 295.33321  , -210, 278.012702 , -220, 260.692194 , -210, 260.692194 , -190, 278.012702 , -180))), ID = "AL")
  , Polygons(list(Polygon(tribble( ~x, ~y,  35.5255888,    0,  52.8460969,  -10,  52.8460969,  -30,  35.5255888,  -40,  18.2050808,  -30,  18.2050808,  -10,  35.5255888,    0))), ID = "AK")
  , Polygons(list(Polygon(tribble( ~x, ~y, 139.448637 , -180, 156.769145 , -190, 156.769145 , -210, 139.448637 , -220, 122.128129 , -210, 122.128129 , -190, 139.448637 , -180))), ID = "AZ")
  , Polygons(list(Polygon(tribble( ~x, ~y, 226.051178 , -150, 243.371686 , -160, 243.371686 , -180, 226.051178 , -190, 208.73067  , -180, 208.73067  , -160, 226.051178 , -150))), ID = "AR")
  , Polygons(list(Polygon(tribble( ~x, ~y,  87.4871131, -150, 104.807621 , -160, 104.807621 , -180,  87.4871131, -190,  70.166605 , -180,  70.166605 , -160,  87.4871131, -150))), ID = "CA")
  , Polygons(list(Polygon(tribble( ~x, ~y, 139.448637 , -120, 156.769145 , -130, 156.769145 , -150, 139.448637 , -160, 122.128129 , -150, 122.128129 , -130, 139.448637 , -120))), ID = "CO")
  , Polygons(list(Polygon(tribble( ~x, ~y, 399.256258 ,  -90, 416.576766 , -100, 416.576766 , -120, 399.256258 , -130, 381.93575  , -120, 381.93575  , -100, 399.256258 ,  -90))), ID = "CT")
  , Polygons(list(Polygon(tribble( ~x, ~y, 381.93575  , -120, 399.256258 , -130, 399.256258 , -150, 381.93575  , -160, 364.615242 , -150, 364.615242 , -130, 381.93575  , -120))), ID = "DE")
  , Polygons(list(Polygon(tribble( ~x, ~y, 364.615242 , -150, 381.93575  , -160, 381.93575  , -180, 364.615242 , -190, 347.294734 , -180, 347.294734 , -160, 364.615242 , -150))), ID = "DC")
  , Polygons(list(Polygon(tribble( ~x, ~y, 295.33321  , -210, 312.653718 , -220, 312.653718 , -240, 295.33321  , -250, 278.012702 , -240, 278.012702 , -220, 295.33321  , -210))), ID = "FL")
  , Polygons(list(Polygon(tribble( ~x, ~y, 312.653718 , -180, 329.974226 , -190, 329.974226 , -210, 312.653718 , -220, 295.33321  , -210, 295.33321  , -190, 312.653718 , -180))), ID = "GA")
  , Polygons(list(Polygon(tribble( ~x, ~y,  70.166605 , -240,  87.4871131, -250,  87.4871131, -270,  70.166605 , -280,  52.8460969, -270,  52.8460969, -250,  70.166605 , -240))), ID = "HI")
  , Polygons(list(Polygon(tribble( ~x, ~y,  87.4871131,  -90, 104.807621 , -100, 104.807621 , -120,  87.4871131, -130,  70.166605 , -120,  70.166605 , -100,  87.4871131,  -90))), ID = "ID")
  , Polygons(list(Polygon(tribble( ~x, ~y, 226.051178 ,  -90, 243.371686 , -100, 243.371686 , -120, 226.051178 , -130, 208.73067  , -120, 208.73067  , -100, 226.051178 ,  -90))), ID = "IL")
  , Polygons(list(Polygon(tribble( ~x, ~y, 260.692194 ,  -90, 278.012702 , -100, 278.012702 , -120, 260.692194 , -130, 243.371686 , -120, 243.371686 , -100, 260.692194 ,  -90))), ID = "IN")
  , Polygons(list(Polygon(tribble( ~x, ~y, 191.410162 ,  -90, 208.73067  , -100, 208.73067  , -120, 191.410162 , -130, 174.089653 , -120, 174.089653 , -100, 191.410162 ,  -90))), ID = "IA")
  , Polygons(list(Polygon(tribble( ~x, ~y, 191.410162 , -150, 208.73067  , -160, 208.73067  , -180, 191.410162 , -190, 174.089653 , -180, 174.089653 , -160, 191.410162 , -150))), ID = "KS")
  , Polygons(list(Polygon(tribble( ~x, ~y, 243.371686 , -120, 260.692194 , -130, 260.692194 , -150, 243.371686 , -160, 226.051178 , -150, 226.051178 , -130, 243.371686 , -120))), ID = "KY")
  , Polygons(list(Polygon(tribble( ~x, ~y, 208.73067  , -180, 226.051178 , -190, 226.051178 , -210, 208.73067  , -220, 191.410162 , -210, 191.410162 , -190, 208.73067  , -180))), ID = "LA")
  , Polygons(list(Polygon(tribble( ~x, ~y, 416.576766 ,    0, 433.897275 ,  -10, 433.897275 ,  -30, 416.576766 ,  -40, 399.256258 ,  -30, 399.256258 ,  -10, 416.576766 ,    0))), ID = "ME")
  , Polygons(list(Polygon(tribble( ~x, ~y, 347.294734 , -120, 364.615242 , -130, 364.615242 , -150, 347.294734 , -160, 329.974226 , -150, 329.974226 , -130, 347.294734 , -120))), ID = "MD")
  , Polygons(list(Polygon(tribble( ~x, ~y, 381.93575  ,  -60, 399.256258 ,  -70, 399.256258 ,  -90, 381.93575  , -100, 364.615242 ,  -90, 364.615242 ,  -70, 381.93575  ,  -60))), ID = "MA")
  , Polygons(list(Polygon(tribble( ~x, ~y, 278.012702 ,  -60, 295.33321  ,  -70, 295.33321  ,  -90, 278.012702 , -100, 260.692194 ,  -90, 260.692194 ,  -70, 278.012702 ,  -60))), ID = "MI")
  , Polygons(list(Polygon(tribble( ~x, ~y, 174.089653 ,  -60, 191.410162 ,  -70, 191.410162 ,  -90, 174.089653 , -100, 156.769145 ,  -90, 156.769145 ,  -70, 174.089653 ,  -60))), ID = "MN")
  , Polygons(list(Polygon(tribble( ~x, ~y, 243.371686 , -180, 260.692194 , -190, 260.692194 , -210, 243.371686 , -220, 226.051178 , -210, 226.051178 , -190, 243.371686 , -180))), ID = "MS")
  , Polygons(list(Polygon(tribble( ~x, ~y, 208.73067  , -120, 226.051178 , -130, 226.051178 , -150, 208.73067  , -160, 191.410162 , -150, 191.410162 , -130, 208.73067  , -120))), ID = "MO")
  , Polygons(list(Polygon(tribble( ~x, ~y, 104.807621 ,  -60, 122.128129 ,  -70, 122.128129 ,  -90, 104.807621 , -100,  87.4871131,  -90,  87.4871131,  -70, 104.807621 ,  -60))), ID = "MT")
  , Polygons(list(Polygon(tribble( ~x, ~y, 174.089653 , -120, 191.410162 , -130, 191.410162 , -150, 174.089653 , -160, 156.769145 , -150, 156.769145 , -130, 174.089653 , -120))), ID = "NE")
  , Polygons(list(Polygon(tribble( ~x, ~y, 104.807621 , -120, 122.128129 , -130, 122.128129 , -150, 104.807621 , -160,  87.4871131, -150,  87.4871131, -130, 104.807621 , -120))), ID = "NV")
  , Polygons(list(Polygon(tribble( ~x, ~y, 399.256258 ,  -30, 416.576766 ,  -40, 416.576766 ,  -60, 399.256258 ,  -70, 381.93575  ,  -60, 381.93575  ,  -40, 399.256258 ,  -30))), ID = "NH")
  , Polygons(list(Polygon(tribble( ~x, ~y, 364.615242 ,  -90, 381.93575  , -100, 381.93575  , -120, 364.615242 , -130, 347.294734 , -120, 347.294734 , -100, 364.615242 ,  -90))), ID = "NJ")
  , Polygons(list(Polygon(tribble( ~x, ~y, 156.769145 , -150, 174.089653 , -160, 174.089653 , -180, 156.769145 , -190, 139.448637 , -180, 139.448637 , -160, 156.769145 , -150))), ID = "NM")
  , Polygons(list(Polygon(tribble( ~x, ~y, 347.294734 ,  -60, 364.615242 ,  -70, 364.615242 ,  -90, 347.294734 , -100, 329.974226 ,  -90, 329.974226 ,  -70, 347.294734 ,  -60))), ID = "NY")
  , Polygons(list(Polygon(tribble( ~x, ~y, 295.33321  , -150, 312.653718 , -160, 312.653718 , -180, 295.33321  , -190, 278.012702 , -180, 278.012702 , -160, 295.33321  , -150))), ID = "NC")
  , Polygons(list(Polygon(tribble( ~x, ~y, 139.448637 ,  -60, 156.769145 ,  -70, 156.769145 ,  -90, 139.448637 , -100, 122.128129 ,  -90, 122.128129 ,  -70, 139.448637 ,  -60))), ID = "ND")
  , Polygons(list(Polygon(tribble( ~x, ~y, 35.5255888 , -240,  52.8460969, -250,  52.8460969, -270,  35.5255888, -280,  18.2050808, -270,  18.2050808, -250,  35.5255888, -240))), ID = "MP")
  , Polygons(list(Polygon(tribble( ~x, ~y, 295.33321  ,  -90, 312.653718 , -100, 312.653718 , -120, 295.33321  , -130, 278.012702 , -120, 278.012702 , -100, 295.33321  ,  -90))), ID = "OH")
  , Polygons(list(Polygon(tribble( ~x, ~y, 174.089653 , -180, 191.410162 , -190, 191.410162 , -210, 174.089653 , -220, 156.769145 , -210, 156.769145 , -190, 174.089653 , -180))), ID = "OK")
  , Polygons(list(Polygon(tribble( ~x, ~y,  70.166605 , -120,  87.4871131, -130,  87.4871131, -150,  70.166605 , -160,  52.8460969, -150,  52.8460969, -130,  70.166605 , -120))), ID = "OR")
  , Polygons(list(Polygon(tribble( ~x, ~y, 329.974226 ,  -90, 347.294734 , -100, 347.294734 , -120, 329.974226 , -130, 312.653718 , -120, 312.653718 , -100, 329.974226 ,  -90))), ID = "PA")
  , Polygons(list(Polygon(tribble( ~x, ~y, 381.93575  , -240, 399.256258 , -250, 399.256258 , -270, 381.93575  , -280, 364.615242 , -270, 364.615242 , -250, 381.93575  , -240))), ID = "PR")
  , Polygons(list(Polygon(tribble( ~x, ~y, 416.576766 ,  -60, 433.897275 ,  -70, 433.897275 ,  -90, 416.576766 , -100, 399.256258 ,  -90, 399.256258 ,  -70, 416.576766 ,  -60))), ID = "RI")
  , Polygons(list(Polygon(tribble( ~x, ~y, 329.974226 , -150, 347.294734 , -160, 347.294734 , -180, 329.974226 , -190, 312.653718 , -180, 312.653718 , -160, 329.974226 , -150))), ID = "SC")
  , Polygons(list(Polygon(tribble( ~x, ~y, 156.769145 ,  -90, 174.089653 , -100, 174.089653 , -120, 156.769145 , -130, 139.448637 , -120, 139.448637 , -100, 156.769145 ,  -90))), ID = "SD")
  , Polygons(list(Polygon(tribble( ~x, ~y, 260.692194 , -150, 278.012702 , -160, 278.012702 , -180, 260.692194 , -190, 243.371686 , -180, 243.371686 , -160, 260.692194 , -150))), ID = "TN")
  , Polygons(list(Polygon(tribble( ~x, ~y, 191.410162 , -210, 208.73067  , -220, 208.73067  , -240, 191.410162 , -250, 174.089653 , -240, 174.089653 , -220, 191.410162 , -210))), ID = "TX")
  , Polygons(list(Polygon(tribble( ~x, ~y, 416.576766 , -240, 433.897275 , -250, 433.897275 , -270, 416.576766 , -280, 399.256258 , -270, 399.256258 , -250, 416.576766 , -240))), ID = "VI")
  , Polygons(list(Polygon(tribble( ~x, ~y, 122.128129 , -150, 139.448637 , -160, 139.448637 , -180, 122.128129 , -190, 104.807621 , -180, 104.807621 , -160, 122.128129 , -150))), ID = "UT")
  , Polygons(list(Polygon(tribble( ~x, ~y, 364.615242 ,  -30, 381.93575  ,  -40, 381.93575  ,  -60, 364.615242 ,  -70, 347.294734 ,  -60, 347.294734 ,  -40, 364.615242 ,  -30))), ID = "VT")
  , Polygons(list(Polygon(tribble( ~x, ~y, 312.653718 , -120, 329.974226 , -130, 329.974226 , -150, 312.653718 , -160, 295.33321  , -150, 295.33321  , -130, 312.653718 , -120))), ID = "VA")
  , Polygons(list(Polygon(tribble( ~x, ~y,  70.166605 ,  -60,  87.4871131,  -70,  87.4871131,  -90,  70.166605 , -100,  52.8460969,  -90,  52.8460969,  -70,  70.166605 ,  -60))), ID = "WA")
  , Polygons(list(Polygon(tribble( ~x, ~y, 278.012702 , -120, 295.33321  , -130, 295.33321  , -150, 278.012702 , -160, 260.692194 , -150, 260.692194 , -130, 278.012702 , -120))), ID = "WV")
  , Polygons(list(Polygon(tribble( ~x, ~y, 208.73067  ,  -60, 226.051178 ,  -70, 226.051178 ,  -90, 208.73067  , -100, 191.410162 ,  -90, 191.410162 ,  -70, 208.73067  ,  -60))), ID = "WI")
  , Polygons(list(Polygon(tribble( ~x, ~y, 122.128129 ,  -90, 139.448637 , -100, 139.448637 , -120, 122.128129 , -130, 104.807621 , -120, 104.807621 , -100, 122.128129 ,  -90))), ID = "WY")
  # ADDITIONS AND CHANGES 
  # create new position for AS
  , Polygons(list(Polygon(tribble( ~x, ~y,  87.4871131, -270, 104.8075   , -280, 104.8075   , -300,  87.4871131, -310,  70.1665051, -300,  70.1665051, -280,  87.4871131, -270))), ID = "AS")
  # put GU in old AS spot 
  , Polygons(list(Polygon(tribble( ~x, ~y,  52.845997 , -270,  70.1665051, -280,  70.1665051, -300,  52.845997 , -310,  35.5254889, -300,  35.5254889, -280,  52.845997 , -270))), ID = "GU")
  # put PW in old GU spot 
  , Polygons(list(Polygon(tribble( ~x, ~y,  18.204981 , -270,  35.5254891, -280,  35.5254891, -300,  18.204981 , -310,   0.8844729, -300,   0.8844729, -280,  18.204981 , -270))), ID = "PW")
  ))


#########################
#add additional data 

#abbreviations: https://en.wikipedia.org/wiki/List_of_U.S._state_and_territory_abbreviations
# id's = USPS abbrevaitions

data <- as.data.frame(tribble(
      ~id,  ~abb_gpo,                      ~name, ~type
   , "AL", "Ala."   , "Alabama"                 , "state"
   , "AK", "Alaska" , "Alaska"                  , "state"
   , "AZ", "Ariz."  , "Arizona"                 , "state"
   , "AR", "Ark."   , "Arkansas"                , "state"
   , "CA", "Calif." , "California"              , "state"
   , "CO", "Colo."  , "Colorado"                , "state"
   , "CT", "Conn."  , "Connecticut"             , "state"
   , "DE", "Del."   , "Delaware"                , "state"
   , "DC", "D.C."   , "District of Columbia"    , "federal district"
   , "FL", "Fla."   , "Florida"                 , "state"
   , "GA", "Ga."    , "Georgia"                 , "state"
   , "HI", "Hawaii" , "Hawaii"                  , "state"
   , "ID", "Idaho"  , "Idaho"                   , "state"
   , "IL", "Ill."   , "Illinois"                , "state"
   , "IN", "Ind."   , "Indiana"                 , "state"
   , "IA", "Iowa"   , "Iowa"                    , "state"
   , "KS", "Kans."  , "Kansas"                  , "state"
   , "KY", "Ky."    , "Kentucky"                , "state"
   , "LA", "La."    , "Louisiana"               , "state"
   , "ME", "Maine"  , "Maine"                   , "state"
   , "MD", "Md."    , "Maryland"                , "state"
   , "MA", "Mass."  , "Massachusetts"           , "state"
   , "MI", "Mich."  , "Michigan"                , "state"
   , "MN", "Minn."  , "Minnesota"               , "state"
   , "MS", "Miss."  , "Mississippi"             , "state"
   , "MO", "Mo."    , "Missouri"                , "state"
   , "MT", "Mont."  , "Montana"                 , "state"
   , "NE", "Nebr."  , "Nebraska"                , "state"
   , "NV", "Nev."   , "Nevada"                  , "state"
   , "NH", "N.H."   , "New Hampshire"           , "state"
   , "NJ", "N.J."   , "New Jersey"              , "state"
   , "NM", "N. Mex.", "New Mexico"              , "state"
   , "NY", "N.Y."   , "New York"                , "state"
   , "NC", "N.C."   , "North Carolina"          , "state"
   , "ND", "N. Dak.", "North Dakota"            , "state"
   , "OH", "Ohio"   , "Ohio"                    , "state"
   , "OK", "Okla."  , "Oklahoma"                , "state"
   , "OR", "Oreg."  , "Oregon"                  , "state"
   , "PA", "Pa."    , "Pennsylvania"            , "state"
   , "RI", "R.I."   , "Rhode Island"            , "state"
   , "SC", "S.C."   , "South Carolina"          , "state"
   , "SD", "S. Dak.", "South Dakota"            , "state"
   , "TN", "Tenn."  , "Tennessee"               , "state"
   , "TX", "Tex."   , "Texas"                   , "state"
   , "UT", "Utah"   , "Utah"                    , "state"
   , "VT", "Vt."    , "Vermont"                 , "state"
   , "VA", "Va."    , "Virginia"                , "state"
   , "WA", "Wash."  , "Washington"              , "state"
   , "WV", "W. Va." , "West Virginia"           , "state"
   , "WI", "Wis."   , "Wisconsin"               , "state"
   , "WY", "Wyo."   , "Wyoming"                 , "state"
   , "AS", "A.S."   , "American Samoa"          , "territory"
   , "GU", "Guam"   , "Guam"                    , "territory"
   , "MP", "M.P."   , "Northern Mariana Islands", "territory"
   , "PR", "P.R."   , "Puerto Rico"             , "territory"
   , "VI", "V.I."   , "Virgin Islands"          , "territory"
### ADDED
   , "PW", "Palau"  , "Palau"                   , "territory"
))

#rowname of data df need to match ID's from SpatialPolygons() function (required for matching )
rownames(data) <- data$id

#add to sp file
spdf <- SpatialPolygonsDataFrame(spdf, data = data, match.ID = TRUE)


######################
#write shapefile
shapefile(spdf, "state_and_territories_plus/hex_file/usa_stp.shp", overwrite = TRUE)


######################
#calculate centers of polygons (for labels) 
centers <- cbind.data.frame(rgeos::gCentroid(spdf, byid = TRUE), id = spdf@data$id)

#add other data to centers 
centers <- left_join(centers, data, by = "id")

#export
write_csv(centers, "state_and_territories_plus/hex_file/usa_stp_centers.csv")

#########################
#fortify spdf data (make it a 'dataframe' rather than a 'sp' list)
#lose spdf@data when using broom::tidy() function so add back in by joining data frames 
spdf_fort <- left_join(tidy(spdf), data.frame(spdf@data), by = "id")

#export
write_csv(spdf_fort, "state_and_territories_plus/hex_file/usa_stp_fort.csv")

