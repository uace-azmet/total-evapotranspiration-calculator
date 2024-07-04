#' fxnAZMetDataSumET: calculates total evapotranspiration based on user input
#' 
#' @param inData - dataAZMetdataELT
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param etEquation - ET equation selection by user
#' @return `dataAZMetDataSumET` - Data table with total evapotranspiration by year


fxnAZMetDataSumET <- function(inData, azmetStation, startDate, endDate, etEquation) {
  if (length(unique(inData$date_year)) == 1) { # For single calendar year in data
    dateYear <- as.character(unique(inData$date_year))
  } else { # For two calendar years in data
    dateYear <- paste(min(unique(inData$date_year)), max(unique(inData$date_year)), sep = "-")
  }
  
  if (chillVariable == "Original AZMet") {
    dataAZMetDataSumET <- inData %>%
      dplyr::group_by(meta_station_name) %>%
      dplyr::summarize(chill_hours_32F_cumulative = sum(chill_hours_32F, na.rm = TRUE)) %>%
      dplyr::rename(chillSum = chill_hours_32F_cumulative) %>%
      dplyr::mutate(chillSumLabel = format(round(chillSum, digits = 0), nsmall = 0)) %>%
      dplyr::mutate(endDateYear = lubridate::year(endDate)) %>%
      dplyr::mutate(dateYearLabel = dateYear)
  } else if (chillVariable == "Penman-Monteith") {
    dataAZMetDataSumET <- inData %>%
      dplyr::group_by(meta_station_name) %>%
      dplyr::summarize(chill_hours_45F_cumulative = sum(chill_hours_45F, na.rm = TRUE)) %>%
      dplyr::rename(chillSum = chill_hours_45F_cumulative) %>%
      dplyr::mutate(chillSumLabel = format(round(chillSum, digits = 0), nsmall = 0)) %>%
      dplyr::mutate(endDateYear = lubridate::year(endDate)) %>%
      dplyr::mutate(dateYearLabel = dateYear)
  }
  
  return(dataAZMetDataSumET)
}
