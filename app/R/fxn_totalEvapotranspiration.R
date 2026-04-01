#' `fxn_totalEvapotranspiration` - Calculates ET accumulation by day and season for period of interest and individual years
#' 
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param etEquation - Evapotranspiration equation selection by user
#' @return `totalEvapotranspiration` - List of daily [[1]] and seasonal [[2]] data tables of values for individual years


fxn_totalEvapotranspiration <- function(azmetStation, startDate, endDate, etEquation) {
  
  azmetStationStartDate <- 
    dplyr::filter(azmetStationMetadata, meta_station_name == azmetStation) %>% 
    dplyr::pull(start_date)
    
  azDaily <- 
    fxn_azDaily(
      azmetStation = azmetStation,
      startDate = azmetStationStartDate, # To call API only once, faster with daily data
      endDate = endDate
    )
  
  while (startDate >= azmetStationStartDate) {
    
    userDateRange <- lubridate::interval(start = startDate, end = endDate)  
    
    if (azmetStation == "Yuma N.Gila" & startDate %within% yugNodataInterval & endDate %within% yugNodataInterval) {
      # Handle empty daily data table at YUG
      singleYearDaily <-
        tibble::tibble( 
          datetime = seq(lubridate::ymd(startDate), lubridate::ymd(endDate), by = "days"),
          meta_station_name = azmetStation,
          eto_azmet_in = NA_real_,
          eto_pen_mon_in = NA_real_,
          precip_total_in = NA_real_,
          eto_azmet_in_acc = NA_real_,
          eto_pen_mon_in_acc = NA_real_,
          precip_total_in_acc = NA_real_
        )
    } else {
      singleYearDaily <- 
        dplyr::filter(azDaily, datetime >= startDate & datetime <= endDate)
    }
    
    singleYearDaily <- singleYearDaily %>% 
      dplyr::mutate(
        eto_azmet_in_acc = 
          dplyr::if_else(
            condition = is.na(eto_azmet_in),
            true = NA_real_,
            false = 
              round((cumsum(tidyr::replace_na(eto_azmet_in, 0))), digits = 2)
          ),
        eto_pen_mon_in_acc = 
          dplyr::if_else(
            condition = is.na(eto_pen_mon_in),
            true = NA_real_,
            false = 
              round((cumsum(tidyr::replace_na(eto_pen_mon_in, 0))), digits = 2)
          ),
        precip_total_in_acc = 
          dplyr::if_else(
            condition = is.na(precip_total_in),
            true = NA_real_,
            false = 
              round((cumsum(tidyr::replace_na(precip_total_in, 0))), digits = 2)
          ),
        date_year_label = 
          dplyr::if_else(
            condition = lubridate::year(startDate) == lubridate::year(endDate),
            true = as.character(lubridate::year(startDate)),
            false = paste(lubridate::year(startDate), lubridate::year(endDate), sep = "-")
          ),
        day_of_period = dplyr::row_number()
      )
    
    if (azmetStation == "Yuma N.Gila" & lubridate::int_overlaps(int1 = yugNodataInterval, int2 = userDateRange) == TRUE) {
      # Handle partially empty or empty daily data table at YUG
      singleYearDaily <- singleYearDaily %>%
        dplyr::mutate(
          eto_azmet_in_acc =
            dplyr::if_else(
              condition = datetime < yugNodataStartDate,
              true = eto_azmet_in_acc,
              false = NA_real_
            ),
          eto_pen_mon_in_acc =
            dplyr::if_else(
              condition = datetime < yugNodataStartDate,
              true = eto_pen_mon_in_acc,
              false = NA_real_
            ),
          precip_total_in_acc =
            dplyr::if_else(
              condition = datetime < yugNodataStartDate,
              true = precip_total_in_acc,
              false = NA_real_
            )
        )
    }
      
    # singleYearDaily <- singleYearDaily %>%
    #   dplyr::mutate(
    #     date_year_label = 
    #       dplyr::if_else(
    #         condition = lubridate::year(startDate) == lubridate::year(endDate),
    #         true = as.character(lubridate::year(startDate)),
    #         false = paste(lubridate::year(startDate), lubridate::year(endDate), sep = "-")
    #       ),
    #     day_of_period = dplyr::row_number()
    #   )
      
    # With `singleYearDaily` transformed, calculate seasonal totals
    singleYearTotal <-
      fxn_totalEvapotranspirationSeasonal(
        azmetStation = azmetStation,
        inData = singleYearDaily,
        startDate = startDate,
        endDate = endDate,
        etEquation = etEquation,
        userDateRange = userDateRange
      )  
      
    # Build data tables for return
    if (exists("dailyTotals") == FALSE) {
      dailyTotals <- singleYearDaily
    } else {
      dailyTotals <- rbind(dailyTotals, singleYearDaily)
    }
    
    if (exists("seasonalTotals") == FALSE) {
      seasonalTotals <- singleYearTotal
    } else {
      seasonalTotals <- rbind(seasonalTotals, singleYearTotal)
    }
    
    # Setup for analysis of data from previous year
    startDate <- min(seq(lubridate::date(startDate), length = 2, by = "-1 year"))
    endDate <- min(seq(lubridate::date(endDate), length = 2, by = "-1 year"))
  }
  
  return(list(dailyTotals, seasonalTotals))
}
