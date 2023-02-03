#' Build Site
#' 
#' This script will build the RMarkdown site stored in the docs directory. 
#' Preferred over simply running `rmarkdown::render_site` to avoid regenerating 
#' Rmds that are time-consuming to render or depend on local data that may or 
#' may not be currently available.
#' 
#' Will use a list of Rmds to skip rather than a list of Rmds to build, so that 
#' any new Rmds will be automatically be included in build until specified 
#' otherwise.
#'
#' @export
build_site <- function() {
  # create list of Rmds to skip
  rmds_skip <- c(
    "post-nwc_wsoc_rankings.Rmd",
    "post-appalachian_trail_blog.Rmd"
  )
  
  # get Rmds to build
  rmds <- list.files(".", pattern = "Rmd")
  rmds_build <- rmds[!rmds %in% rmds_skip]
  
  # render site
  lapply(rmds_build, rmarkdown::render_site)
}
