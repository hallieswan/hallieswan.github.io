# Scrape Northwest Conference Standings ----------------------------------------
# Feb 1, 2023
#
# This script will scrape and write out Northwest Conference standings for a 
# particular sport.
#
# 0a. load packages ------------------------------------------------------------
library(rvest)
library(tidyverse)
library(here)

# 0b. set params ---------------------------------------------------------------
params <- list(
  standings_base_url = "https://nwcsports.com/standings.aspx",
  sport = "wsoc",
  sleep_time = 5,
  save_dir = "_data"
)

# 0c. write functions ----------------------------------------------------------
create_url_sport_current_standings <- function(sport, standings_base_url) {
  sprintf("%s?path=%s", standings_base_url, sport)
}
create_url_standings <- function(standings_page_id, standings_base_url) {
  sprintf("%s?standings=%s", standings_base_url, standings_page_id)
}
get_standings <- function(standings_page_id, standings_base_url, sleep_time) {
  message("Processing ", standings_page_id)
  
  # get the html page
  url_standings <- create_url_standings(standings_page_id, standings_base_url)
  page_html <- read_html(url_standings)
  
  # extract the year
  year <- page_html %>%
    html_nodes("h2") %>%
    .[grep(., pattern = "Standings")] %>%
    html_text() %>%
    substring(1, 4)
  
  # extract the standings
  standings <- page_html %>%
    html_node("table") %>%
    html_table() %>%
    # select unique columns
    select_unique_columns() %>%
    # add year and position
    mutate(
      standings_year = year
    )
  
  # sleep, so we don't call this too frequently
  Sys.sleep(sleep_time)
  
  return(standings)
}
select_unique_columns <- function(df) {
  unique_cols <- unique(colnames(df))
  first_occurrence <- unlist(lapply(unique_cols, match, colnames(df)))
  df[, first_occurrence]
}

# 1. get standing ids from current standings page ------------------------------
url_sport_current_standings <- create_url_sport_current_standings(params$sport, params$standings_base_url)
base_html <- read_html(url_sport_current_standings)
standings_page_ids <- base_html %>%
  html_node("select") %>%
  html_nodes("option") %>%
  html_attr("value")

# 2. read standings for each page ----------------------------------------------
standings <- lapply(standings_page_ids, get_standings, params$standings_base_url, params$sleep_time) 

# 3. clean standings -----------------------------------------------------------
# clean up repeated columns with different capitalization (e.g. School / SCHOOL)
standings_clean <- lapply(standings, function(x) {
  colnames(x) <- tolower(colnames(x))
  x %>%
    select_unique_columns()
}) %>%
  bind_rows()

# 4. write out data ------------------------------------------------------------
filename <- sprintf("nwc_rankings_%s_%s.csv", params$sport, format(Sys.Date(), "%Y%m%d"))
write_csv(standings_clean, here(params$save_dir, filename))
