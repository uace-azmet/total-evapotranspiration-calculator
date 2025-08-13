#' `fxn_figureSummary.R` - Build summary of figure based on user input
#' 
#' @param azmetStation - AZMet station selection by user
#' @param inData - data table of seasonal total evapotranspiration by year
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `figureSummary` - Summary of figure based on user inputs


fxn_figureSummary <- function(azmetStation, inData, startDate, endDate) {
  averageTotal <- mean(inData$etTotal, na.rm = TRUE)
  currentYear <- lubridate::year(endDate)
  currentYearTotal <- dplyr::filter(inData, endDateYear == currentYear)$etTotal
  previousYear <- currentYear - 1
  previousYearText <- dplyr::filter(inData, endDateYear == previousYear)$dateYearLabel
  previousYearTotal <- dplyr::filter(inData, endDateYear == previousYear)$etTotal
  
  differenceAverage <- currentYearTotal - averageTotal
  differencePreviousYear <- currentYearTotal - previousYearTotal
  
  if (differenceAverage == 0) {
    differenceAverageText <- "the same as"
  } else if (differenceAverage > 0) {
    differenceAverageText <- 
      paste0(
        format(abs(round(differenceAverage, digits = 2)), nsmall = 2), " inches greater than"
      )
  } else { # if (differenceAverage < 0)
    differenceAverageText <- 
      paste0(
        format(abs(round(differenceAverage, digits = 2)), nsmall = 2), " inches less than"
      )
  }
  
  if (differencePreviousYear == 0) {
    differencePreviousYearText <- "the same as"
  } else if (differencePreviousYear > 0) {
    differencePreviousYearText <- 
      paste0(
        format(abs(round(differencePreviousYear, digits = 2)), nsmall = 2), " inches greater than"
      )
  } else { # if (differencePreviousYear < 0)
    differencePreviousYearText <- 
      paste0(
        format(abs(round(differencePreviousYear, digits = 2)), nsmall = 2), " inches less than"
      )
  }
  
  if (nrow(inData) == 1) {
    figureSummary <- 
      htmltools::p(
        htmltools::HTML(
          paste0(
            "Total evapotranspiration at the AZMet ", azmetStation, " station from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " is ", "<b>", format(round(currentYearTotal, digits = 2), nsmall = 2), " inches</b>."
          ),
        ),
        
        class = "figure-summary"
      )
  } else {
    figureSummary <- 
      htmltools::p(
        htmltools::HTML(
          paste0(
            "Total evapotranspiration at the AZMet ", azmetStation, " station from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), " is ", "<b>", format(round(currentYearTotal, digits = 2), nsmall = 2), " inches</b>. This is ", differencePreviousYearText, " the total during this same month-day period in ", previousYearText, ", and ", differenceAverageText, " the average total, as calculated from the below values."
          ),
        ),
        
        class = "figure-summary"
      )
  }
  
  return(figureSummary)
}
