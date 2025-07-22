#' usaETA shapefile data
#' 
#' Point coordinates for the center of the hexagon that includes:
#' - 50 States  
#' - 1 federal district: District of Columbia
#' - 5 territories: Puerto Rico, Virgin Islands, American Samoa, and the Northern Mariana Islands  
#' - 1 freely associated state: Palau
#' 
#' These are based on ETA (Department of Labor's Employment and Training Administration) regions for reporting WIOA (Workforce Innovation and Opportunity Act) performance. 
#'
#' @source Coordinates for hex map are based on NPR's daily graphic template,
#'  \url{https://github.com/nprapps/dailygraphics-templates/blob/master/state_grid_map/index.html}
#'
#' @source Abbreviations are pulled from List of U.S. state and territory abbreviations, 
#'  \url{https://en.wikipedia.org/wiki/List_of_U.S._state_and_territory_abbreviations}
#'  
#' @source Department of Labor, Employment and Training Administration 
#'  \url{https://www.dol.gov/agencies/eta}
#'
#' @source Workforce Innovation and Opportunity Act
#'  \url{https://www.dol.gov/agencies/eta/wioa/}
#'
#' @source ETA regions 
#'  \url{https://www.dol.gov/agencies/eta/regions}  
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
'usaETA_labels'

