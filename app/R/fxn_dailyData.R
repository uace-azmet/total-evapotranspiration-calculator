#' `fxn_dailyData.R` Download AZMet daily data from API-based database
#' 
#' @param azmetStation - AZMet station name
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `dailyData` - Table of downloaded, transformed daily data


fxn_dailyData <- function(azmetStation, startDate, endDate) {
  dailyData <- azmetr::az_daily(
    station_id = 
      dplyr::filter(azmetStationMetadata, meta_station_name == azmetStation)$meta_station_id,
    start_date = startDate, 
    end_date = endDate
  ) %>% 
    dplyr::select(all_of(c(dailyVarsID, dailyVarsMeasured, dailyVarsDerived)))
  
  return(dailyData)
}
