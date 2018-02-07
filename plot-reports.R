## Dependencies
install.packages("leaflet")
install.packages("htmlwidgets")

plotReports <- function(workingDirectory,dataSetDirectory="./data/",exportFileName="map.html") {
    require(leaflet)
    require(htmlwidgets)
    
    ## Initial set up
    setwd(workingDirectory)
    
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    fieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    theftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Read reports
    dailyAccidentReport <- read.csv(paste(dataSetDirectory,dailyAccidentReportFileName,sep="/"))
    dailyArrestReport <- read.csv(paste(dataSetDirectory,dailyArrestReportFileName,sep="/"))
    
    ## Set up Leaflet plot
    map <- leaflet()
    map <- addTiles(map)
    
    ## Geocode addresses to latitude and longitude
    ## From: http://www.storybench.org/geocode-csv-addresses-r/
    
    ## add daily accident reports
    for(i in 1:nrow(dailyAccidentReport)) {
        # create the popup
        popupText <- paste(
            sep="<br/>",
            dailyAccidentReport$DateTime[i],
            "Vehicle Accident"
        )
        map <- addMarkers(map,lng=dailyAccidentReport$Longitude[i],lat=dailyAccidentReport$Latitude[i],popup=popupText) # add marker to plot
    }
    
    ## Add daily arrest reports
    for(i in 1:nrow(dailyArrestReport)) {
        # create the popup
        popupText <- paste(
            sep="<br/>",
            dailyArrestReport$DateTime[i],
            dailyArrestReport$Charge[i]
        )
        map <- addMarkers(map,lng=dailyArrestReport$Longitude[i],lat=dailyArrestReport$Latitude[i],popup=popupText) # add marker to plot
    }
    
    ## Draw and export the map plot
    map # draw the Leaflet plot!
    saveWidget(widget=map,file=exportFileName)
}