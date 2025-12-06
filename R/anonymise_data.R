# R/anonymise_data.R

library(dplyr)
library(readr)
library(stringr)

# 1) Anonymise EV data -------------------------------------------

anonymise_ev_data <- function(input_path, output_path) {
  ev <- read_csv(input_path, show_col_types = FALSE)
  
  # If your CSV has a column called 'Model', we drop it and create an ID.
  # If it doesn't, we'll just create an ID and keep all columns.
  if ("Model" %in% names(ev)) {
    ev_anon <- ev |>
      mutate(CarID = sprintf("EV_%03d", dplyr::row_number())) |>
      select(CarID, dplyr::everything(), -Model)
  } else {
    ev_anon <- ev |>
      mutate(CarID = sprintf("EV_%03d", dplyr::row_number())) |>
      relocate(CarID)
  }
  
  write_csv(ev_anon, output_path)
  ev_anon
}

# 2) Anonymise crypto candles ------------------------------------

anonymise_crypto <- function(input_path, output_path) {
  candles <- read_csv(input_path, show_col_types = FALSE)
  
  all_pairs <- unique(candles$SYMBOL)
  
  mapping <- data.frame(
    SYMBOL = all_pairs,
    PairID = sprintf("PAIR_%03d", seq_along(all_pairs)),
    stringsAsFactors = FALSE
  )
  
  candles_anon <- candles |>
    left_join(mapping, by = "SYMBOL") |>
    select(-SYMBOL) |>
    rename(SYMBOL = PairID)
  
  write_csv(candles_anon, output_path)
  candles_anon
}

# 3) Run once to generate processed files ------------------------

run_anonymisation <- function() {
  dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
  
  anonymise_ev_data(
    "data/raw/ev-data.csv",
    "data/processed/ev-data-anon.csv"
  )
  
  anonymise_crypto(
    "data/raw/crypto-candles.csv",
    "data/processed/crypto-candles-anon.csv"
  )
}

# Uncomment this line and run once:
# run_anonymisation()
