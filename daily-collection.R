runDailyCollection <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Dependencies
    source("./daily-accident-report.R")
    source("./daily-arrest-report.R")
    source("./daily-juvenile-report.R")
    source("./daily-offenses-report.R")
    source("./daily-field-contacts-report.R")
    source("./daily-theft-from-vehicle-report.R")
    
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    dailyfieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    dailyTheftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Collection functions
    dailyAccidentReport <- getDailyAccidentReport(workingDirectory) # Daily Accident Report
    dailyArrestReport <- getDailyArrestReport(workingDirectory) # Daily Arrest Report
    dailyJuvenileReport <- getDailyJuvenileReport(workingDirectory) # Daily Juvenile Report
    dailyOffenses <- getDailyOffensesReport(workingDirectory) # Daily Offenses Report
    dailyfieldContacts <- getDailyFieldContactsReport(workingDirectory) # Daily Field Contacts Report
    dailyTheftFromVehicle <- getDailyTheftFromVehicleReport(workingDirectory) # Daily Theft from Vehicle Report
    
    ## Write to data sets
    write.csv(dailyAccidentReport,file=paste(dataSetDirectory,dailyAccidentReportFileName,sep=""),row.names=FALSE) # Daily Accident Report
    write.csv(dailyArrestReport,file=paste(dataSetDirectory,dailyArrestReportFileName,sep=""),row.names=FALSE) # Daily Arrest Report
    write.csv(dailyJuvenileReport,file=paste(dataSetDirectory,dailyJuvenileReportFileName,sep=""),row.names=FALSE) # Daily Juvenile Report
    write.csv(dailyOffenses,file=paste(dataSetDirectory,dailyOffensesReportFileName,sep=""),row.names=FALSE) # Daily Offenses Report
    write.csv(dailyfieldContacts,file=paste(dataSetDirectory,dailyfieldContactsReportFileName,sep=""),row.names=FALSE) # Daily Field Contacts Report
    write.csv(dailyTheftFromVehicle,file=paste(dataSetDirectory,dailyTheftFromVehicleReportFileName,sep=""),row.names=FALSE) # Daily Theft from Vehicle Report
}