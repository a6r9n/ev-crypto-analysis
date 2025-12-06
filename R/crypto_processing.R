# R/crypto_processing.R
# ----------------------

library(readr)
library(xts)
library(zoo)

load_crypto <- function(path = "../data/processed/crypto-candles-anon.csv") {
  read_csv(path, show_col_types = FALSE)
}

build_prices_matrix <- function(candles) {
  all_pairs <- unique(candles$SYMBOL)
  prices <- NULL
  
  for (pair in all_pairs) {
    temp <- subset(candles, SYMBOL == pair)
    
    xts_series <- xts(
      temp$CLOSE,
      order.by = as.Date(temp$TIMESTAMP)
    )
    
    prices <- cbind(prices, xts_series)
  }
  
  colnames(prices) <- all_pairs
  prices
}

clean_and_log_returns <- function(prices) {
  prices <- na.locf(prices)                     # forward fill
  prices <- na.locf(prices, fromLast = TRUE)    # backward fill
  log_returns <- diff.xts(prices, lag = 1, log = TRUE, na.pad = FALSE)
  log_returns
}
