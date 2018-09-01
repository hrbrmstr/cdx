
# cdx

Query Web Archive Crawl Indexes (‘CDX’)

## Description

Methods are provided to retrieve web archive crawl index (‘CDX’)
metadata and directly query the ‘CDX’ ‘API’ endpoint to retrieve
mementos for a given set of parameters.

## What’s Inside The Tin

The following functions are implemented:

  - `cdx_query`: Query a CDX index endpoint
  - `fetch_collections_index`: Fetch collections index

## Installation

``` r
devtools::install_github("hrbrmstr/cdx")
```

## Usage

``` r
library(cdx)
library(tidyverse)

# current verison
packageVersion("cdx")
```

    ## [1] '0.1.0'

### Example

``` r
cidx <- fetch_collections_index()

rprj <- cdx_query(cidx$cdx_api[1], "*.r-project.org")

rprj
```

    ## # A tibble: 14,358 x 12
    ##    urlkey          timestamp      length url    mime_detected offset  mime  filename    status languages charset digest
    ##  * <chr>           <chr>          <chr>  <chr>  <chr>         <chr>   <chr> <chr>       <chr>  <chr>     <chr>   <chr> 
    ##  1 org,r-project)/ 20180818010708 2835   http:… text/html     567295… text… crawl-data… 200    eng       UTF-8   WTRYJ…
    ##  2 org,r-project)/ 20180819003057 700    http:… text/html     7358684 text… crawl-data… 301    <NA>      <NA>    RGN4E…
    ##  3 org,r-project)/ 20180819003057 2834   http:… text/html     550642… text… crawl-data… 200    eng       UTF-8   WTRYJ…
    ##  4 org,r-project)/ 20180819003103 702    https… text/html     207506… text… crawl-data… 301    <NA>      <NA>    AMYSZ…
    ##  5 org,r-project)/ 20180819003103 2839   https… text/html     971885… text… crawl-data… 200    eng       UTF-8   WTRYJ…
    ##  6 org,r-project)/ 20180819194145 2832   http:… text/html     537747… text… crawl-data… 200    eng       UTF-8   WTRYJ…
    ##  7 org,r-project)/ 20180820013726 2832   http:… text/html     570313… text… crawl-data… 200    eng       UTF-8   WTRYJ…
    ##  8 org,r-project)/ 20180820102922 556    https… <NA>          256576… warc… crawl-data… 304    <NA>      <NA>    3I42H…
    ##  9 org,r-project)/ 20180821155855 702    https… text/html     208822… text… crawl-data… 301    <NA>      <NA>    AMYSZ…
    ## 10 org,r-project)/ 20180821155857 2837   https… text/html     962600… text… crawl-data… 200    eng       UTF-8   WTRYJ…
    ## # ... with 14,348 more rows
