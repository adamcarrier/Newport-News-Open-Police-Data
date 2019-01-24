options(repos="https://cran.rstudio.com") # necessary for non-interactive R
repo <- "/Users/adam/Documents/Data Projects/Personal/Newport-News-Open-Police-Data"
source("./daily-collection.R")
source("./cloud-storage-sync.R")
source("./plot-reports.R")
runDailyCollection(repo)
runCloudStorageSync(repo)
plotReports(repo)
##need to auto-commit index.html plot file