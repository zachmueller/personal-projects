# load libraries
library(quantmod)

# set date
start.date <- as.Date("1960-01-01")

# create list to download
sym <- c("AMZN","AAPL","^GSPC")

# download data into time series
sym <- getSymbols(sym, src = "yahoo", from = start.date, auto.assign = TRUE)


# loop through each returned symbol
min.start.date <- start.date
for (i in sym) {
	# capture each stock's earliest date index
	#   and store the greatest of that and previous min.start.date
	min.start.date <- max(index(get(i))[1]
		,min.start.date)
}

GSPC <- GSPC.bk
AMZN <- AMZN.bk
AAPL <- AAPL.bk

# trim each time series to the latest start date
max.date <- max(index(get(sym[1])))
GSPC <- window(GSPC, start = min.start.date
	,end = max.date)


# calculate percent change of daily adjusted prices
d <- AAPL[,6]
percent.change <- d / lag(d, 1) - 1



# create population functions
# standard deviation (population)
sd.pop <- function(x) {
	sqrt(sum((x-mean(x))^2) / length(x))
}

# covariance (population)
cov.pop <- function(x, y) {
	sum((x-mean(x))*(y-mean(y)))/ length(x)
}

# create function to calculate the beta of a stock
beta <- function(stock, market) {}

# working with zoo objects: http://cran.r-project.org/web/packages/zoo/vignettes/zoo-quickref.pdf