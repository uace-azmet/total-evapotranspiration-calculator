#' `fxn_figure` generates bar chart of cumulative heat units of current and recent years with cotton growth stage labels
#' 
#' @param inData - data table of seasonal heat accumulation values by year
#' @param azmetStation - user-specified AZMet station
#' @return `figure` - plotly figure

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596
# https://www.color-hex.com/color-palette/1041718


fxn_figure <- function(inData, azmetStation) {
  
  # Inputs -----
  
  dataCurrentYear <- inData %>% 
    dplyr::filter(endDateYear == max(endDateYear)) %>%
    dplyr::mutate(endDateYear = as.factor(endDateYear))
    #dplyr::mutate(dateYearLabel = as.factor(dateYearLabel))
  
  dataOtherYears <- inData %>% 
    dplyr::filter(endDateYear != max(endDateYear)) %>% 
    dplyr::mutate(endDateYear = as.factor(endDateYear))
    #dplyr::mutate(dateYearLabel = as.factor(dateYearLabel))
  
  ticktext <- inData$dateYearLabel
  tickvals <- inData$endDateYear
  
  
  # Figure -----
  
  figure <- 
    plotly::plot_ly( # Bars for `dataOtherYears`
      data = dataOtherYears,
      x = ~endDateYear,
      y = ~etTotal,
      marker = list(color = "#989898"),
      name = "other years",
      showlegend = FALSE,
      hoverinfo = "text",
      hovertext = ~paste0(
        "<br><b>AZMet Station:</b>  ", azmetStation,
        "<br><b>Year:</b>  ", dateYearLabel,
        "<br><b>Total:</b>  ", etTotalLabel, " inches"
      ),
      type = "bar"
    ) %>% 
    
    plotly::add_trace( # Bar for `dataCurrentYear`
      inherit = FALSE,
      data = dataCurrentYear,
      x = ~endDateYear,
      y = ~etTotal,
      marker = list(color = "#191919"),
      name = "current year",
      showlegend = FALSE,
      hoverinfo = "text",
      hovertext = ~paste0(
        "<br><b>AZMet Station:</b>  ", azmetStation,
        "<br><b>Year:</b>  ", dateYearLabel,
        "<br><b>Total:</b>  ", etTotalLabel, " inches"
      ),
      type = "bar"
    ) %>%
    
    plotly::config(
      displaylogo = FALSE,
      displayModeBar = FALSE,
      modeBarButtonsToRemove = c(
        "autoScale2d",
        "hoverClosestCartesian", 
        "hoverCompareCartesian", 
        "lasso2d",
        "select"
      ),
      scrollZoom = FALSE,
      toImageButtonOptions = list(
        format = "png", # Either png, svg, jpeg, or webp
        filename = "AZMet-total-evapotranspiration-calculator",
        height = 400,
        width = 700,
        scale = 5
      )
    ) %>%
    
    plotly::layout(
      font = list(
        color = "#191919",
        family = "proxima-nova, calibri, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\"",
        size = 13
      ),
      hoverlabel = list(
        font = list(
          family = "proxima-nova, calibri, -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, \"Helvetica Neue\", Arial, \"Noto Sans\", sans-serif, \"Apple Color Emoji\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"Noto Color Emoji\"",
          size = 14
        )
      ),
      margin = list(
        l = 0,
        r = 0, # For space between plot and modebar
        b = 0,
        t = 10, # For space to show `3400` tick
        pad = 3 # For space between gridlines and yaxis labels
      ),
      modebar = list(
        bgcolor = "#FFFFFF",
        orientation = "v"
      ),
      shapes =
        list(
          type = "line",
          line = list(color = "blue", dash = "dot", width = "4px"),
          x0 = 0,
          x1 = 1,
          xref = "paper",
          y0 = 25, # Peak Bloom (Short)
          y1 = 25, # Peak Bloom (Long)
          yref = "y"
        ),
      xaxis = list(
        fixedrange = TRUE,
        linewidth = 0,
        ticktext = ticktext,
        tickvals = tickvals,
        title = list(
          font = list(size = 14),
          standoff = 25,
          text = "Year"
        ),
        zeroline = FALSE
      ),
      yaxis = list(
        fixedrange = TRUE,
        gridcolor = "#c9c9c9",
        title = list(
          font = list(size = 14),
          standoff = 25,
          text = "Inches"
        ),
        zeroline = TRUE,
        zerolinecolor = "#c9c9c9"
      )
    )
  figure
  
  return(figure)
}
