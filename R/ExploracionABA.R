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
#' Con esta función se puedne obtener todas las areas que tiene un dataset. Ademas proporciona la abreviación,
#' el identificador de área, si tiene un hemisferio definido y el nombre de la estructura.
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
  all.areas[, hemisphere := stringr::str_extract(structure, "right|left")]
  all.areas[, c("acronym", "structure") := data.table::tstrsplit(structure, "_")]
  all.areas <- unique(
    all.areas[structure_id %in% unique(selected.dataset$structure), .(structure, structure_id, hemisphere, acronym)]
  )
  return(all.areas[])
}

#' Obtiene las areas relacionadas con un Gen específico
#'
#' Con esta función se pueden buscar los genes estudiados en uno de los dataset, buscandolo por el nombre o por el
#' identificador ensembl.
#'
#' @param gene.name.pattern Nombre completo o nombre parcial del gen en cuestión
#' @param ensembl.id Nombre completo o nombre parcial del identificador
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
#' GetGenAreas(gene.name.pattern = 'A1BG',ensembl.id = 'ENSG', selected.dataset = "dataset_5_stages")
GetGenAreas <- function(gene.name.pattern = NULL, ensembl.id = NULL, selected.dataset = "dataset_adult") {
  if(is.null(gene.name.pattern) & is.null(ensembl.id)) {
    stop("Not gen provided")
  }
  selected.dataset <- .SelectDataset(selected.dataset)
  if(is.null(gene.name.pattern)) {
    gene.dataset <- selected.dataset[ensembl_gene_id %like% ensembl.id]
  } else if(is.null(ensembl.id)) {
    gene.dataset <- selected.dataset[hgnc_symbol %like% gene.name.pattern]
  } else (
    gene.dataset <- selected.dataset[hgnc_symbol %like% gene.name.pattern & ensembl_gene_id %like% ensembl.id]
  )
  if (nrow(gene.dataset) == 0) {
    stop("Gen not found")
  }
  unique.areas <- unique(gene.dataset$structure)
  area.names <- data.table::data.table(structure = unique.areas, structure.name = ABAEnrichment::get_name(unique.areas))
  gene.dataset <- merge(gene.dataset, area.names)
  return(gene.dataset)
}

#' Obtiene los genes que se expresan en una area
#'
#' A partir del area seleccionada se pueden identificar los genes expresados dentro de la base seleccionada.
#'
#' @param area.selected Nombre completo o nombre parcial del area de la que se quieren obtener los genes expresados
#' @param structure.id Identificador del area de la que se quieren obtener los genes expresados
#' @param selected.dataset Selección de una de las tres bases de datos disponibles en ABA
#'
#' @return data.table con los genes expresados en el área seleccionada
#' @export
#'
#' @seealso \code{\link{GetGenAreas}} para obtener areas
#'
#' @importFrom data.table %like% :=
#'
#' @examples
#' GetAreasGenes(structure.selected = 'accumbens', selected.dataset = "dataset_adult")
#' GetAreasGenes(structure.id = 4679, selected.dataset = "dataset_adult")
#' GetAreasGenes(structure.selected = 'accumbens', structure.id = 4679, selected.dataset = "dataset_adult")
GetAreasGenes <-function(structure.selected = NULL, structure.id = NULL, selected.dataset = "dataset_adult"){
  if(is.null(structure.selected) & is.null(structure.id)) {
    stop("Not structure provided")
  }
  selected.data <- .SelectDataset(selected.dataset)
  all.areas <- GetDatasetAreasSimplified(selected.dataset)
  if (any(
      is.null(structure.selected),
      is.na(structure.selected),
      is.numeric(structure.selected),
      structure.selected == ""
    ) & !is.null(structure.id)) {
    if(!is.numeric(as.numeric(structure.id))) {
      stop("Not valid structure id")
    }
    area.dataset <- selected.data[structure %in% structure.id]
  } else if(
    any(
      is.null(structure.id), is.na(structure.id), is.numeric(structure.id), structure.id == ""
    ) & !is.null(structure.selected)
  ) {
    structure.selected <- tolower(structure.selected)
    area.id <- all.areas[grepl(structure.selected, tolower(structure)), unique(structure_id)]
    area.dataset <- selected.data[structure %in% area.id]
  } else {
    if(!is.numeric(as.numeric(structure.id))) {
      stop("Not valid structure id")
    }
    structure.selected <- tolower(structure.selected)
    area.id <- all.areas[grepl(structure.selected, tolower(structure)), unique(structure_id)]
    area.dataset <- selected.data[structure %in% c(area.id, structure.id)]
  }
  if(nrow(area.dataset) == 0) {
    stop("Area not found")
  }
  return(area.dataset)
}
