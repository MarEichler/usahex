
#' Import hex map coordinates
#'
#' @param map A \code{character} string specifying which map. 
#'   Current options are 
#'   `"usa50"` (50 US States only), 
#'   `"usa51"` (50 states and DC), 
#'   `"usa52"` (50 states, DC, and Puerto Rico), 
#'   `"usa53"` (50 states, DC, PUerto Rico and Virgin Islands), 
#'   `"usa56"` (50 states, DC, Puerto Rico, Virgin Islands, Guam, 
#'   American Samoa, and Marshall Islands), 
#'   `"usaETA"` (WIOA ETA geographies, same as statesTerr with the addition 
#'   of Palau), and 
#'   `"ETARegions"` (unified maps of WIOA ETA regions) .
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
#' get_coordinates(map = "usa50", coords = "hexmap")
#' get_coordinates(map = "usa50", coords = "labels")
get_coordinates <- function(map = NULL, coords = "hexmap"){
  
  
  stopifnot("Enter 'map' argument" = !is.null(map))
  stopifnot("Invlaid 'map' argument" = map %in% c("usa50", "usa51", "usa52", "usa53", 
                                                  "usa56", "usa59", "usaETA", 
                                                  "ETAregions"))
  stopifnot("Invalid 'coords' argument, options are 'hexmap' or 'labels'" = 
              coords %in% c("hexmap", "labels"))
  
  if (coords == "hexmap"){
    switch(map, 
      "usa50"      = usahex::usa50, 
      "usa51"      = usahex::usa51, 
      "usa52"      = usahex::usa52, 
      "usa53"      = usahex::usa53,
      "usa56"      = usahex::usa56, 
      "usa59"      = usahex::usa59, 
      "usaETA"     = usahex::usaETA, 
      "ETAregions" = usahex::ETAregions
    )
  } else if (coords == "labels"){
    switch(map, 
      "usa50"      = usahex::usa50_labels, 
      "usa51"      = usahex::usa51_labels, 
      "usa52"      = usahex::usa52_labels, 
      "usa53"      = usahex::usa53_labels,
      "usa56"      = usahex::usa56_labels, 
      "usa59"      = usahex::usa59_labels, 
      "usaETA"     = usahex::usaETA_labels, 
      "ETAregions" = usahex::ETAregions_labels
    ) 
  } else {
    stop("Invalid 'coords' argument, options are: 'hexmap' or 'labels'")
  }
  
  
}
