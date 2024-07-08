#' `fxnFigureTitle.R` - Build title for figure based on user input
#' 
#' @param inData - data table of seasonal total ET values by year
#' @param endDate - End date of period of interest
#' @param etEquation - ET equation selection by user
#' @return `figureTitle` - Title for figure based on selected station


fxnFigureTitle <- function(inData, endDate, etEquation) {
  currentYear <- lubridate::year(endDate)
  currentYearET <- 
    inData$totalET[which(inData$endDateYear == currentYear)]
  currentYearETText <- inData$dateYearLabel[which(inData$endDateYear == currentYear)]
  
  previousYear <- currentYear - 1
  previousYearET <- 
    inData$totalET[which(inData$endDateYear == previousYear)]
  previousYearETText <- inData$dateYearLabel[which(inData$endDateYear == previousYear)]
  
  if (nrow(inData) < 2) {
    figureTitle <- 
      htmltools::h4(
        htmltools::HTML(
          paste(
            "Total Number of", etEquation, "in", currentYear,
            sep = " "
          ),
        ),
        
        class = "figure-title"
      )
  } else {
    if (currentYearET > (previousYearET + (0.1 * previousYearET))) {
      comparisonText <- "Greater than"
    } else if (currentYearET < (previousYearET - (0.1 * previousYearET))) {
      comparisonText <- "Less than"
    } else {
      comparisonText <- "Similar to"
    }
    
    figureTitle <- 
      htmltools::h4(
        htmltools::HTML(
          paste(
            "Total Number of", etEquation, "in", currentYearETText, comparisonText, "That in", previousYearETText,
            sep = " "
          ),
        ),
        
        class = "figure-title"
      )
    
  }
  
  return(figureTitle)
}
