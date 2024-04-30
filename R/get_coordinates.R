


#' Import hex map coordinates
#'
#' @param map A \code{character} string specifying which map. 
#'   Current options are 
#'   `"states50"` (50 US States only), 
#'   `"statesDC"` (50 states and DC), 
#'   `"statesTerr"` (50 states, DC, Puerto Rico, Virgin Islands, Guam, 
#'   American Samoa, and Marshall Islands), 
#'   `"WIOAETA"` (WIOA ETA geographies, same as statesTerr with the addition 
#'   of Palau), and 
#'   `"WIOAETARegions"` (unified maps of WIOA ETA regions) .
#'   
#' @param coords A \code{character} string specifying `"hexmap"` for the 
#'   hexagon coordinates or `"labels"` for the label coordinates for the hex map
#'
#' @export
#' 
#' @return sf object for map, either the hexagons (polygon) or labels (point).  
#' 
#' @examples
#' get_coordinates(map = "states50", coords = "hexmap")
#' get_coordinates(map = "states50", coords = "labels")
get_coordinates <- function(map, coords = "hexmap"){
  
  if (coords == "hexmap"){
    
    if (map == "states50"){       usahex::states50 
    } else if (map == "statesDC"){       usahex::statesDC
    } else if (map == "statesTerr"){     usahex::statesTerr
    } else if (map == "WIOAETA"){        usahex::WIOAETA
    } else if (map == "WIOAETAregions"){ usahex::WIOAETAregions
    } else { stop("Invalid 'map' argument, current options are:", 
                  "states50", "statesDC", "statesTerr", "WIOAETA", 
                  "WIOAETARegions") }
    
  } else if (coords == "labels"){
    
           if (map == "states50"){       usahex::states50_labels 
    } else if (map == "statesDC"){       usahex::statesDC_labels
    } else if (map == "statesTerr"){     usahex::statesTerr_labels
    } else if (map == "WIOAETA"){        usahex::WIOAETA_labels
    } else if (map == "WIOAETAregions"){ usahex::WIOAETAregions_labels
    } else { stop("Invalid 'map' argument, current options are:", 
                  "states50", "statesDC", "statesTerr", "WIOAETA", 
                  "WIOAETARegions") }
    
  } else {
    stop("Invalid 'coords' argument, options are:", 
         "hexmap or labels")
  }
  

  
  
  
}