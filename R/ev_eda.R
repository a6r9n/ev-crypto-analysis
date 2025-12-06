# R/ev_eda.R
# ----------

library(readr)
library(dplyr)
library(ggplot2)

load_ev_data <- function(path = "../data/processed/ev-data-anon.csv") {
  read_csv(path, show_col_types = FALSE)
}

# Return key records: max range, efficiency, speed, etc.
ev_summary_stats <- function(ev) {
  list(
    max_range      = ev[which.max(ev$Range), ],
    most_efficient = ev[which.min(ev$WhperKm), ],
    fastest        = ev[which.max(ev$TopSpeed), ],
    fastest_accel  = ev[which.min(ev$To100sec), ],
    cheapest       = ev[which.min(ev$Price), ]
  )
}
