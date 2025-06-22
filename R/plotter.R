#' plotter
#' @description generating data
#' @param data Data frame
#' @param groupby Group to multiplot
#' @param xlabel xlabel
#' @param ylabel ylabel
#' @param top_margin top margin above plot
#' @param title_y_position top title position
#' @param length_labels length of labels while hovering
#' @param title Title of plot
#' @return A plot 
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom rlang ".data"
#' @importFrom stringr str_trunc
#' @export
#'
plotter <- function(
    data, groupby, title='', xlabel ='', ylabel='', top_margin = 0,
    title_y_position = 1.5, length_labels = 30
){
  MIN_DATE = min(data$DATE)
  MAX_DATE = max(data$DATE)
  
  range_start = max(as.Date("2019-01-01"), MIN_DATE)
  range_end = MAX_DATE
  if (range_start >= range_end) { range_start = MIN_DATE }
  
  if (ylabel=='') { 
    ylabel = data$NATURE_label_fr[1] 
    if (data$UNIT_MEASURE_label_fr[1] != "sans objet") {
      ylabel <- paste0(ylabel, " (Unité : ", data$UNIT_MEASURE_label_fr[1], ")")
    }
  }
  
  plotly::plot_ly(
    data, x = ~DATE, y = ~OBS_VALUE, color = ~get(groupby),
    type = 'scatter', mode = 'lines',
    hovertemplate = paste(
      stringr::str_trunc(data %>% pull(groupby), length_labels, "right"),
      ":", '%{y:.1f}<extra></extra>'
    ),
    textposition = 'outside',
    height = max(680, 650 +  16 * nrow(unique(data[colnames(data) == groupby])))
  ) %>%
    plotly::config(displaylogo = F, locale = 'fr') %>%
    plotly::layout(
      hovermode = "x unified", 
      xaxis = list(
        title = xlabel,
        range = c(range_start, range_end),
        rangeslider = list(borderwidth = 1, thickness = 0.09, start = MIN_DATE, end = MAX_DATE),
        yaxis = list(rangemode = "auto"),
        tickformat = "%b %Y",
        ticklabelmode="period",
        rangeselector = list(
          buttons = list(
            list(count = 3, label = "3 mois", step = "month", stepmode = "backward"),
            list(count = 6, label = "6 mois", step = "month", stepmode = "backward"),
            list(count = 9, label = "9 mois", step = "month", stepmode = "backward"),
            list(count = 1, label = "1 an", step = "year", stepmode = "backward"),
            list(count = 2, label = "2 ans", step = "year", stepmode = "backward"),
            list(count = 3, label = "3 ans", step = "year", stepmode = "backward"),
            list(count = 10, label = "10 ans", step = "year", stepmode = "backward"),
            list(count = 1, label = "Ann\u00e9e civile", step = "year", stepmode = "todate"),
            list(step = "all", label = "Tout")
          )
        ),
        type = "date"
      ),
      yaxis = list(title = ylabel, autorange = T, fixedrange = F),
      title = list('text' = title, y = title_y_position, xanchor = "center", yanchor = "top"),
      legend = list(
        orientation = 'h', x=0, y=-0.22, xanchor = "left", yanchor = "top",
        rm_rep_text = T, rm_nonfirst_gr = T
      ),
      annotations = list(
        x = 0, y = 1, yanchor = "auto",
        text = paste0(
          "Dernier point : ", format(max(data$DATE), "%d/%m/%Y"), ".", 
          " Source : BDM Insee."
        ), 
        showarrow = F, 
        xref='paper', 
        yref='paper'
      ),
      margin = list(t = top_margin)
    )
}
