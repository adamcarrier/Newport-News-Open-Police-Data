## Set repo working directory
repo <- "/Users/adam/Documents/Web Projects/Personal/Newport-News-Open-Police-Data"

## Test individual report collection; each returns a data frame
dailyAccidents <- getDailyAccidentReport(repo)
dailyArrests <- getDailyArrestReport(repo)
dailyJuvenile <- getDailyJuvenileReport(repo)
dailyOffenses <- getDailyOffensesReport(repo)
dailyFieldContacts <- getDailyFieldContactsReport(repo)
dailyTheftFromVehicle <- getDailyTheftFromVehicleReport(repo)

## Test daily report collection
runDailyCollection(repo)

## Test public data set sync
runCloudStorageSync(repo)

## Test Leaflet plot generation
plotReports(repo)