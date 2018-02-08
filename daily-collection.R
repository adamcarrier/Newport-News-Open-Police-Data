runDailyCollection <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Dependencies
    source("./daily-accident-report.R")
    source("./daily-arrest-report.R")
    source("./daily-juvenile-report.R")
    source("./daily-offenses-report.R")
    
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    fieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    theftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Collection functions
    dailyAccidentReport <- getDailyAccidentReport(workingDirectory) # Daily Accident Reports
    dailyArrestReport <- getDailyArrestReport(workingDirectory) # Daily Arrest Report
    dailyJuvenileReport <- getDailyJuvenileReport(workingDirectory) # Daily Juvenile Report
    dailyOffenses <- getDailyOffensesReport(workingDirectory) # Daily Offenses
    #fieldContacts # Field Contacts
    #theftFromVehicle # Theft from Vehicle
    
    ## Write to data sets
    write.csv(dailyAccidentReport,file=paste(dataSetDirectory,dailyAccidentReportFileName,sep=""),row.names=FALSE) # Accident Reports
    write.csv(dailyArrestReport,file=paste(dataSetDirectory,dailyArrestReportFileName,sep=""),row.names=FALSE) # Daily Arrest Report
    write.csv(dailyJuvenileReport,file=paste(dataSetDirectory,dailyJuvenileReportFileName,sep=""),row.names=FALSE) # Daily Juvenile Report
    write.csv(dailyOffenses,file=paste(dataSetDirectory,dailyOffensesReportFileName,sep=""),row.names=FALSE) # Daily Offenses
    #write.csv(fieldContacts,file=paste(dataSetDirectory,fieldContactsReportFileName,sep=""),row.names=FALSE) # Field Contacts
    #write.csv(theftFromVehicle,file=paste(dataSetDirectory,theftFromVehicleReportFileName,sep=""),row.names=FALSE) # Theft from Vehicle
}