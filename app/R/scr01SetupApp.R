# Load auxiliary files
azmetStations <- vroom::vroom(
  file = "aux-files/azmet-stations-api-db.csv", 
  delim = ",", 
  col_names = TRUE, 
  show_col_types = FALSE
)

# Omit for now, as previous years are not complete and conditional statements to handle this are not in place
azmetStations <- azmetStations |>
  dplyr::filter(stationName != "Mohave ETo") |>
  dplyr::filter(stationName != "Wellton ETo") |>
  dplyr::filter(stationName != "Yuma Valley ETo")

# Set auxiliary variables
apiStartDate <- as.Date("2021-01-01")

etEquations <- c("Original AZMet", "Penman-Monteith")

initialStartDate <- Sys.Date() - lubridate::dmonths(x = 1)
initialEndDate <- Sys.Date() - 1
