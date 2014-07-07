# load libraries
library(quantmod)

# set date range
start.date <- as.Date("1960-01-01")

# download data into time series
getSymbols(c("AMZN","AAPL"), src = "yahoo", from = start.date, auto.assign = FALSE)
