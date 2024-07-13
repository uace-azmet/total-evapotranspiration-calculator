#' `fxnfigureSubtext.R` - Build caption for figure based on user input
#' 
#' @param azmetStation AZMet station selection by user
#' @return `figureSubtext` Caption for figure based on selected station


fxnFigureSubtext <- function(azmetStation) {
  standardText <- paste0("Data in the new AZMet database currently go back to ", format(apiStartDate, "%B %d, %Y"), ".")
  
  # TODO: Need to tighten conditional to reflect missing data dates
  if (azmetStation == "Yuma North Gila") {
    figureSubtext <- 
      htmltools::p(
        htmltools::HTML(
          paste(
            standardText,
            "The value 'NA' indicates that the period of interest overlaps with the period from ", "ABC", " to ", "DEF",  ", when the ", azmetStation, " station was not in operation.",
            sep = " "
          )
        ),
        
        class = "figure-subtext"
      )
  } else {
    figureSubtext <- 
      htmltools::p(
        htmltools::HTML(standardText), 
        class = "figure-subtext"
      )
  }
  
  return(figureSubtext)
}
