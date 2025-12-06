# R/lp_models.R
# --------------

library(lpSolve)

# Two-variable LP (ICE vs EV)
# x = ICE cars, y = EVs

solve_ice_ev <- function() {
  obj <- c(2000, 1000)  # profit coefficients for x, y
  
  con <- matrix(c(
    1, 2,   # x + 2y <= 1500 (semiconductor constraint)
    3, 1,   # 3x + y <= 1200 (production rate constraint)
    1, 0    # x >= 100 (contract)
  ), ncol = 2, byrow = TRUE)
  
  dir <- c("<=", "<=", ">=")
  rhs <- c(1500, 1200, 100)
  
  sol <- lp("max", obj, con, dir, rhs)
  
  list(
    status   = sol$status,
    optimum  = sol$objval,
    ice      = sol$solution[1],
    ev       = sol$solution[2]
  )
}

# Three-variable LP (ICE, EV, Hybrid)
# x = ICE, y = EV, h = Hybrid

solve_ice_ev_hybrid <- function(semiconductor_limit = 1500) {
  obj <- c(2000, 1000, 2500) # profit coefficients for x, y, h
  
  con <- matrix(c(
    1, 2, 2,   # x + 2y + 2h <= semiconductor_limit
    3, 1, 3,   # 3x + y + 3h <= 1200
    1, 0, 0    # x >= 100 (contract)
  ), ncol = 3, byrow = TRUE)
  
  dir <- c("<=", "<=", ">=")
  rhs <- c(semiconductor_limit, 1200, 100)
  
  sol <- lp("max", obj, con, dir, rhs)
  
  list(
    status   = sol$status,
    optimum  = sol$objval,
    ice      = sol$solution[1],
    ev       = sol$solution[2],
    hybrid   = sol$solution[3]
  )
}

