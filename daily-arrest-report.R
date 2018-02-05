## Dependencies
#install.packages("ggmap")
#install.packages("leaflet")

require(ggmap)
require(leaflet)
require(ggplot2)

# Mac users
#install.packages("devtools") # needed in order to compile plotly natively
#devtools::install_github("ropensci/plotly")

plotDailyArrestReport <- function(){
    ## Initial set up
    url <- "https://gis2.nngov.com/ssrs/report/?rs:Name=/12-Police/Daily_Arrests_Public&rs:Command=Render&rs:Format=CSV"
    dataDirectory <- "data"
    fileName <- "./data/daily-arrests.csv"
    setwd("/Users/adam/Documents/Web Projects/R projects/Newport News Open Police Data/")
    colclasses <- c(
        "character", # Arrest_
        "character", # Date_Time
        "character", # Address
        "character", # Charge
        "character", # Arrestee
        "character", # Race
        "character", # Sex
        "character", # Age
        "character", # Report_
        "character", # RA
        "character"  # OFFICER
        )
    cityName <- "NEWPORT NEWS"
    stateName <- "VIRGINIA"
    
    ## Download our data
    if(!file.exists(dataDirectory)) {
        dir.create(dataDirectory)
    }
    if(!file.exists(fileName)) {
       download.file(url,destfile=fileName,method="curl",quiet=TRUE)
    }
    
    ## Create data frame
    data <- read.csv(fileName,skip=5,colClasses=colclasses,stringsAsFactors=FALSE)
    
    ## Data manipulation
    data$Address <- gsub("BLOCK","",data$Address) # remove "BLOCK" from addresses
    data$Address <- gsub("/","AT",data$Address) # convert cross street indicator
    data$Address <- gsub("^0 ","1",data$Address) # remove replace addresses with house number of 0 with 1
    data$Address <- trimws(data$Address) # remove trailing spaces from Address column
    data$Address <- paste(data$Address,cityName,stateName,sep=", ") # add city name to street address
    
    ## Set up Leaflet plot
    map <- leaflet()
    map <- addTiles(map)
    
    ## Geocode addresses to latitude and longitude
    ## From: http://www.storybench.org/geocode-csv-addresses-r/
    for(i in 1:nrow(data)) {
        #print(data$Address[i])
        result <- geocode(data$Address[i],output="latlona",source="google",force=TRUE)
        data$lon[i] <- as.numeric(result[1])
        data$lat[i] <- as.numeric(result[2])
        data$geoAddress[i] <- as.character(result[3])
        popupText <- paste(
            sep="<br/>",
            data$Date_Time[i],
            data$Charge[i]
            )
        map <- addMarkers(map,lng=data$lon[i],lat=data$lat[i],popup=popupText) # add marker to plot
    }
    
    map # draw the Leaflet plot!
}