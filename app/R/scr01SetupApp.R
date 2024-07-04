# Load auxiliary files
azmetStations <- vroom::vroom(
  file = "aux-files/azmet-stations-api-db.csv", 
  delim = ",", 
  col_names = TRUE, 
  show_col_types = FALSE
)

# Set auxiliary variables
etEquations <- c("Original AZMet", "Penman-Monteith")

initialStartDate <- Sys.Date() - lubridate::dmonths(x = 1)
initialEndDate <- Sys.Date() - 1
