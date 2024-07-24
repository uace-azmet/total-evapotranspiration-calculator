#' fxnAZMetDataMerge: downloads and merges individual-year data since API database start and based on user input
#' 
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param etEquation - Evapotranspiration equation selection by user
#' @return `dataAZMetDataMerge` - Merged data tables from individual years


fxnAZMetDataMerge <- function(azmetStation, startDate, endDate, etEquation) {
  azmetStationStartDate <- apiStartDate # Placeholder for station start date
  
  while (startDate >= azmetStationStartDate) {
    dataAZMetDataELT <- fxnAZMetDataELT(
      azmetStation = azmetStation, 
      timeStep = "Daily", 
      startDate = startDate, 
      endDate = endDate
    )
    
    # For case of empty data return
    if (nrow(dataAZMetDataELT) == 0) {
      dataAZMetDataTotalET$dateYear <- X
      dataAZMetDataTotalET$endDate <- Y
      dataAZMetDataTotalET$etTotal <- 0.00
      dataAZMetDataTotalET$etTotalLabel <- "NA" 
      
      startDate <- min(seq(startDate, length = 2, by = "-1 year"))
      endDate <- min(seq(endDate, length = 2, by = "-1 year"))
    } else {
      # Total evapotranspiration calculation for period of interest
      dataAZMetDataTotalET <- fxnAZMetDataTotalET(
        inData = dataAZMetDataELT,
        azmetStation = azmetStation, 
        startDate = startDate, 
        endDate = endDate,
        etEquation = etEquation
      )
      
      # Address stations with `nodata` blocks or start dates later than API start date
      #if (azmetStation %in% c("Mohave ETo", "Wellton ETo", "Yuma North Gila", "Yuma Valley ETo")) {
      #  if (azmetStation == "Mohave ETo") {
      #    nodataDateRange <- 
      #      lubridate::interval(
      #        start = apiStartDate, 
      #        end = lubridate::date("2024-06-19")
      #      )
      #  } else if (azmetStation == "Wellton ETo") {
      #    nodataDateRange <- 
      #      lubridate::interval(
      #        start = apiStartDate, 
      #        end = lubridate::date("2023-05-01")
      #      )
      #  } else if (azmetStation == "Yuma North Gila") {
      #    nodataDateRange <- 
      #      lubridate::interval(
      #        start = lubridate::date("2021-06-16"), 
      #        end = lubridate::date("2021-10-21")
      #      )
      #  } else if (azmetStation == "Yuma Valley ETo") {
      #    nodataDateRange <- 
      #      lubridate::interval(
      #        start = apiStartDate, 
      #        end = lubridate::date("2023-05-01")
      #      )
      #  }
      if (azmetStation == "Yuma North Gila") {
        nodataDateRange <- 
          lubridate::interval(
            start = lubridate::date("2021-06-16"), 
            end = lubridate::date("2021-10-21")
          )
        
        userDateRange <- lubridate::interval(start = startDate, end = endDate)
        
        if (lubridate::int_overlaps(int1 = nodataDateRange, int2 = userDateRange) == TRUE) {
          dataAZMetDataTotalET$etTotal <- 0.00
          dataAZMetDataTotalET$etTotalLabel <- "NA" 
        }
      }
    }
      
    if (exists("dataAZMetDataMerge") == FALSE) {
      dataAZMetDataMerge <- dataAZMetDataTotalET
    } else {
      dataAZMetDataMerge <- rbind(dataAZMetDataMerge, dataAZMetDataTotalET)
    }
      
    startDate <- min(seq(startDate, length = 2, by = "-1 year"))
    endDate <- min(seq(endDate, length = 2, by = "-1 year"))
  }

  return(dataAZMetDataMerge)
}
