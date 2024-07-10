#' `fxnFigureSubtitle.R` - Build subtitle for figure based on user input
#' 
#' @param azmetStation - AZMet station selection by user
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @param inData - data table of seasonal total ET values by year
#' @return `figureSubtitle` - Subtitle for figure based on selected AZMet station


fxnFigureSubtitle <- function(azmetStation, startDate, endDate, inData) {
  currentYear <- lubridate::year(endDate)
  previousYear <- currentYear - 1
  
  currentYearTotalIn <- dplyr::filter(inData, endDateYear == currentYear)$etTotal
  currentYearTotalMm <- currentYearTotalIn * 25.4
  previousYearTotalIn <- dplyr::filter(inData, endDateYear == previousYear)$etTotal
  previousYearTotalMm <- previousYearTotalIn * 25.4
  
  totalComparePreviousIn <- currentYearTotalIn - previousYearTotalIn
  totalComparePreviousMm <- currentYearTotalMm - previousYearTotalMm
  
  if (totalComparePreviousIn == 0) {
    compareTextPrevious <- "the same as"
  } else if (totalComparePreviousIn > 0) {
    compareTextPrevious <- 
      paste0(
        format(round(totalComparePreviousIn, digits = 2), nsmall = 2), " inches (", format(round(totalComparePreviousMm, digits = 1), nsmall = 1), " millimeters) greater than"
      )
  } else { # if (totalComparePreviousIn < 0)
    compareTextPrevious <- 
      paste0(
        format(round(totalComparePreviousIn, digits = 2), nsmall = 2), " inches (", format(round(totalComparePreviousMm, digits = 1), nsmall = 1), " millimeters) less than"
      )
  }
  
  # if() for != MOH, WEL, YUE
  figureSubtitle <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          "Total evapotranspiration at the AZMet ", azmetStation, " station from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " is ", "<b>", format(round(currentYearTotalIn, digits = 2), nsmall = 2), " inches", "</b>", " (", format(round(currentYearTotalMm, digits = 1), nsmall = 1), " millimeters). This is ", compareTextPrevious, " the total during this same period in ", "YEAR TEXT", "."
        ),
      ),
      
      class = "figure-subtitle"
    )
  
  return(figureSubtitle)
}
