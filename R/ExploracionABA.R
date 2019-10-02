.SelectDataset <- function(selected.dataset) {
  if (selected.dataset == "dataset_adult") {
    utils::data("dataset_adult", package = "ABAData", envir = environment())
    selected.dataset <- dataset_adult
  } else if(selected.dataset == "dataset_5_stages") {
    utils::data("dataset_5_stages", package = "ABAData", envir = environment())
    selected.dataset <- dataset_5_stages
  } else if(selected.dataset == "dataset_dev_effect") {
    utils::data("dataset_dev_effect", package = "ABAData", envir = environment())
    selected.dataset <- dataset_dev_effect
  } else {
    stop("Base de datos no encontrada")
  }
  data.table::setDT(selected.dataset)
  return(selected.dataset)
}


#' Obtiene todas las areas disponibles
#'
#' @param selected.dataset Selección de una de las tres bases de datos existente, esta función tambien acepta un data.frame
#' con los números de area que querramos identificar en una columna llamada structure.
#'
#' @return Data table con todas las areas disponibles en la base de datos
#' @export
#'
#'
#' @importFrom methods is
#'
#' @examples
#' all.areas <- GetDatasetAreasSimplified()
GetDatasetAreasSimplified <- function(selected.dataset = "dataset_adult") {
  if(is(selected.dataset, "character")) {
    selected.dataset <- .SelectDataset(selected.dataset)
  }
  all.areas <- ABAEnrichment::get_id('')
  data.table::setDT(all.areas)
  all.areas[, structure := tolower(structure)]
  all.areas[, structure_id := gsub("^.*:", "", structure_id)]
  all.areas <- unique(all.areas[structure_id %in% unique(selected.dataset$structure), .(structure, structure_id)])
  return(all.areas[])
}

#' Obtiene las areas relacionadas con un Gen específico
#'
#' @param gene.name.pattern Nombre completo o nombre parcial del gen en cuestión
#' @param selected.dataset Selección de una de las tres bases de datos disponibles en ABA
#'
#' @return Data.table con las areas en las que se expresa el gen seleccionado.
#' @export
#'
#' @seealso \code{\link{GetAreasGenes}} para obtener areas
#'
#' @importFrom data.table %like%
#
#'
#' @examples
#' GetGenAreas(gene.name.pattern = 'A1BG', selected.dataset = "dataset_5_stages")
GetGenAreas <- function(gene.name.pattern, selected.dataset = "dataset_adult") {
  selected.dataset <- .SelectDataset(selected.dataset)
  gene.dataset <- selected.dataset[hgnc_symbol %like% gene.name.pattern]
  if(nrow(gene.dataset) == 0) {
    stop("Gene not found")
  }
  unique.areas <- unique(gene.dataset$structure)
  area.names <- data.table::data.table(structure = unique.areas, structure.name = ABAEnrichment::get_name(unique.areas))
  gene.dataset <- merge(gene.dataset, area.names)
  return(gene.dataset)
}

#' Obtiene los genes que se expresan en una area
#'
#' @param area.selected Nombre completo o nombre parcial del area de la que se quieren obtener los genes expresados
#' @param selected.dataset Selección de una de las tres bases de datos disponibles en ABA
#'
#' @return Cata.table con los genes expresados en el área seleccionada
#' @export
#'
#' @seealso \code{\link{GetGenAreas}} para obtener areas
#'
#' @importFrom data.table %like% :=
#'
#' @examples
#' GetAreasGenes(area.selected = 'accumbens', selected.dataset = "dataset_adult")
GetAreasGenes <-function(area.selected = 'accumbens', selected.dataset = "dataset_adult"){
  selected.dataset <- .SelectDataset(selected.dataset)
  area.selected <- tolower(area.selected)
  all.areas <- GetDatasetAreasSimplified(selected.dataset)
  area.id <- all.areas[grepl(area.selected, structure), unique(structure_id)]
  area.dataset <- selected.dataset[structure %in% area.id]
  if(nrow(area.dataset) == 0) {
    stop("Area not found")
  }
  return(area.dataset)
}
