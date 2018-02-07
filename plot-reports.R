plotReports <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Dependencies
    install.packages("ggmap")
    install.packages("leaflet")
    
    require(ggmap)
    require(leaflet)
    require(ggplot2)
    
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
    dailyArrestReport <- read.csv(paste(dataSetDirectory,dailyArrestReportFileName,sep="/"))
    
    ## Set up Leaflet plot
    map <- leaflet()
    map <- addTiles(map)
    
    ## Geocode addresses to latitude and longitude
    ## From: http://www.storybench.org/geocode-csv-addresses-r/
    for(i in 1:nrow(dailyArrestReport)) {
        # create the popup
        popupText <- paste(
            sep="<br/>",
            dailyArrestReport$DateTime[i],
            dailyArrestReport$Charge[i]
        )
        map <- addMarkers(map,lng=dailyArrestReport$lon[i],lat=dailyArrestReport$lat[i],popup=popupText) # add marker to plot
    }
    
    map # draw the Leaflet plot!
}