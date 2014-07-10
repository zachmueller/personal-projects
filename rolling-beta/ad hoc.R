# load libraries
library(quantmod)

# set date
start.date <- as.Date("1960-01-01")

# create list to download
sym <- c("AMZN","AAPL","^GSPC")

# download data into time series
sym <- getSymbols(sym, src = "yahoo", from = start.date, auto.assign = TRUE)

# create backups of stock data objects
GSPC.bk <- GSPC
AMZN.bk <- AMZN
AAPL.bk <- AAPL

# loop through each returned symbol
min.start.date <- start.date
max.date <- Sys.Date()
for (i in sym) {
	# capture each stock's earliest date index
	#   and store the greatest of that and previous min.start.date
	min.start.date <- max(index(get(i))[1]
		,min.start.date)
	
	# capture latest end date that all stocks share
	max.date <- min(max(index(get(i)[,1]))
		,max.date)
}

# create list for output
symbols <- list()

######################################################
#	Example R script of following eval(parse())
#GSPC <- window(GSPC, start = min.start.date, end = max.date)
######################################################

# loop through symbols and push only truncated date range into list
for (i in sym) {
	# push in truncated time series
	eval(parse(text = paste('symbols[["', i
		,'"]] <- window(', i
		,', start = min.start.date, end = max.date)',sep='')))
	
	# calculate daily percent change in stock prices
	symbols[[i]]$percent.change <- ( symbols[[i]][,6] 
		/ lag(symbols[[i]][,6], 1) - 1 )
}


################################
# restore from backup (if needed after ad hoc tinkering)
GSPC <- GSPC.bk
AMZN <- AMZN.bk
AAPL <- AAPL.bk
################################

# loop for now...
offset.amount <- 252
max.index <- length(symbols[[1]][,7])
symbols[[1]]$beta <- as.numeric(rep(NA, max.index))

system.time(
for (i in offset.amount:max.index) {
	stock.data <- symbols[[1]][(i - offset.amount):i,7]
	market.data <- symbols[[3]][(i - offset.amount):i,7]
	symbols[[1]]$beta[i] <- (cov.pop(stock.data
		,market.data) / (sd.pop(market.data)^2))
}
)
# extremely slow: 15 - 20 seconds
plot(symbols[[1]]$beta)
# investigate using zoo's rollapply() function
# http://stackoverflow.com/questions/13195442/moving-variance-in-r


###############################################
# benchmark
stock.data <- symbols[[1]][2:253,7]
market.data <- symbols[[3]][2:253,7]
system.time(replicate(1000,
	symbols[[1]]$beta[253] <- (cov.pop(stock.data
		,market.data) / (sd.pop(market.data)^2))
))
system.time(replicate(1000,
	symbols[[1]]$beta[253] <- (cov(stock.data
		,market.data) / (sd(market.data)^2))
))

###############################################

# create population (as opposed to sample) functions
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