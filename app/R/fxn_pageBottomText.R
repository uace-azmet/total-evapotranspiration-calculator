#' `fxn_pageBottomText.R` - Build supporting text for page
#' 
#' @return `pageBottomText` - Supporting text for page


fxn_pageBottomText <- function() {
  
  # Define inputs -----
  
  apiURL <- a(
    "api.azmet.arizona.edu", 
    href="https://api.azmet.arizona.edu/v1/observations/daily",
    target="_blank"
  )
  
  azmetrURL <- a(
    "azmetr", 
    href="https://uace-azmet.github.io/azmetr/",
    target="_blank"
  )
  
  bulletinURL <- a(
    "AZ1324 'Standardized Reference Evapotranspiration'",
    href="https://extension.arizona.edu/sites/extension.arizona.edu/files/pubs/az1324.pdf",
    target="_blank"
  )
  
  # `firstParagraph`
  # if (etEquation == "Original AZMet") {
  #   firstParagraph <- paste0(
  #     "Total evapotranspiration for the current growing season (dark gray bar in graph) is based on the sum of daily totals from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " and as estimated by the ", etEquation, " equation. Totals for past seasons (gray bars in graph) are based on the same start and end month and day, but during those respective years. More information about this equation is in Extension bulletin ", bulletinURL, "."
  #   )
  # } else { # etEquation == "Penman-Monteith"
  #   firstParagraph <- paste0(
  #     "Total evapotranspiration for the current growing season (dark gray bar in graph) is based on the sum of daily totals from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " and as estimated by the ", etEquation, " equation. Totals for past seasons (gray bars in graph) are based on the same start and end month and day, but during those respective years. More information about this equation is in Extension bulletin ", bulletinURL, ". Evapotranspiration totals based on the Penman-Monteith equation assume a location of extensive, well-watered grass or other dense, uniform vegetation. Non-standard surfaces at some stations may relatively raise temperature and lower humidity, and potentially result in an overestimation of evapotranspiration."
  #   )
  # }
  
  todayDate <- gsub(" 0", " ", format(lubridate::today(), "%B %d, %Y"))
  
  todayYear <- lubridate::year(lubridate::today())
  
  webpageAZMet <- a(
    "AZMet website", 
    href="https://azmet.arizona.edu/", 
    target="_blank"
  )
  
  webpageCode <- a(
    "GitHub page", 
    href="https://github.com/uace-azmet/total-evapotranspiration-calculator", 
    target="_blank"
  )
  
  webpageDataVariables <- a(
    "data variables", 
    href="https://azmet.arizona.edu/about/data-variables", 
    target="_blank"
  )
  
  webpageNetworkMap <- a(
    "station locations", 
    href="https://azmet.arizona.edu/about/network-map", 
    target="_blank"
  )
  
  webpageStationMetadata <- a(
    "station metadata", 
    href="https://azmet.arizona.edu/about/station-metadata", 
    target="_blank"
  )
  
  
  # Build text -----
  
  pageBottomText <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          "AZMet daily data are from ", apiURL, " and accessed using the ", azmetrURL, " R package. Values from recent dates may be based on provisional data. More information about ", webpageDataVariables, ", ", webpageNetworkMap, ", and ", webpageStationMetadata, " is available on the ", webpageAZMet, ". Users of AZMet data and related information assume all risks of its use.",
          htmltools::br(), htmltools::br(),
          "To cite the above AZMet data, please use: 'Arizona Meteorological Network (", todayYear, ") Arizona Meteorological Network (AZMet) Data. https:://azmet.arizona.edu. Accessed ", todayDate, "', along with 'Arizona Meteorological Network (", todayYear, ") Total Evapotranspiration Calculator. https://viz.datascience.arizona.edu/azmet/total-evapotranspiration-calculator. Accessed ", todayDate, "'.",
          htmltools::br(), htmltools::br(),
          "For information on how this webpage is put together, please visit the ", webpageCode, " for this tool."
        )
      ),
      
      class = "page-bottom-text"
    )
  
  return(pageBottomText)
}
