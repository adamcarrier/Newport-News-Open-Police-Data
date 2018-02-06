getDailyArrestReport <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Initial set up
    url <- "https://gis2.nngov.com/ssrs/report/?rs:Name=/12-Police/Daily_Arrests_Public&rs:Command=Render&rs:Format=CSV"
    fileName <- "daily-arrests.csv"
    destinationFile <- paste(dataSetDirectory,fileName,sep="/")
    setwd(workingDirectory)
    columnNames = c(
        "Arrest", # Arrest_
        "DateTime", # Date_Time
        "Address", # Address
        "Charge", # Charge
        "Arrestee", # Arrestee
        "Race", # Race
        "Sex", # Sex
        "Age", # Age
        "Report", # Report_
        "RescueAmbulanceUnit", # RA
        "Officer"  # OFFICER
    )
    columnClasses <- c(
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
    
    ## Create data directory
    if(!file.exists(dataSetDirectory)) {
        dir.create(dataSetDirectory)
    }
    
    ## Download our data
    download.file(url,destfile=destinationFile,method="curl",quiet=TRUE)
    
    ## Create data frame
    data <- read.csv(destinationFile,skip=5,col.names=columnNames,colClasses=columnClasses,stringsAsFactors=FALSE)
    
    ## Delete daily report file
    if (file.exists(destinationFile)) file.remove(destinationFile)
    
    ## Reformat addresses
    data$Address <- gsub("BLOCK","",data$Address) # remove "BLOCK" from addresses
    data$Address <- gsub("/","AT",data$Address) # convert cross street indicator
    data$Address <- gsub("^0 ","1",data$Address) # replace addresses with a house number of 0 with a 1
    data$Address <- trimws(data$Address) # remove trailing spaces from Address column
    data$Address <- paste(data$Address,cityName,stateName,sep=", ") # add city name to street address
    
    ## Set up Leaflet plot
    map <- leaflet()
    map <- addTiles(map)
    
    ## Geocode addresses to latitude and longitude
    ## From: http://www.storybench.org/geocode-csv-addresses-r/
    for(i in 1:nrow(data)) {
        # geocode and split lat and long into new columns
        result <- geocode(data$Address[i],output="latlona",source="google",messaging=FALSE,force=TRUE)
        data$lon[i] <- as.numeric(result[1])
        data$lat[i] <- as.numeric(result[2])

        # reformat DateTime
        splitDateTime <- strsplit(data$DateTime[i],":") # split string at colon
        splitDateTime[[1]][[2]] <- gsub("(\\d{2})(?=\\d{2})","\\1:",splitDateTime[[1]][[2]],perl=TRUE) # add colon back into time
        splitDateTime[[1]][[2]] <- format(strptime(splitDateTime[[1]][[2]],format='%H:%M',tz="EST"),'%I:%M %p') # format into readable 12-hours
        stdDateTime <- paste(splitDateTime[[1]][[1]],splitDateTime[[1]][[2]],sep=" ") # recombine formatted date and time
        data$DateTime[i] <- stdDateTime # column date and time is now standardized
    }
    
    data # return the clean data frame
}