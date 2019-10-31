# Quick And Dirty ABA Análisis

<!-- badges: start -->
<!-- badges: end -->

Este paquete intenta facilitar la exploración de las librerías de expresión genética de adultos y humanos en desarrollo
relacionados con el Allen Brain Atlas.

No pretende suplantar el uso del paquete `ABAEnrichment`, solo simplificarlo para los alumnos de la clase de 
**Diseño experimental** en la licenciatura de Neurobiología.

## Instalación


### Instalando paquetes ABA

Un requerimiento importante de este paquete son **ABAData** y **ABAEnrichment**, estos dos paquetes requieren estar 
instalados.

El paquete ABA no tiene una instalación similar a la que generalmente se realiza con los paquetes de R, por lo que puede
ser confuso. Sin embargo con los siguientes comandos quedaran instalados en la mayoría de los casos.

#### Primero instalamos el manager de Bioconductor

```r
install.packages("BiocManager")
```

#### Despues con el **manager** instalamos el paquete de datos ABA

```r
BiocManager::install("ABAData")
```

#### Luego podemos intalar el paquete **ABAEnrichment**

```r
BiocManager::install("ABAEnrichment")
```

### Instalación del paquete QuickAndDirtyABAAnalisis

El primer paso es instalar el paquete `devtools()`

```r
install.packages('devtools')
```

Despues utilizaremos la función `install_github()` de este paquete para terminar de instalar el paquete

``` r
devtools::install_github('nekrum/QuickAndDirtyABAAnalisis')
```

## Uso del paquete

Con el paquete instalado solo falta **cargarlo** 

Se carga el paquete:

``` r
library(QuickAndDirtyABAAnalisis)
```

Cualquier duda sobre el paquete o las funciones se puede consultar con el simbolo `?`

Por ejemplo para consultar la ayuda general de este paquete se puede ejecutar en la consola de R

```r
?QuickAndDirtyABAAnalisis
```

> **Nota** :
>
> Para que la ayuda funcione necesitamos haber cargado la librería como se menciona en el paso anterior

Esto desplegará la descripción de las funciones y el obejtivo de todo el paquete. Para explorar una función de R
y sus argumentos podemos revisar la ayuda del mismo

```r
?GetGenAreas
```

Dandonos una breve explicación de la función y sus comandos.

### Para buscar areas relacionadas con un Gen

Esta función nos permite buscar un gen por un aproximado de su nombre o por su identificador _ensembl_

```r
GetGenAreas(gene.name.pattern = 'A1BG', ensembl.id = 'ENSG', selected.dataset = "dataset_5_stages")
```

> **Nota:**
>
> Es importante destacar que solo se mostraran los **genes y las áreas** para el conjunto de datos definido con el 
argumento **selected.dataset**

### Para buscar genes expresados en un area

Esta función nos permite ver los genes y la expresión asociada a una area, la cual se puede buscar por un aprocimado de su
nombre con el argumento **structure.selected** o con el identificador de la estructura usando el argumento **structure.id**.

```r
GetAreasGenes(structure.selected = 'accumbens', structure.id = 4679, selected.dataset = "dataset_adult")
```

> **Nota:**
>
> Es importante destacar que solo se mostraran los **genes y las áreas** para el conjunto de datos definido con el 
argumento **selected.dataset**


### Para obtener todas las areas de un dataset

Extrae todas las areas que se encuentran dentro de un conjunto de datos definido por el argumento **selected.dataset**,
de aquí se puede obtener el identificador de una estructura que es quizá el mejor método para buscar un area con la 
función `GetAreasGen()`

```r
GetDatasetAreasSimplified(selected.dataset = 'dataset_5_stages')
```
