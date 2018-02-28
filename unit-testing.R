## Set repo working directory
repo <- "/Users/adam/Documents/Web Projects/Personal/Newport-News-Open-Police-Data"
setwd(repo)

## Dependencies
source("./daily-accident-report.R")
source("./daily-arrest-report.R")
source("./daily-juvenile-report.R")
source("./daily-offenses-report.R")
source("./daily-field-contacts-report.R")
source("./daily-theft-from-vehicle-report.R")
source("./daily-collection.R")
source("./cloud-storage-sync.R")
source("./plot-reports.R")


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