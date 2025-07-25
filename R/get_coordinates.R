
#' Import hex map coordinates
#'
#' @param map A \code{character} string specifying which map. 
#'   Current options are 
#'   `"usa50"` (50 US States only), 
#'   `"usa51"` (50 states and DC), 
#'   `"usa52"` (50 states, DC, and Puerto Rico), 
#'   `"usa53"` (50 states, DC, PUerto Rico and Virgin Islands), 
#'   `"usa56"` (50 states, DC, territories (PR, VI, AS, GU, MP)), 
#'   `"usa56"` (50 states, DC, territories (PR, VI, AS, GU, MP), and freely 
#'    associate states (FM, MH, PW)), 
#'   `"usaETA"` (US DOL ETA geographies, same as usa56 with the addition 
#'   of the freely associate state of Palau), and 
#'   `"usaETARegions"` (unified maps of US DOL ETA regions) .
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
                                                  "usaETAregions"))
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
      "usaETAregions" = usahex::usaETAregions
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
      "usaETAregions" = usahex::usaETAregions_labels
    ) 
  } else {
    stop("Invalid 'coords' argument, options are: 'hexmap' or 'labels'")
  }
  
  
}
