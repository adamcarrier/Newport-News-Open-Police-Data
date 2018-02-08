## Set repo working directory
cwd <- "/Users/adam/Documents/Web Projects/Personal/Newport-News-Open-Police-Data"

## Test individual report collection
dailyAccidents <- getDailyAccidentReport(cwd)
dailyArrests <- getDailyArrestReport(cwd)
dailyJuvenile <- getDailyJuvenileReport(cwd)
dailyOffenses <- getDailyOffensesReport(cwd)

## Test daily report collection
runDailyCollection(cwd)

## Test Leaflet plot generation
plotReports(cwd)

## Test public data set sync --not ready yet
#runCloudStorageSync(cwd)