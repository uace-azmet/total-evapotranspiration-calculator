# Calculate evapotranspiration totals by station, equation, and date range


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageTotalEvapotranspirationCalculator = bslib::page(
    title = NULL,
    theme = theme, # `scr##_theme.R`
    
    bslib::layout_sidebar(
      sidebar = sidebar, # `scr##_sidebar.R`
      shiny::htmlOutput(outputId = "navsetCardTabTitle"),
      shiny::htmlOutput(outputId = "navsetCardTabSummary"),
      shiny::uiOutput(outputId = "navsetCardTab")
    ) |>
      htmltools::tagAppendAttributes(
        #https://getbootstrap.com/docs/5.0/utilities/api/
        class = "border-0 rounded-0 shadow-none"
      ),
    
    shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
  )
)


# Server --------------------

server <- function(input, output, session) {
  # shinyjs::useShinyjs(html = TRUE)
  # shinyjs::hideElement("pageBottomText")
  
  
  # Observables -----
  
  shiny::observeEvent(seasonalTotals(), {
    showNavsetCardTab(TRUE)
    showPageBottomText(TRUE)
    # shinyjs::showElement("pageBottomText")
  })
  
  # To update available dates based on selected station
  shiny::observeEvent(input$azmetStation, {
    stationStartDate <-
      dplyr::filter(
        azmetStationMetadata,
        meta_station_name == input$azmetStation
      )$start_date
    
    if (stationStartDate > Sys.Date() - lubridate::years(1)) {
      stationStartDateMinimum <- stationStartDate
      stationEndDateMinimum <- stationStartDate
    } else {
      stationStartDateMinimum <- Sys.Date() - lubridate::years(1)
      stationEndDateMinimum <- Sys.Date() - lubridate::years(1)
    }
    
    if (stationStartDate > input$startDate) {
      stationStartDateSelected <- stationStartDate
    } else {
      stationStartDateSelected <- input$startDate
    }
    
    if (stationStartDate > input$endDate) {
      stationEndDateSelected <- stationStartDate
    } else {
      stationEndDateSelected <- input$endDate
    }
    
    shiny::updateDateInput(
      inputId = "startDate",
      label = "Start Date",
      value = stationStartDateSelected,
      min = stationStartDateMinimum,
      max = Sys.Date() - 1
    )
    
    shiny::updateDateInput(
      inputId = "endDate",
      label = "End Date",
      value = stationEndDateSelected,
      min = stationEndDateMinimum,
      max = Sys.Date() - 1
    )
  })
  
  shiny::observeEvent(input$calculateTotal, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
    }
  })
  
  # To update icon in navsetCardTab title
  shiny::observeEvent(input$navsetCardTab, {
    if (input$navsetCardTab == "barChart") {
      navsetCardTabTitleIcon("bar-chart-fill")
      print("bar-chart-fill")
    } else if (input$navsetCardTab == "table") {
      navsetCardTabTitleIcon("table")
      print("table")
    } else if (input$navsetCardTab == "timeSeries") {
      navsetCardTabTitleIcon("graph-up")
      print("graph-up")
    }
    
  # shiny::observeEvent(seasonalTotals(), {
  #   shinyjs::showElement("pageBottomText")
  # })
  })
  

  # Reactives -----
  
  barChart <- shiny::eventReactive(seasonalTotals(), {
    fxn_barChart(
      inData = seasonalTotals(),
      azmetStation = input$azmetStation
    )
  })
  
  barChartCaption <- shiny::eventReactive(seasonalTotals(), {
    fxn_barChartCaption(
      azmetStation = input$azmetStation,
      inData = seasonalTotals(),
      startDate = input$startDate,
      endDate = input$endDate,
      etEquation = input$etEquation
    )
  })
  
  navsetCardTabSummary <- shiny::eventReactive(seasonalTotals(), {
    fxn_navsetCardTabSummary(
      azmetStation = input$azmetStation,
      inData = seasonalTotals(),
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  navsetCardTabTitle <- shiny::eventReactive(list(navsetCardTabTitleIcon(), seasonalTotals()), {
    fxn_navsetCardTabTitle(
      azmetStation = input$azmetStation,
      navsetCardTabTitleIcon = navsetCardTabTitleIcon()
    )
  })
  
  navsetCardTabTooltipText <- shiny::eventReactive(input$navsetCardTab, {
    fxn_navsetCardTabTooltipText(
      navsetCardTab = input$navsetCardTab
    )
  })
  
  pageBottomText <- shiny::eventReactive(seasonalTotals(), {
    fxn_pageBottomText(
      startDate = input$startDate, 
      endDate = input$endDate,
      etEquation = input$etEquation
    )
  })
  
  seasonalTotals <- shiny::eventReactive(input$calculateTotal, {
    shiny::validate(
      shiny::need(
        expr = input$startDate <= input$endDate,
        message = FALSE
      )
    )
    
    idCalculateTotal <- shiny::showNotification(
      ui = "Calculating total evapotranspiration . . .",
      action = NULL,
      duration = NULL,
      closeButton = FALSE,
      id = "idCalculateTotal",
      type = "message"
    )
    
    on.exit(
      shiny::removeNotification(id = idCalculateTotal),
      add = TRUE
    )
    
    fxn_seasonalTotals( # calls `fxn_dailyData.R` and `fxn_etTotal.R`
      azmetStation = input$azmetStation,
      startDate = input$startDate,
      endDate = input$endDate,
      etEquation = input$etEquation
    )
  })
  
  
  # Outputs -----
  
  output$barChart <- plotly::renderPlotly({
    barChart()
  })
  
  output$barChartCaption <- shiny::renderUI({
    barChartCaption()
  })
  
  output$navsetCardTab <- shiny::renderUI({
    shiny::req(showNavsetCardTab())
    navsetCardTab # `scr##_navsetCardTab.R`
  })
  
  output$navsetCardTabSummary <- shiny::renderUI({
    navsetCardTabSummary()
  })
  
  output$navsetCardTabTitle <- shiny::renderUI({
    navsetCardTabTitle()
  })
  
  output$navsetCardTabTooltip <- shiny::renderUI({
    navsetCardTabTooltipText()
  })
  
  output$pageBottomText <- shiny::renderUI({
    shiny::req(showPageBottomText())
    pageBottomText()
  })
}

# Run --------------------

shiny::shinyApp(ui = ui, server = server)
