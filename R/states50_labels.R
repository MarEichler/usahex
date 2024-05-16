#' states50_labels shapefile data
#' 
#' Point coordinates for the center of the hexagon that includes: 50 States only
#'
#' @source Coordinates for hex map are based on NPR's daily graphic template,
#'  \url{https://github.com/nprapps/dailygraphics-templates/blob/master/state_grid_map/index.html}
#'
#'@source Abbreviations are pulled from List of U.S. state and territory abbreviations, 
#'  \url{https://en.wikipedia.org/wiki/List_of_U.S._state_and_territory_abbreviations}
#'
#' @format Simple feature collection 
#' \describe{
#' \item{abbr_usps}{2-letter code used by the United States Postal Service}
#' \item{abbr_gpo}{abbreviations from US Government Printing Office}
#' \item{abbr_ap}{abbreviations from AP Stylebook}
#' \item{name}{Name of geographic area}
#' \item{fips}{2-digit FIPS code (Federal Information Processing Standard)}
#' \item{geo_type}{Type of region: state, federal district, territory, freely associated state}
#' \item{geometry}{point coordinates for the center of the hexagon}
#' }
'states50_labels'

