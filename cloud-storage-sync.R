## Dependencies
install.packages("googleCloudStorageR")

runCloudStorageSync <- function(workingDirectory,dataSetDirectory="./data/") {
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
    dailyAccidentReport <- read.csv(paste0(dataSetDirectory,dailyAccidentReportFileName),stringsAsFactors=FALSE) # Daily Accident Report
    dailyArrestReport <- read.csv(paste0(dataSetDirectory,dailyArrestReportFileName),stringsAsFactors=FALSE) # Daily Arrest Report
    dailyJuvenileReport <- read.csv(paste0(dataSetDirectory,dailyJuvenileReportFileName),stringsAsFactors=FALSE) # Daily Juvenile Report
    dailyOffenses <- read.csv(paste0(dataSetDirectory,dailyOffensesReportFileName),stringsAsFactors=FALSE) # Daily Offenses Report
    dailyfieldContacts <- read.csv(paste0(dataSetDirectory,dailyfieldContactsReportFileName),stringsAsFactors=FALSE) # Daily Field Contacts Report
    dailyTheftFromVehicle <- read.csv(paste0(dataSetDirectory,dailyTheftFromVehicleReportFileName),stringsAsFactors=FALSE) # Daily Theft from Vehicle Report

    ## Create data frames from previous (old) data sets
    oldDailyAccidentReport <- read.csv(paste0(dataSetDirectory,"previous-",dailyAccidentReportFileName),stringsAsFactors=FALSE) # Daily Accident Report
    oldDailyArrestReport <- read.csv(paste0(dataSetDirectory,"previous-",dailyArrestReportFileName),stringsAsFactors=FALSE) # Daily Arrest Report
    oldDailyJuvenileReport <- read.csv(paste0(dataSetDirectory,"previous-",dailyJuvenileReportFileName),stringsAsFactors=FALSE) # Daily Juvenile Report
    oldDailyOffenses <- read.csv(paste0(dataSetDirectory,"previous-",dailyOffensesReportFileName),stringsAsFactors=FALSE) # Daily Offenses Report
    oldDailyfieldContacts <- read.csv(paste0(dataSetDirectory,"previous-",dailyfieldContactsReportFileName),stringsAsFactors=FALSE) # Daily Field Contacts Report
    oldDailyTheftFromVehicle <- read.csv(paste0(dataSetDirectory,"previous-",dailyTheftFromVehicleReportFileName),stringsAsFactors=FALSE) # Daily Theft from Vehicle Report 
    
    ## Merge previous and new data sets
    ## Consider doing one data set merge at a time and then using rm() on each data frame to save memory space
    #dailyAccidentReport <- rbind(oldDailyAccidentReport,dailyAccidentReport,stringsAsFactors=FALSE) # Daily Accident Report
    #dailyArrestReport <- rbind(oldDailyArrestReport,dailyArrestReport,stringsAsFactors=FALSE) # Daily Arrest Report
    #dailyJuvenileReport <- rbind(oldDailyJuvenileReport,dailyJuvenileReport,stringsAsFactors=FALSE) # Daily Juvenile Report
    #dailyOffenses <- rbind(oldDailyOffenses,dailyOffenses,stringsAsFactors=FALSE) # Daily Offenses Report
    #dailyfieldContacts <- rbind(oldDailyfieldContacts,dailyfieldContacts,stringsAsFactors=FALSE) # Daily Field Contacts Report
    #dailyTheftFromVehicle <- rbind(oldDailyTheftFromVehicle,dailyTheftFromVehicle,stringsAsFactors=FALSE) # Daily Theft from Vehicle Report
    
    ## Remove duplicate observation rows
    
    ## Sort by date
    
    ## Write merged data sets
    write.csv(dailyAccidentReport,file=paste0(dataSetDirectory,dailyAccidentReportFileName),row.names=FALSE) # Daily Accident Report
    write.csv(dailyArrestReport,file=paste0(dataSetDirectory,dailyArrestReportFileName),row.names=FALSE) # Daily Arrest Report
    write.csv(dailyJuvenileReport,file=paste0(dataSetDirectory,dailyJuvenileReportFileName),row.names=FALSE) # Daily Juvenile Report
    write.csv(dailyOffenses,file=paste0(dataSetDirectory,dailyOffensesReportFileName),row.names=FALSE) # Daily Offenses Report
    write.csv(dailyfieldContacts,file=paste0(dataSetDirectory,dailyfieldContactsReportFileName),row.names=FALSE) # Daily Field Contacts Report
    write.csv(dailyTheftFromVehicle,file=paste0(dataSetDirectory,dailyTheftFromVehicleReportFileName),row.names=FALSE) # Daily Theft from Vehicle Report
    
    ## Upload each data set as CSV --only files listed in the cloudStorageFiles data frame will get uploaded
    for(i in 1:nrow(cloudStorageFiles)) {
        gcs_upload(paste(dataSetDirectory,cloudStorageFiles$name[[i]],sep=""),name=cloudStorageFiles$name[[i]])
    }
}