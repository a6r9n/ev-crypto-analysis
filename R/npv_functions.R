# R/npv_functions.R
# ------------------

# Build base cashflow table for EV investment
build_cashflows <- function() {
  data.frame(
    year    = 2023:2028,
    outflow = c(20, 15, 15, 10, 10, 5),
    inflow  = c(0, 0, 10, 20, 25, 30)
  )
}

# Core NPV analysis function
analyse_cashflow <- function(data, rate) {
  df <- data
  df$return   <- df$inflow - df$outflow
  df$n        <- df$year - min(df$year)
  df$pvf      <- (1 + rate)^(-df$n)
  df$pvreturn <- df$return * df$pvf
  
  total_npv <- sum(df$pvreturn)
  
  list(
    cashflows = df,
    total_npv = total_npv
  )
}

# Evaluate NPV for a vector of discount rates
npv_vs_rate <- function(data, rates) {
  npvs <- sapply(rates, function(r) analyse_cashflow(data, r)$total_npv)
  data.frame(rate = rates, npv = npvs)
}

