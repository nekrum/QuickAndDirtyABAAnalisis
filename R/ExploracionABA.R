#' Obtiene las areas relacionadas con un Gen específico
#'
#' @param gene.name.pattern Nombre completo o nombre parcial del gen en cuestión
#' @param selected.dataset Selección de una de las tres bases de datos disponibles en ABA
#'
#' @return
#' @export
#'
#'@import data.table
#'
#' @examples
#' GetGenAreas(gene.name.pattern = 'A1BG', selected.dataset = "dataset_5_stages")
GetGenAreas <- function(gene.name.pattern, selected.dataset = "dataset_adult") {
  utils::data(list = selected.dataset, envir = environment())
  data.table::setDT(get(selected.dataset))
  gene.dataset <- base::get(selected.dataset)[hgnc_symbol %like% gene.name.pattern]
  if(nrow(gene.dataset) == 0) {
    stop("Gene not found")
  }
  unique.areas <- unique(gene.dataset$structure)
  area.names <- data.table(structure = unique.areas, structure.name = get_name(unique.areas))
  gene.dataset <- merge(gene.dataset, area.names)
  return(gene.dataset)
}


#' Obtiene los genes que se expresan en una area
#'
#' @param area.pattern Nombre completo o nombre parcial del area de la que se quieren obtener los genes expresados
#' @param selected.dataset Selección de una de las tres bases de datos disponibles en ABA
#'
#' @return
#' @export
#'
#' @examples
GetAreasGenes <-function(area.pattern,  selected.dataset = "dataset_adult"){
  utils::data(list = selected.dataset, envir = environment())
  data.table::setDT(get(selected.dataset))
  area.dataset <- base::get(selected.dataset)[hgnc_symbol %like% gene.name.pattern]
  return(areas.dataset)
}
