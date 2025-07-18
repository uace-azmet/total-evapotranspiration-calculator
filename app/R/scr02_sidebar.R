sidebar <- bslib::sidebar(
  width = 300,
  position = "left",
  open = list(desktop = "always", mobile = "always-above"),
  id = "sidebar",
  title = NULL,
  bg = "#FFFFFF",
  fg = "#191919",
  class = NULL,
  max_height_mobile = NULL,
  gap = NULL,
  padding = NULL,
  
  htmltools::p(
    bsicons::bs_icon("sliders"), 
    htmltools::HTML("&nbsp;"), 
    "DATA OPTIONS"
  ),
  
  shiny::helpText(
    "Select an AZMet station, specify the equation to calculate evapotranspiration, and set dates for the start and end of the period of interest. Then, click or tap 'CALCULATE TOTAL'."
  ),
  
  shiny::selectInput(
    inputId = "azmetStation", 
    label = "AZMet Station",
    choices = azmetStationMetadata[order(azmetStationMetadata$meta_station_name), ]$meta_station_name, # see `app.R`, shiny::updateSelectInput(inputId = "azmetStation")
    selected = azmetStationMetadata[order(azmetStationMetadata$meta_station_name), ]$meta_station_name[1] # see `app.R`, shiny::updateSelectInput(inputId = "azmetStation")
  ),
  
  shiny::selectInput(
    inputId = "etEquation",
    label = "Equation",
    choices = etEquations,
    selected = "Penman-Monteith"
  ),
  
  shiny::dateInput(
    inputId = "startDate",
    label = "Start Date",
    value = Sys.Date() - lubridate::dmonths(x = 1),
    min = Sys.Date() - lubridate::years(1),
    max = Sys.Date() - 1,
    format = "MM d, yyyy",
    startview = "month",
    weekstart = 0, # Sunday
    width = "100%",
    autoclose = TRUE
  ),
  
  shiny::dateInput(
    inputId = "endDate",
    label = "End Date",
    value = Sys.Date() - 1,
    min = Sys.Date() - lubridate::years(1),
    max = Sys.Date() - 1,
    format = "MM d, yyyy",
    startview = "month",
    weekstart = 0, # Sunday
    width = "100%",
    autoclose = TRUE
  ),
  
  shiny::actionButton(
    inputId = "calculateTotalEvapotranspiration", 
    label = "CALCULATE TOTAL",
    class = "btn btn-block btn-blue"
  )    
) # bslib::sidebar()
