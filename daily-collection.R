## Dependencies
source("./daily-arrest-report.R")

runDailyCollection <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    fieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    theftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Collection functions
    
    #dailyAccidentReports # Accident Reports
    dailyArrestReport <- getDailyArrestReport(workingDirectory) # Daily Arrest Report (24 hours)
    #dailyJuvenileReport # Daily Juvenile Report
    #dailyOffenses # Daily Offenses
    #fieldContacts # Field Contacts
    #theftFromVehicle # Theft from Vehicle
    
    ## Write to data sets
    #write.csv(dailyAccidentReports,file=paste(dataSetDirectory,dailyAccidentReportFileName,sep="/"),append=TRUE)# Accident Reports
    write.csv(dailyArrestReport,file=paste(dataSetDirectory,dailyArrestReportFileName,sep="/"),append=TRUE,sep=",") # Collect Daily Arrest Report (24 hours)
    #write.csv(dailyJuvenileReport,file=paste(dataSetDirectory,dailyJuvenileReportFileName,sep="/"),append=TRUE) # Daily Juvenile Report
    #write.csv(dailyOffenses,file=paste(dataSetDirectory,dailyOffensesReportFileName,sep="/"),append=TRUE) # Daily Offenses
    #write.csv(fieldContacts,file=paste(dataSetDirectory,fieldContactsReportFileName,sep="/"),append=TRUE) # Field Contacts
    #write.csv(theftFromVehicle,file=paste(dataSetDirectory,theftFromVehicleReportFileName,sep="/"),append=TRUE) # Theft from Vehicle
}