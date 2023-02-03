# Scrape PLU Head Coach Over Time ----------------------------------------------
# Feb 1, 2023
#
# This script will scrape and write out head coaches for Pacific Lutheran 
# women's soccer team.
#
# 0a. load packages ------------------------------------------------------------
library(rvest)
library(tidyverse)
library(here)

# 0b. set params ---------------------------------------------------------------
params <- list(
  url = "https://golutes.com/sports/2018/5/30/womens-soccer-year-by-year-history.aspx",
  sleep_time = 5,
  save_dir = "_data"
)

# 1. get page ------------------------------------------------------------------
base_html <- read_html(params$url)
coaches <- base_html %>%
  html_table() %>%
  .[[1]]

# 2. clean up ------------------------------------------------------------------
colnames(coaches) <- tolower(coaches[1, ])
coaches_clean <- coaches[-1, ] %>%
  filter(year != "")

# 3. write out -----------------------------------------------------------------
filename <- sprintf("plu_wsoc_head_coaches_%s.csv", format(Sys.Date(), "%Y%m%d"))
write_csv(coaches_clean, here(params$save_dir, filename))
