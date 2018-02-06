## Dependencies
source("./daily-arrest-report.R")

runDailyCollection <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Data set file names
    dailyAccidentReportFileName <- "daily-accident-reports.csv"
    dailyArrestReportFileName <- "daily-arrest-report.csv"
    dailyJuvenileReportFileName <- "daily-juvenile-report.csv"
    dailyOffensesReportFileName <- "daily-offenses-report.csv"
    fieldContactsReportFileName <- "field-contacts-report.csv"
    theftFromVehicleReportFileName <- "theft-from-vehicle-report.csv"
    
    ## Collection functions
    
    #dailyAccidentReports # Accident Reports
    dailyArrestReport <- getDailyArrestReport(workingDirectory) # Daily Arrest Report (24 hours)
    #dailyJuvenileReport # Daily Juvenile Report
    #dailyOffenses # Daily Offenses
    #fieldContacts # Field Contacts
    #theftFromVehicle # Theft from Vehicle
    
    ## Write to data sets
    #write.csv(dailyAccidentReports,file=paste(dataSetDirectory,dailyAccidentReportFileName,sep="/"),append=TRUE,sep=",")# Accident Reports
    write.csv(dailyArrestReport,file=paste(dataSetDirectory,dailyArrestReportFileName,sep="/"),append=TRUE,sep=",") # Collect Daily Arrest Report (24 hours)
    #write.csv(dailyJuvenileReport,file=paste(dataSetDirectory,dailyJuvenileReportFileName,sep="/"),append=TRUE,sep=",") # Daily Juvenile Report
    #write.csv(dailyOffenses,file=paste(dataSetDirectory,dailyOffensesReportFileName,sep="/"),append=TRUE,sep=",") # Daily Offenses
    #write.csv(fieldContacts,file=paste(dataSetDirectory,fieldContactsReportFileName,sep="/"),append=TRUE,sep=",") # Field Contacts
    #write.csv(theftFromVehicle,file=paste(dataSetDirectory,theftFromVehicleReportFileName,sep="/"),append=TRUE,sep=",") # Theft from Vehicle
}