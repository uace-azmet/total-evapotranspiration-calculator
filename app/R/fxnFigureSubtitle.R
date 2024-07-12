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
  previousYearTotalIn <- dplyr::filter(inData, endDateYear == previousYear)$etTotal
  totalComparePreviousIn <- currentYearTotalIn - previousYearTotalIn
  
  previousYearText <- dplyr::filter(inData, endDateYear == previousYear)$dateYearLabel
  
  if (totalComparePreviousIn == 0) {
    compareTextPrevious <- "the same as"
  } else if (totalComparePreviousIn > 0) {
    compareTextPrevious <- 
      paste0(
        format(abs(round(totalComparePreviousIn, digits = 2)), nsmall = 2), " inches greater than"
      )
  } else { # if (totalComparePreviousIn < 0)
    compareTextPrevious <- 
      paste0(
        format(abs(round(totalComparePreviousIn, digits = 2)), nsmall = 2), " inches less than"
      )
  }
  
  # TODO: Add average information
  # TODO: if() for != MOH, WEL, YUE
  if (nrow(inData) == 1) {
    figureSubtitle <- 
      htmltools::p(
        htmltools::HTML(
          paste0(
            "Total evapotranspiration at the AZMet ", azmetStation, " station from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " is ", "<b>", format(round(currentYearTotalIn, digits = 2), nsmall = 2), " inches</b>."
          ),
        ),
        
        class = "figure-subtitle"
      )
  } else {
    figureSubtitle <- 
      htmltools::p(
        htmltools::HTML(
          paste0(
            "Total evapotranspiration at the AZMet ", azmetStation, " station from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " is ", "<b>", format(round(currentYearTotalIn, digits = 2), nsmall = 2), " inches</b>. This is ", compareTextPrevious, " the total during this same period in ", previousYearText, "."
          ),
        ),
        
        class = "figure-subtitle"
      )
  }
  
  return(figureSubtitle)
}
