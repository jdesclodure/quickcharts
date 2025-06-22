library(dplyr)
library(insee)
library(plotly)
library(magrittr)
library(rmarkdown)
library(rlang)
library(stringr)
library(knitr)
library(tidyr)
library(httr)

# Désactiver le proxy pour une session spécifique
httr::set_config(use_proxy(url = NULL, port = NULL))

#' Run "Quick Charts"
#' @importFrom rmarkdown render
#' @examples
#' \donttest{
#' # run "quick charts"
#' }
#' @export
quickCharts <- function(){
  rmdfile <- system.file("rmd", "quickcharts.Rmd", package = "quickcharts")
  file_name <- paste0("conjoncture_graphiques_",
                      format(Sys.time(), "%Y-%m-%d_%Hh%M"),
                      ".html")
  rmarkdown::render(rmdfile, 
                    output_format = "html_document",
                    output_file = file_name,
                    output_dir = "html/")
}
