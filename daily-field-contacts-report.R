## Dependencies
# install.packages("ggmap") # ignore current CRAN package; it's out-of-date
if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap",ref="tidyup",force=TRUE) # install latest ggmap from GitHub, until CRAN is updated

getDailyFieldContactsReport <- function(workingDirectory,dataSetDirectory="./data/") {
    require(ggmap)
    
    ## Initial set up
    source("cloud-storage-env-vars.R") # my Google Cloud Storage API variables
    register_google(key = GC_API_KEY) # GC_API_KEY var is the Google Maps API key
    
    url <- "https://gis2.nngov.com/ssrs/report/?rs:Name=/12-Police/Daily_Field_Contacts_Public&rs:Command=Render&rs:Format=CSV"
    fileName <- "Daily_Field_Contacts_Public.csv"
    destinationFile <- paste0(dataSetDirectory,fileName)
    setwd(workingDirectory)
    columnNames = c(
        "FieldID", # Field_ID
        "DateTime", # Date_Time
        "Address", # Address
        "Reason", # Reason
        "Disposition", # Disposition
        "Race", # Race
        "Sex", # Sex
        "Age", # Age
        "ReportingArea", # RA
        "Officer"  # Officer
    )
    columnClasses <- c(
        "character", # Field_ID
        "character", # Date_Time
        "character", # Address
        "character", # Reason
        "character", # Disposition
        "character", # Race
        "character", # Sex
        "character", # Age
        "character", # RA
        "character" # Officer
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
    
    ## Reformating
    data <- data.frame(lapply(data,function(x) if(class(x)=="character") trimws(x) else(x)),stringsAsFactors=FALSE) # remove trailing whitespace
    data$Address <- gsub("BLOCK","",data$Address) # remove "BLOCK" from addresses
    data$Address <- gsub("/","AT",data$Address) # convert cross street indicator
    data$Address <- gsub("^0 ","1",data$Address) # replace addresses with a house number of 0 with a 1
    data$Address <- paste(data$Address,cityName,stateName,sep=", ") # add city name to street address
    
    ## Geocode addresses to latitude and longitude
    ## From: http://www.storybench.org/geocode-csv-addresses-r/
    for(i in 1:nrow(data)) {
        # geocode and split lat and long into new columns
        result <- geocode(data$Address[i],output="latlona",source="google",messaging=FALSE,force=TRUE)
        data$Longitude[i] <- as.numeric(result[1])
        data$Latitude[i] <- as.numeric(result[2])

        # reformat DateTime
        splitDateTime <- strsplit(data$DateTime[i],":") # split string at colon
        splitDateTime[[1]][[2]] <- gsub("(\\d{2})(?=\\d{2})","\\1:",splitDateTime[[1]][[2]],perl=TRUE) # add colon back into time
        splitDateTime[[1]][[2]] <- format(strptime(splitDateTime[[1]][[2]],format='%H:%M',tz="EST"),'%I:%M %p') # format into readable 12-hours
        data$Date[i] <- splitDateTime[[1]][[1]] # split into Date column
        data$Time[i] <- splitDateTime[[1]][[2]] # split into Time column
    }

    ## Swap out DateTime for tidy Date and Time columns
    data <- subset(data, select = -DateTime ) # drop DateTime column
    data <- data[,c("FieldID", "Date", "Time", "Address", "Reason", "Disposition", "Race", "Sex", "Age", "ReportingArea", "Officer", "Longitude", "Latitude")] # new column order
    
    data # return the clean data frame
}