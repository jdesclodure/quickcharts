#' Download series data with IDBANK
#' @description downloading data with an idbank
#' @param id IDBANK
#'
#' @return A data-frame
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom rlang ".data"
#' @export
get_data_with_id <- function(id) {
  
  data <- insee::get_insee_idbank(id) %>%
    insee::add_insee_metadata() %>%
    dplyr::select(!dplyr::contains("label_en")) %>%
    dplyr::filter(!is.na(OBS_VALUE))

  return(data)

}
