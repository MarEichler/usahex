


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
#' @import sf
#'
#' @export
#' 
#' @return sf object for map, either the hexagons (polygon) or labels (point).  
#' 
#' @examples
#' get_coordinates(map = "states50", coords = "hexmap")
#' get_coordinates(map = "states50", coords = "labels")
get_coordinates <- function(map = NULL, coords = "hexmap"){
  
  
  stopifnot("Enter 'map' argument" = !is.null(map))
  stopifnot("Invlaid 'map' argument" = map %in% c("states50", "statesDC", 
                                                  "statesTerr", "WIOAETA", 
                                                  "WIOAETAregions"))
  stopifnot("Invalid 'coords' argument, options are 'hexmap' or 'labels'" = 
              coords %in% c("hexmap", "labels"))
  
  if (coords == "hexmap"){
    switch(map, 
      "states50"       = usahex::states50, 
      "statesDC"       = usahex::statesDC, 
      "statesTerr"     = usahex::statesTerr, 
      "WIOAETA"        = usahex::WIOAETA, 
      "WIOAETAregions" = usahex::WIOAETAregions
    )
  } else if (coords == "labels"){
    switch(map, 
      "states50"       = usahex::states50_labels, 
      "statesDC"       = usahex::statesDC_labels, 
      "statesTerr"     = usahex::statesTerr_labels, 
      "WIOAETA"        = usahex::WIOAETA_labels, 
      "WIOAETAregions" = usahex::WIOAETAregions_labels
    ) 
  } else {
    stop("Invalid 'coords' argument, options are: 'hexmap' or 'labels'")
  }
  
  
}