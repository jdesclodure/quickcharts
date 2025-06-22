#' Filter data
#' @description filtering data
#' @param data A data-frame
#' @param indicateur Subject of study
#' @param correction CVS or BRUT
#' @param freq M, T or A (mensuelle, etc.)
#' @param activite filtrer par rapport à colonne dont le libellé est fourni
#'
#' @return A filtered data-frame
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom rlang ".data"
#' @export
filter_data <- function(data, indicateur=NULL, correction=NULL, freq=NULL,
                        activite=NULL) {
  data_filtered <-
    data %>%
    dplyr::filter(if (!is.null(indicateur)) INDICATEUR == indicateur else T) %>%
    dplyr::filter(if (!is.null(correction)) CORRECTION == correction else T) %>%
    dplyr::filter(if (!is.null(freq)) FREQ == freq else T) %>%
    dplyr::filter(if (!is.null(activite)) get(activite[[1]]) %in% activite[[2]] else T) %>%
    dplyr::filter(!is.na(OBS_VALUE))
  
  return(data_filtered)
}