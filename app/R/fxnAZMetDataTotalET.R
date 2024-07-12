#' fxnAZMetDataTotalET: calculates total evapotranspiration based on user input
#' 
#' @param inData - dataAZMetdataELT
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param etEquation - ET equation selection by user
#' @return `dataAZMetDataTotalET` - Data table with total evapotranspiration by year


fxnAZMetDataTotalET <- function(inData, azmetStation, startDate, endDate, etEquation) {
  if (length(unique(inData$date_year)) == 1) { # For single calendar year in data
    dateYear <- as.character(unique(inData$date_year))
  } else { # For two calendar years in data
    dateYear <- 
      paste(
        min(unique(inData$date_year), na.rm = TRUE),
        max(unique(inData$date_year), na.rm = TRUE), 
        sep = "-"
      )
  }
  
  if (etEquation == "Original AZMet") {
    dataAZMetDataTotalET <- inData %>%
      dplyr::group_by(meta_station_name) %>%
      dplyr::summarize(eto_azmet_in_total = sum(eto_azmet_in, na.rm = TRUE)) %>%
      dplyr::rename(etTotal = eto_azmet_in_total) %>%
      dplyr::mutate(etTotalLabel = format(round(etTotal, digits = 2), nsmall = 2)) %>%
      dplyr::mutate(endDateYear = lubridate::year(endDate)) %>%
      dplyr::mutate(dateYearLabel = dateYear)
  } else if (etEquation == "Penman-Monteith") {
    dataAZMetDataTotalET <- inData %>%
      dplyr::group_by(meta_station_name) %>%
      dplyr::summarize(eto_pen_mon_in_total = sum(eto_pen_mon_in, na.rm = TRUE)) %>%
      dplyr::rename(etTotal = eto_pen_mon_in_total) %>%
      dplyr::mutate(etTotalLabel = format(round(etTotal, digits = 2), nsmall = 2)) %>%
      dplyr::mutate(endDateYear = lubridate::year(endDate)) %>%
      dplyr::mutate(dateYearLabel = dateYear)
  }
  
  return(dataAZMetDataTotalET)
}
