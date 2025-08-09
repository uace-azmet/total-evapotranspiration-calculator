# Calculate evapotranspiration totals by station, equation, and date range


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageFluid = bslib::page_fluid(
    title = NULL,
    theme = theme, # `scr##_theme.R`
    
    bslib::layout_sidebar(
      sidebar = sidebar, # `scr##_sidebar.R`
      
      shiny::htmlOutput(outputId = "figureTitle"),
      # shiny::htmlOutput(outputId = "figureSummary"),
      # shiny::htmlOutput(outputId = "figureHelpText"),
      # #shiny::plotOutput(outputId = "figure"),
      plotly::plotlyOutput(outputId = "figure"),
      # shiny::htmlOutput(outputId = "figureFooter")
    ) |>
      htmltools::tagAppendAttributes(
        #https://getbootstrap.com/docs/5.0/utilities/api/
        class = "border-0 rounded-0 shadow-none"
      ),
    
    shiny::htmlOutput(outputId = "pageBottomText")
  )
) # htmltools::htmlTemplate()
  
    
    # mainPanel(
    #   id = "mainPanel",
    #   width = 8,
    #   
    #   fluidRow(
    #     column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "figureTitle"))
    #   ), 
    #   
    #   fluidRow(
    #     column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "figureSubtitle"))
    #   ),
    #   
    #   br(),
    #   fluidRow(
    #     column(width = 11, align = "left", offset = 1, plotOutput(outputId = "figure"))
    #   ), 
    #   
    #   br(),
    #   fluidRow(
    #     column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "figureSubtext"))
    #   ),
    #   
    #   br(), br(),
    #   fluidRow(
    #     column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "figureFooterHelpText"))
    #   ),
    #   
    #   fluidRow(
    #     column(width = 11, align = "left", offset = 1, htmlOutput(outputId = "figureFooter"))
    #   ),
    #   br()
    # ) # mainPanel()


# Server --------------------

server <- function(input, output, session) {
  shinyjs::useShinyjs(html = TRUE)
  shinyjs::hideElement("pageBottomText")
  
  
  # Observables -----
  
  shiny::observeEvent(input$calculateTotal, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
    }
  })
  
  shiny::observeEvent(seasonalTotals(), {
    shinyjs::showElement("pageBottomText")
  })
  

  # Reactives -----
  
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

    fxn_seasonalTotals(
      azmetStation = input$azmetStation,
      startDate = input$startDate,
      endDate = input$endDate,
      etEquation = input$etEquation
    )
  })
  
  # AZMet evapotranspiration data
  # dataAZMetDataMerge <- eventReactive(input$calculateTotalET, {
  #   validate(
  #     need(expr = input$startDate <= input$endDate, message = FALSE)
  #   )
  #   
  #   idCalculatingTotalET <- showNotification(
  #     ui = "Calculating total evapotranspiration . . .", 
  #     action = NULL, 
  #     duration = NULL, 
  #     closeButton = FALSE,
  #     id = "idCalculatingTotalET",
  #     type = "message"
  #   )
  #   
  #   on.exit(removeNotification(id = idCalculatingTotalET), add = TRUE)
  #   
  #   # Calls 'fxnAZMetDataELT()' and 'fxnAZMetDataTotalET()'
  #   fxnAZMetDataMerge(
  #     azmetStation = input$azmetStation, 
  #     startDate = input$startDate, 
  #     endDate = input$endDate,
  #     etEquation = input$etEquation
  #   )
  # })
  
  # Build figure
  # figure <- eventReactive(dataAZMetDataMerge(), {
  #   fxnFigure(
  #     inData = dataAZMetDataMerge(), 
  #     azmetStation = input$azmetStation,
  #     startDate = input$startDate, 
  #     endDate = input$endDate
  #   )
  # })
  
  # Build figure footer
  # figureFooter <- eventReactive(dataAZMetDataMerge(), {
  #   fxnFigureFooter(
  #     azmetStation = input$azmetStation,
  #     startDate = input$startDate, 
  #     endDate = input$endDate,
  #     etEquation = input$etEquation, 
  #     timeStep = "Daily"
  #   )
  # })
  
  # Build figure footer help text
  # figureFooterHelpText <- eventReactive(dataAZMetDataMerge(), {
  #   fxnFigureFooterHelpText()
  # })
  
  # Build figure subtext
  # figureSubtext <- eventReactive(dataAZMetDataMerge(), {
  #   fxnFigureSubtext(
  #     azmetStation = input$azmetStation,
  #     startDate = input$startDate, 
  #     endDate = input$endDate
  #   )
  # })
  
  # Build figure subtitle
  # figureSubtitle <- eventReactive(dataAZMetDataMerge(), {
  #   fxnFigureSubtitle(
  #     azmetStation = input$azmetStation, 
  #     startDate = input$startDate, 
  #     endDate = input$endDate,
  #     inData = dataAZMetDataMerge()
  #   )
  # })
  
  figure <- shiny::eventReactive(seasonalTotals(), {
    fxn_figure(
      inData = seasonalTotals(),
      azmetStation = input$azmetStation
    )
  })
  
  figureTitle <- shiny::eventReactive(seasonalTotals(), {
    fxn_figureTitle(
      azmetStation = input$azmetStation
      # endDate = input$endDate,
      # inData = dataAZMetDataMerge()
    )
  })
  
  
  # Outputs -----
  
  output$figure <- plotly::renderPlotly({
    figure()
  })
  
  output$figureTitle <- shiny::renderUI({
    figureTitle()
  })
  
  output$pageBottomText <- shiny::renderUI({
    #shiny::req(seasonalTotals())
    fxn_pageBottomText()
  })
  
  # output$figure <- renderPlot({
  #   figure()
  # }, res = 96)
  
  # output$figureFooter <- renderUI({
  #   figureFooter()
  # })
  
  # output$figureFooterHelpText <- renderUI({
  #   figureFooterHelpText()
  # })
  
  # output$figureSubtext <- renderUI({
  #   figureSubtext()
  # })
  
  # output$figureSubtitle <- renderUI({
  #   figureSubtitle()
  # })
  
  
}

# Run --------------------

shinyApp(ui = ui, server = server)
