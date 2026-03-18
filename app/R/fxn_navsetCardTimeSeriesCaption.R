#' `fxn_navsetCardTimeSeriesCaption.R` - Build caption for bar chart based on user input
#' 
#' @return `navsetCardTimeSeriesCaption` Caption for bar chart based on selected station


fxn_navsetCardTimeSeriesCaption <- function() {
  navsetCardTimeSeriesCaption <- 
    htmltools::p(
      htmltools::HTML(
        paste0(
          "This is the time series caption."
        )
      ),
      
      class = "navset-card-caption"
    )
  
  return(navsetCardTimeSeriesCaption)
}
