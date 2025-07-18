# Libraries --------------------

library(azmetr)
library(bsicons)
library(bslib)
library(dplyr)
library(ggplot2)
library(htmltools)
library(lubridate)
library(shiny)
library(vroom)


# Files --------------------

# Functions. Loaded automatically at app start if in `R` folder
#source("./R/fxn_functionName.R", local = TRUE)

# Scripts. Loaded automatically at app start if in `R` folder
#source("./R/scr_scriptName.R", local = TRUE)

# azmetStationMetadata <- 
#   vroom::vroom(
#     file = "aux-files/azmet-station-metadata.csv", 
#     delim = ",", 
#     col_names = TRUE, 
#     show_col_types = FALSE
#   )


# Variables --------------------

apiStartDate <- as.Date("2021-01-01")

# Omit for now, as previous years are not complete and conditional statements to handle this are not in place
# azmetStations <- azmetStations |>
#   dplyr::filter(stationName != "Mohave ETo") |>
#   dplyr::filter(stationName != "Wellton ETo") |>
#   dplyr::filter(stationName != "Yuma Valley ETo")

azmetStationMetadata <- azmetr::station_info |>
  dplyr::mutate(end_date = NA) |> # Placeholder until inactive stations are in API and `azmetr`
  dplyr::mutate(
    end_date = dplyr::if_else(
      status == "active",
      lubridate::today(tzone = "America/Phoenix") - 1,
      end_date
    )
  )

etEquations <- c("Original AZMet", "Penman-Monteith")
