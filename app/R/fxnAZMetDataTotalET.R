#' fxnAZMetDataTotalET: calculates total evapotranspiration based on user input
#' 
#' @param inData - dataAZMetdataELT
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param etEquation - ET equation selection by user
#' @return `dataAZMetDataTotalET` - Data table with total evapotranspiration by year


fxnAZMetDataTotalET <- function(inData, azmetStation, startDate, endDate, etEquation) {
  # For x-axis labels and related text of comparison to previous years
  if (lubridate::year(startDate) == lubridate::year(endDate)) { # For data request spanning a single calendar year
    dateYear <- as.character(lubridate::year(startDate))
  } else { # For data request spanning two calendar years
    dateYear <- 
      paste(
        lubridate::year(startDate), 
        lubridate::year(endDate), 
        sep = "-"
      )
  }
  
  if (nrow(inData) == 0) { # For case of empty data return
    dataAZMetDataTotalET <- data.frame(matrix(
      data = NA,
      nrow = 1, 
      ncol = length(c("meta_station_name", "etTotal", "etTotalLabel", "endDateYear", "dateYearLabel"))
    ))
    
    colnames(dataAZMetDataTotalET) <- 
      c("meta_station_name", "etTotal", "etTotalLabel", "endDateYear", "dateYearLabel")
    
    dataAZMetDataTotalET <- dataAZMetDataTotalET %>%
      dplyr::mutate(meta_station_name = azmetStation) %>%
      dplyr::mutate(etTotal = 0.00) %>%
      dplyr::mutate(etTotalLabel = "NA") %>%
      dplyr::mutate(endDateYear = lubridate::year(endDate)) %>%
      dplyr::mutate(dateYearLabel = dateYear)
  } else {
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
  }
  
  return(dataAZMetDataTotalET)
}
