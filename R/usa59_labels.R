#' usa59_labels shapefile data
#' 
#' Point coordinates for the center of the hexagon that includes: 
#' - 50 States  
#' - 1 federal district: District of Columbia 
#' - 5 territories: Puerto Rico, Virgin Islands, American Samoa, and the Northern Mariana Islands  
#' - 3 freely associates states: Micronesia, Marshall Islands, Palau
#'
#' @format Simple feature collection 
#' \describe{
#' \item{abbr_usps}{2-letter code used by the United States Postal Service}
#' \item{abbr_gpo}{abbreviations from US Government Printing Office}
#' \item{abbr_ap}{abbreviations from AP Stylebook}
#' \item{abbr_short}{abbreviations that are between 3-4 characters}
#' \item{abbr_long}{abbreviations that are between 4-8 characters, most are 5-6 characters}
#' \item{name}{Name of geographic area}
#' \item{fips}{2-digit FIPS code (Federal Information Processing Standard)}
#' \item{geo_type}{Type of region: state, federal district, territory, freely associated state}
#' \item{geometry}{point coordinates for the center of the hexagon}
#' }
'usa59_labels'

