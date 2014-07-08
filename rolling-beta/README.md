# Rolling Beta Chart

## Overview
- Based on original idea from Ron Sweet, professor at UTSA
- Quickly visualize the change in a stock's Beta over time to better estimate what its Beta will be going forward
- Beta calculated on a rolling 3 year basis (to be adjustable in the future)

## Progression
1. Originally performed manually in Excel (as taught by Ron Sweet)
2. Automated in Excel via VBA
3. Further automated in the browser via PHP and javascript (currently living on [my cloud server] (http://www.zachmueller.com/apps/charts))
4. Rebuild and expand browser app using R and Shiny (work in progress)

## Required R Libraries
Library | Version | Purpose
--------|---------|----------
`quantmod` | 0.4-0 | Used for easy downloading of stock market data
`shiny` | 0.10.0 | Builds the interactive web interface
