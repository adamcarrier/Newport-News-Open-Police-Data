## Dependencies
install.packages("lubridate")
install.packages("plyr")
install.packages("googleCloudStorageR")

runCloudStorageSync <- function(workingDirectory,dataSetDirectory="./data/") {
    require(lubridate)
    require(plyr)
    
    ## Initial set up
    setwd(workingDirectory)
    source("cloud-storage-env-vars.R") # my Google Cloud Storage API variables
    
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    dailyfieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    dailyTheftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Set Google Cloud Storage environment variables
    ## From: https://cran.r-project.org/web/packages/googleCloudStorageR/vignettes/googleCloudStorageR.html
    # for OAuth 2.0 - "R clients" app ID
    
    Sys.setenv(
        #"GCS_CLIENT_ID" = GCS_CLIENT_ID,
        #"GCS_CLIENT_SECRET" = GCS_CLIENT_SECRET,
        #"GCS_DEFAULT_BUCKET" = GCS_DEFAULT_BUCKET,
        "GCS_AUTH_FILE" = paste(workingDirectory,".httr-oauth",sep="/") # auto authentication
        )
    
    ## Set control scope
    options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/devstorage.read_write")
    
    ## Load the library after the env vars are set
    require("googleCloudStorageR")
    gcs_auth() # init connection
    
    ## Get object info in the default bucket
    gcs_global_bucket(GCS_DEFAULT_BUCKET)
    cloudStorageFiles <- gcs_list_objects() # get a data frame listing all the files with their storage meta data
    
    ## Download each previous data set as CSV
    for(i in 1:nrow(cloudStorageFiles)) {
        gcs_get_object(cloudStorageFiles$name[[i]],saveToDisk=paste(dataSetDirectory,"previous-",cloudStorageFiles$name[[i]],sep=""),overwrite=TRUE)
    }
    
    ## Create data frames from new data sets
    dailyAccidentReport <- read.csv(paste0(dataSetDirectory,dailyAccidentReportFileName),stringsAsFactors=FALSE)
    dailyArrestReport <- read.csv(paste0(dataSetDirectory,dailyArrestReportFileName),stringsAsFactors=FALSE)
    dailyJuvenileReport <- read.csv(paste0(dataSetDirectory,dailyJuvenileReportFileName),stringsAsFactors=FALSE)
    dailyOffenses <- read.csv(paste0(dataSetDirectory,dailyOffensesReportFileName),stringsAsFactors=FALSE)
    dailyfieldContacts <- read.csv(paste0(dataSetDirectory,dailyfieldContactsReportFileName),stringsAsFactors=FALSE)
    dailyTheftFromVehicle <- read.csv(paste0(dataSetDirectory,dailyTheftFromVehicleReportFileName),stringsAsFactors=FALSE)

    ## Create data frames from previous (old) data sets
    oldDailyAccidentReport <- read.csv(paste0(dataSetDirectory,"previous-",dailyAccidentReportFileName),stringsAsFactors=FALSE)
    oldDailyArrestReport <- read.csv(paste0(dataSetDirectory,"previous-",dailyArrestReportFileName),stringsAsFactors=FALSE)
    oldDailyJuvenileReport <- read.csv(paste0(dataSetDirectory,"previous-",dailyJuvenileReportFileName),stringsAsFactors=FALSE)
    oldDailyOffenses <- read.csv(paste0(dataSetDirectory,"previous-",dailyOffensesReportFileName),stringsAsFactors=FALSE)
    oldDailyfieldContacts <- read.csv(paste0(dataSetDirectory,"previous-",dailyfieldContactsReportFileName),stringsAsFactors=FALSE)
    oldDailyTheftFromVehicle <- read.csv(paste0(dataSetDirectory,"previous-",dailyTheftFromVehicleReportFileName),stringsAsFactors=FALSE)
    
    ## Convert Date columns to Date type for later sorting
    dailyAccidentReport$Date <- mdy(dailyAccidentReport$Date)
    dailyArrestReport$Date <- mdy(dailyArrestReport$Date)
    dailyJuvenileReport$Date <- mdy(dailyJuvenileReport$Date)
    dailyOffenses$Date <- mdy(dailyOffenses$Date)
    dailyfieldContacts$Date <- mdy(dailyfieldContacts$Date)
    dailyTheftFromVehicle$Date <- mdy(dailyTheftFromVehicle$Date)
    
    oldDailyAccidentReport$Date <- ymd(oldDailyAccidentReport$Date)
    oldDailyArrestReport$Date <-  ymd(oldDailyArrestReport$Date)
    oldDailyJuvenileReport$Date <- ymd(oldDailyJuvenileReport$Date)
    oldDailyOffenses$Date <- ymd(oldDailyOffenses$Date) 
    oldDailyfieldContacts$Date <- ymd(oldDailyfieldContacts$Date) 
    oldDailyTheftFromVehicle$Date <- ymd(oldDailyTheftFromVehicle$Date) 
    
    ## Merge previous and new data sets
    ## Consider doing one data set merge at a time and then using rm() on each data frame to save memory space
    dailyAccidentReport <- rbind(oldDailyAccidentReport,dailyAccidentReport,stringsAsFactors=FALSE)
    dailyArrestReport <- rbind(oldDailyArrestReport,dailyArrestReport,stringsAsFactors=FALSE)
    dailyJuvenileReport <- rbind(oldDailyJuvenileReport,dailyJuvenileReport,stringsAsFactors=FALSE)
    dailyOffenses <- rbind(oldDailyOffenses,dailyOffenses,stringsAsFactors=FALSE)
    dailyfieldContacts <- rbind(oldDailyfieldContacts,dailyfieldContacts,stringsAsFactors=FALSE)
    dailyTheftFromVehicle <- rbind(oldDailyTheftFromVehicle,dailyTheftFromVehicle,stringsAsFactors=FALSE)
    
    ## Sort by date: arrange by Date column first, then Time column
    dailyAccidentReport <- arrange(dailyAccidentReport,Date,hm(format(strptime(dailyAccidentReport$Time,"%I:%M %p"),format="%H:%M")))
    dailyArrestReport <- arrange(dailyArrestReport,Date,hm(format(strptime(dailyArrestReport$Time,"%I:%M %p"),format="%H:%M")))
    dailyJuvenileReport <- arrange(dailyJuvenileReport,Date,hm(format(strptime(dailyJuvenileReport$Time,"%I:%M %p"),format="%H:%M")))
    dailyOffenses <- arrange(dailyOffenses,Date,hm(format(strptime(dailyOffenses$Time,"%I:%M %p"),format="%H:%M")))
    dailyfieldContacts <- arrange(dailyfieldContacts,Date,hm(format(strptime(dailyfieldContacts$Time,"%I:%M %p"),format="%H:%M")))
    dailyTheftFromVehicle <- arrange(dailyTheftFromVehicle,Date,hm(format(strptime(dailyTheftFromVehicle$Time,"%I:%M %p"),format="%H:%M")))
    
    ## Convert Date column back to characters for deduping and writing
    dailyAccidentReport$Date <- as.character(dailyAccidentReport$Date)
    dailyArrestReport$Date <- as.character(dailyArrestReport$Date)
    dailyJuvenileReport$Date <- as.character(dailyJuvenileReport$Date)
    dailyOffenses$Date <- as.character(dailyOffenses$Date)
    dailyfieldContacts$Date <- as.character(dailyfieldContacts$Date)
    dailyTheftFromVehicle$Date <- as.character(dailyTheftFromVehicle$Date)
    
    ## Remove duplicate rows, based on unique values in the first column, Report/Arrest/Field ID
    dailyAccidentReport <- dailyAccidentReport[!duplicated(dailyAccidentReport[,1]),]
    dailyArrestReport <- dailyArrestReport[!duplicated(dailyArrestReport[,1]),]
    dailyJuvenileReport <- dailyJuvenileReport[!duplicated(dailyJuvenileReport[,1]),]
    dailyOffenses <- dailyOffenses[!duplicated(dailyOffenses[,1]),]
    dailyfieldContacts <- dailyfieldContacts[!duplicated(dailyfieldContacts[,1]),]
    dailyTheftFromVehicle <- dailyTheftFromVehicle[!duplicated(dailyTheftFromVehicle[,1]),]
    
    ## Write merged data sets
    write.csv(dailyAccidentReport,file=paste0(dataSetDirectory,dailyAccidentReportFileName),row.names=FALSE)
    write.csv(dailyArrestReport,file=paste0(dataSetDirectory,dailyArrestReportFileName),row.names=FALSE)
    write.csv(dailyJuvenileReport,file=paste0(dataSetDirectory,dailyJuvenileReportFileName),row.names=FALSE)
    write.csv(dailyOffenses,file=paste0(dataSetDirectory,dailyOffensesReportFileName),row.names=FALSE)
    write.csv(dailyfieldContacts,file=paste0(dataSetDirectory,dailyfieldContactsReportFileName),row.names=FALSE)
    write.csv(dailyTheftFromVehicle,file=paste0(dataSetDirectory,dailyTheftFromVehicleReportFileName),row.names=FALSE)
    
    ## Upload each data set as CSV --only files listed in the cloudStorageFiles data frame will get uploaded
    for(i in 1:nrow(cloudStorageFiles)) {
        gcs_upload(paste(dataSetDirectory,cloudStorageFiles$name[[i]],sep=""),name=cloudStorageFiles$name[[i]])
    }
}