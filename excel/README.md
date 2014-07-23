# Excel Files
 - Various Excel things I've built over the years
 - Generally very macro-driven

---

## brick-chart.xlsm
 - Built to handle waterfall charts where step amounts make jumps from positive to negative and vice versa
 - VBA helps with hiding/unhiding/coloring parts of the chart as necessary
 - Change dollar amounts then click button to update chart

## options.xlsm
 - Create Option Payoff charts easily
 - Follow User Form to individually add options (or choose from built-in strategies) and submit to build output

## stock-charts.xlsm
 - Create 3-year Rolling Beta charts
 - Download stock and market adjusted price data from Yahoo! Finance, follow User Form to create chart(s).
 - May not be compatible with Excel 2007 and prior (due to use of STDEV.P function)
 - [Recreating in R](https://github.com/zachmueller/rolling-beta)

## travel-calculator.xlsm
 - Calculate how much each member of a group owes others within the group when shared expenses exist for the group
 - Most common use case is traveling in a group; allocate shared (and semi-shared) expenses among members of the group
 - Follow User Form: first create full list of people in group, then add expense amounts and whom each benefited
 - Occasionally have issues with file crashing Excel upon open (after enabling Macros)