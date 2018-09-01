#' Query a CDX index endpoint
#'
#' @md
#' @param cdx_api_endpoint the API endpoint to query. If using the Common Crawl CDX
#'        index (or a CDX server that mimics the CC metadata services), it's a good
#'        idea to use [fetch_collections_index()] first and then supply a value from
#'        the `cdx_api` column as the endpoint.
#' @param url host, url, wildcard to search for. e.g. `*.example.com`
#' @param include which fields to include in the output. The standard available
#'        fields are usually: `urlkey`, `timestamp`, `url`, `mime`, `status`,
#'        `digest`, `length`, `offset`, `filename`.
#' @param page page is the current page number, and defaults to 0 if omitted.
#'        If the page exceeds the number of available pages from the page count
#'        query, a 400 error will be returned.
#' @param from,to Setting `from=<ts>` or `to=<ts>` will restrict the results to the
#'        given date/time range (inclusive). Timestamps may be <=14 digits and
#'        will be padded to either lower or upper bound. For example,
#'        `from = 2014`, `to = 2014` will return results that have a timestamp
#'        between `20140101000000` and `20141231235959`
#' @param match_type Optional. If supplied, one of
#' - `exact`: default setting, will return captures that match the url exactly
#' - `prefix`: return captures that begin with a specified path, eg: `http://example.com/path/*`
#' - `host`: return captures which for a begin host (the path segment is ignored if specified)
#' - `domain`: return captures for the current host and all subdomains, eg. `*.example.com`
#'
#' As a shortcut, instead of specifying a separate `match_type` parameter,
#' wildcards may be used in the `url`. i.e. `url = 'http://example.com/path/*'` is
#' equivalent to `url = 'http://example.com/path/'` with `match_type = 'prefix'` and
#' `url = 'example.com'` with `match_type = 'domain'` is equivalent to
#' `url = '*.example.com'`.
#' @param limit limit the number of index lines returned. Limit must be set to
#'        a positive integer. If no limit is provided, all the matching lines
#'        are returned, which may be slow.
#' @param sort Options. If supplied, one of:
#' - `reverse`: will sort the matching captures in reverse order. It is only
#'   recommended for `exact` query as reverse a large match may be very slow.
#' - `closest`: setting this option also requires setting `closest = <ts>`
#'   where `<ts>` is a specific timestamp to sort by. This option will only
#'   work correctly for `exact` query and is useful for sorting captures based
#'   no time distance from a certain timestamp.
#'
#' Both options may be combined with `limit` to return the top N closest, or the last N results.
#' @export
#' @examples
#' cidx <- fetch_collections_index()
#' rprj <- cdx_query(cidx$cdx_api[1], "*.r-project.org")
cdx_query <- function(cdx_api_endpoint,
                      url,
                      include = c(
                        "urlkey", "timestamp", "url", "mime",
                        "status", "digest", "length", "offset", "filename"),
                      page = 0L,
                      from = NULL, to = NULL,
                      match_type = NULL, limit = NULL, sort = NULL) {

  include <- paste0(include, collapse=",")

  httr::GET(
    url = cdx_api_endpoint,
    query = list(
      output = "json",
      url = url,
      page = page,
      from = from,
      to = to,
      matchType = match_type,
      limit = limit,
      sort = sort
    ),
    httr::user_agent("cdx R pacakge; http://gitlab.com/hrbrmstr/cdx")
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "raw", encoding = "UTF-8")
  rc <- rawConnection(out)
  on.exit(close(rc), add=TRUE)

  out <- jsonlite::stream_in(rc, verbose = FALSE)
  out <- mcga(out)
  class(out) <- c("tbl_df", "tbl", "data.frame")
  out

}