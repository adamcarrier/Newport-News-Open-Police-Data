## Dependencies
install.packages("leaflet")
install.packages("htmlwidgets")

plotReports <- function(workingDirectory,dataSetDirectory="./data/",exportFileName="index.html") {
    require(leaflet)
    require(htmlwidgets)
    
    ## Initial set up
    setwd(workingDirectory)
    
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    dailyFieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    dailyTheftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Read reports
    dailyAccidentReport <- read.csv(paste(dataSetDirectory,dailyAccidentReportFileName,sep="/"),stringsAsFactors = FALSE)
    dailyArrestReport <- read.csv(paste(dataSetDirectory,dailyArrestReportFileName,sep="/"),stringsAsFactors = FALSE)
    dailyJuvenileReport <- read.csv(paste(dataSetDirectory,dailyJuvenileReportFileName,sep="/"),stringsAsFactors = FALSE)
    dailyOffensesReport <- read.csv(paste(dataSetDirectory,dailyOffensesReportFileName,sep="/"),stringsAsFactors = FALSE)
    dailyFieldContactsReport <- read.csv(paste(dataSetDirectory,dailyFieldContactsReportFileName,sep="/"),stringsAsFactors = FALSE)
    dailyTheftFromVehicleReport <- read.csv(paste(dataSetDirectory,dailyTheftFromVehicleReportFileName,sep="/"),stringsAsFactors = FALSE)
    
    ## Set up Leaflet plot
    mapPlot <- leaflet()
    
    ## Add tile groups
    mapPlot <- addTiles(mapPlot)

    ## Geocode addresses to latitude and longitude
    ## From: http://www.storybench.org/geocode-csv-addresses-r/
    
    ## add daily accident reports
    for(i in 1:nrow(dailyAccidentReport)) {
        # create the popup
        popupText <- paste( 
          paste(c(dailyAccidentReport$Date[i],dailyAccidentReport$Time[i]), collapse=" "),
          "Vehicle Accident",
          sep="<br/>"
        )
        mapPlot <- addCircles(mapPlot,lng=dailyAccidentReport$Longitude[i],lat=dailyAccidentReport$Latitude[i],popup=popupText,group="Vehicle Accidents") # add circle to plot
    }
    
    ## Add daily arrest reports
    for(i in 1:nrow(dailyArrestReport)) {
        # create the popup
        popupText <- paste( 
            paste(c(dailyArrestReport$Date[i],dailyArrestReport$Time[i]), collapse=" "),
            dailyArrestReport$Charge[i],
            sep="<br/>"
        )
        mapPlot <- addCircles(mapPlot,lng=dailyArrestReport$Longitude[i],lat=dailyArrestReport$Latitude[i],popup=popupText,group="Arrests") # add circle to plot
    }
    
    ## Add daily juvenile reports
    for(i in 1:nrow(dailyJuvenileReport)) {
        # create the popup
        popupText <- paste( 
          paste(c(dailyJuvenileReport$Date[i],dailyJuvenileReport$Time[i]), collapse=" "),
          dailyJuvenileReport$Offense[i],
          sep="<br/>"
        )
        mapPlot <- addCircles(mapPlot,lng=dailyJuvenileReport$Longitude[i],lat=dailyJuvenileReport$Latitude[i],popup=popupText,group="Juvenile Offenses") # add circle to plot
    }
    
    ## Add daily offenses reports
    for(i in 1:nrow(dailyOffensesReport)) {
        # create the popup
        popupText <- paste( 
            paste(c(dailyOffensesReport$Date[i],dailyOffensesReport$Time[i]), collapse=" "),
            dailyOffensesReport$Offense[i],
            sep="<br/>"
        )
        mapPlot <- addCircles(mapPlot,lng=dailyOffensesReport$Longitude[i],lat=dailyOffensesReport$Latitude[i],popup=popupText,group="Investigations") # add circle to plot
    }
    
    ## Add daily field contacts reports
    for(i in 1:nrow(dailyFieldContactsReport)) {
        # create the popup
        popupText <- paste( 
          paste(c(dailyFieldContactsReport$Date[i],dailyFieldContactsReport$Time[i]), collapse=" "),
          dailyFieldContactsReport$Reason[i],
          sep="<br/>"
        )
        mapPlot <- addCircles(mapPlot,lng=dailyFieldContactsReport$Longitude[i],lat=dailyFieldContactsReport$Latitude[i],popup=popupText,group="Suspicious Activities") # add circle to plot
    }
    
    ## Add daily theft from vehicle reports
    for(i in 1:nrow(dailyTheftFromVehicleReport)) {
        # create the popup
        popupText <- paste( 
          paste(c(dailyTheftFromVehicleReport$Date[i],dailyTheftFromVehicleReport$Time[i]), collapse=" "),
          "Theft from Vehicle",
          sep="<br/>"
        )
        mapPlot <- addCircles(mapPlot,lng=dailyTheftFromVehicleReport$Longitude[i],lat=dailyTheftFromVehicleReport$Latitude[i],popup=popupText,group="Theft from Vehicle") # add circle to plot
    }
    
    ## Add layers control
    mapPlot <- addLayersControl(
        map=mapPlot,
        overlayGroups=c("Vehicle Accidents","Arrests","Juvenile Offenses","Investigations","Suspicious Activities","Theft from Vehicle"),
        options=layersControlOptions(collapsed=FALSE)
    )
    
    ## Draw and export the map plot
    #mapPlot # draw the Leaflet plot!
    saveWidget(widget=mapPlot,file=exportFileName,selfcontained=TRUE,libdir=NULL,title="Newport News Open Police Data")
}