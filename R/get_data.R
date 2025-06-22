#' Download series data from Insee BDM API
#' @description downloading data
#' @param domaine Domain of the serie
#' @param indicateur Subject of study
#' @param correction CVS or BRUT
#' @param freq M, T or A (mensuelle, etc.)
#' @param activite filtrer par rapport à colonne dont le libellé est fourni
#'
#' @return A data-frame
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom rlang ".data"
#' @export
get_data <- function(domaine, indicateur=NULL, correction=NULL, freq=NULL,
                     activite=NULL) {
  idbank_list_selected <-
    insee::get_idbank_list(domaine) %>%
    dplyr::filter(if (!is.null(indicateur)) INDICATEUR == indicateur else T) %>%
    dplyr::filter(if (!is.null(correction)) CORRECTION == correction else T) %>%
    dplyr::filter(if (!is.null(freq)) FREQ == freq else T) %>%
    dplyr::filter(if (!is.null(activite)) get(activite[[1]]) %in% activite[[2]] else T)
  
  data_selected <-
    insee::get_insee_idbank(idbank_list_selected$idbank) %>%
    insee::add_insee_metadata() %>%
    dplyr::select(!dplyr::contains("label_en")) %>%
    dplyr::filter(!is.na(OBS_VALUE))
  
  return(data_selected)
}