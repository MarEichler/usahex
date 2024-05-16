#' WIOAETAregions_labels shapefile data
#' 
#' Point coordinates for the labels on ETA regions.  
#' 
#' These are based on ETA (Department of Labor's Employment and Training Administration) regions for reporting WIOA (Workforce Innovation and Opportunity Act) performance. 
#'
#' @source Coordinates for hex map are based on NPR's daily graphic template,
#'  \url{https://github.com/nprapps/dailygraphics-templates/blob/master/state_grid_map/index.html}
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
#' \item{eta_region}{Number code representing ETA region, 1-6}
#' \item{eta_region_name}{Name of region}
#' \item{etaA_region_city}{City headquarters for ETA region}
#' \item{geometry}{Point coordinates for labels on ETA regions}
#' }
'WIOAETAregions_labels'

