# Quick And Dirty ABA Análisis

<!-- badges: start -->
<!-- badges: end -->

Este paquete intenta facilitar la exploración de las librerías de expresión genética de adultos y humanos en desarrollo
relacionados con el Allen Brain Atlas.

No pretende suplantar el uso del paquete `ABAEnrichment`, solo simplificarlo para los alumnos de la clase de 
**Diseño experimental** en la licenciatura de Neurobiología.

## Instalación

El primer paso es instalar el paquete `devtools()`

```r
install.packages('devtools')
```

Suponiendo que ya se tienen instalados los paquetes de ABA, lo siguiente es instalar el paquete `QuickAndDirtyABAAnalisis()`
 de no tener los paquetes instalados, podemos usar los comandos de la [siguiente sección](#primero-instalamos-el-manager-de-bioconductor)

``` r
devtools::install_github('nekrum/QuickAndDirtyABAAnalisis')
```

## Problemas con ABA


El paquete ABA no tiene una instalación similar a la que generalmente se realiza con los paquetes de R, por lo que puede
haber problemas en la instalación. En caso de que la instalación se dificulte, es posible instalar los paquetes de manera
separada.

### Primero instalamos el manager de Bioconductor

```r
install.packages("BiocManager")
```

### Despues con el **manager** instalamos el paquete de datos ABA

```r
BiocManager::install("ABAData")
```

### Luego podemos intalar el paquete **ABAEnrichment**

```r
BiocManager::install("ABAEnrichment")
```

## Uso

Con el paquete instalado solo falta **cargarlo** y usarlo.

Se carga el paquete:

``` r
library(QuickAndDirtyABAAnalisis)
```

### Para buscar areas relacionadas con un Gen

```r
GetGenAreas(gene.name.pattern = 'A1BG', selected.dataset = "dataset_5_stages")
```

### Para buscar genes expresados en un area

```r
GetAreasGenes(area.selected = 'accumbens', selected.dataset = "dataset_adult")
```
### Para obtener todas las areas de un dataset

```r
GetDatasetAreasSimplified(selected.dataset = 'dataset_5_stages')
```
