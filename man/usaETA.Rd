% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/usaETA.R
\docType{data}
\name{usaETA}
\alias{usaETA}
\title{usaETA shapefile data}
\format{
Simple feature collection
\describe{
\item{abbr_usps}{2-letter code used by the United States Postal Service}
\item{abbr_gpo}{abbreviations from US Government Printing Office}
\item{abbr_ap}{abbreviations from AP Stylebook}
\item{abbr_short}{abbreviations that are between 3-4 characters}
\item{abbr_long}{abbreviations that are between 4-8 characters, most are 5-6 characters}
\item{name}{Name of geographic area}
\item{fips}{2-digit FIPS code (Federal Information Processing Standard)}
\item{geo_type}{Type of region: state, federal district, territory, freely associated state}
\item{geometry}{polygon coordinates for hexagon}
}
}
\source{
Department of Labor, Employment and Training Administration
\url{https://www.dol.gov/agencies/eta}

ETA regions
\url{https://www.dol.gov/agencies/eta/regions}

Workforce Innovation and Opportunity Act
\url{https://www.dol.gov/agencies/eta/wioa/}
}
\usage{
usaETA
}
\description{
Hexagon map shape file that includes:
\itemize{
\item 50 States
\item 1 federal district: District of Columbia
\item 5 territories: Puerto Rico, Virgin Islands, American Samoa, and the Northern Mariana Islands
\item 1 freely associated state: Palau
}
}
\details{
These are based on ETA (Department of Labor's Employment and Training Administration) regions for reporting WIOA (Workforce Innovation and Opportunity Act) performance.
}
\keyword{datasets}
