#' Fetch collections index
#'
#' Retrieves a collections index list and returns it as a data frame. Default
#' is to use the [Common Crawl Collections Index](http://index.commoncrawl.org/)
#'
#' @md
#' @param cidx_url URL to use for the fetch. Defaults to <http://index.commoncrawl.org/collinfo.json>
#' @return data frame
#' @export
#' @examples
#' fetch_collections_index()
fetch_collections_index <- function(cidx_url = "http://index.commoncrawl.org/collinfo.json") {

  out <- jsonlite::fromJSON(cidx_url)
  out <- mcga(out)
  class(out) <- c("tbl_df", "tbl", "data.frame")
  out

}