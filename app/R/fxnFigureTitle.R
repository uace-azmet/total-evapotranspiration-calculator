#' `fxnFigureTitle.R` - Build title for figure based on user input
#' 
#' @param endDate - End date of period of interest
#' @param inData - data table of seasonal total ET values by year
#' @return `figureTitle` - Title for figure based on selected station


fxnFigureTitle <- function(endDate, inData) {
  totalInches <- dplyr::filter(inData, endDateYear == lubridate::year(endDate))$etTotal
  totalMillimeters <- format(round(totalInches * 25.4, digits = 1), nsmall = 1) 
  totalInches <- format(round(totalInches, digits = 2), nsmall = 2)
  
  figureTitle <- 
      htmltools::h4(
        htmltools::HTML(
          paste0(
            "<b>", totalInches, " inches", "</b>", " (", totalMillimeters, " millimeters)"
          ),
        ),
        
        class = "figure-title"
      )
  
  return(figureTitle)
}
