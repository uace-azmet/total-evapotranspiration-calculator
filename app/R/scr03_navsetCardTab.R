navsetCardTab <- bslib::navset_card_tab(
  id = "navsetCardTab",
  selected = "barChart",
  title = NULL,
  sidebar = NULL,
  header = NULL,
  footer = NULL,
  height = 600,
  full_screen = TRUE,
  # wrapper = card_body,
  
  bslib::nav_panel(
    title = "Bar Chart",
    value = "barChart",
    
    plotly::plotlyOutput(outputId = "barChart"),
    shiny::htmlOutput(outputId = "barChartCaption")
  ),
  
  bslib::nav_panel(
    title = "Table",
    value = "table",
    
    shiny::tableOutput("totalEvapotranspiration"),
    #   shiny::htmlOutput(outputId = "timeseriesGraphFooter")
  ),
  
  bslib::nav_panel(
    title = "Time Series",
    value = "timeSeries"#,
    
    # shiny::htmlOutput(outputId = "validationText")
  ),
  
  bslib::nav_item(
    shiny::uiOutput(outputId = "navsetCardTabTooltip")
  )
) |>
  htmltools::tagAppendAttributes(
    #https://getbootstrap.com/docs/5.0/utilities/api/
    class = "border-0 rounded-0 shadow-none"
  )
