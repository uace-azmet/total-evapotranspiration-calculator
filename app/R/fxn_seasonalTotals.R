#' `fxn_seasonalTotals` - combines seasonal ET totals from individual years
#' 
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param etEquation - Evapotranspiration equation selection by user
#' @return `seasonalTotals` - Data table of seasonal ET totals from individual years


fxn_seasonalTotals <- function(azmetStation, startDate, endDate, etEquation) {
  azmetStationStartDate <- 
    dplyr::filter(azmetStationMetadata, meta_station_name == azmetStation)$start_date
    
  dailyData <- 
    fxn_dailyData(
      azmetStation = azmetStation,
      startDate = azmetStationStartDate, # To call API only once
      endDate = endDate
    )
  
  while (startDate >= azmetStationStartDate) {
    seasonalData <- 
      dplyr::filter(
        dailyData,
        datetime >= startDate & datetime <= endDate
      )
    
    # Calculate seasonal total from individual year and prepare data for graph
    etTotal <- 
      fxn_etTotal(
        inData = seasonalData,
        azmetStation = azmetStation, 
        startDate = startDate, 
        endDate = endDate,
        etEquation = etEquation
      )
    
    # Account for multi-month absence of YUG data in 2021
    if (azmetStation == "Yuma N.Gila") {
      nodataDateRange <- 
        lubridate::interval(
          start = lubridate::date("2021-06-16"), 
          end = lubridate::date("2021-10-21")
        )
      
      userDateRange <- lubridate::interval(start = startDate, end = endDate)
      
      if (lubridate::int_overlaps(int1 = nodataDateRange, int2 = userDateRange) == TRUE) {
        etTotal$etTotal <- 0.00
        etTotal$etTotalLabel <- "NA" 
      }
    }
    
    if (exists("seasonalTotals") == FALSE) {
      seasonalTotals <- etTotal
    } else {
      seasonalTotals <- rbind(seasonalTotals, etTotal)
    }
    
    startDate <- min(seq(lubridate::date(startDate), length = 2, by = "-1 year"))
    endDate <- min(seq(lubridate::date(endDate), length = 2, by = "-1 year"))
  }
  
  return(seasonalTotals)
}
