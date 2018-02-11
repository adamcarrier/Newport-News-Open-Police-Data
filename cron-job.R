repo <- "/Users/adam/Documents/Web Projects/Personal/Newport-News-Open-Police-Data"
source("./daily-collection.R")
source("./cloud-storage-sync.R")
source("./plot-reports.R")
runDailyCollection(repo)
runCloudStorageSync(repo)
plotReports(repo)
##need to auto-commit index.html plot file