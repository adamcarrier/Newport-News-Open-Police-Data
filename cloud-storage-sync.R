runCloudStorageSync <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Dependencies
    install.packages("googleCloudStorageR")
    require("googleCloudStorageR")
    
    setwd(workingDirectory)
    source("cloud-storage-env-vars.R") # my Google Cloud Storage API variables
    
    ## Data set file names
    dailyAccidentReportFileName <- "newport-news-accident-reports.csv"
    dailyArrestReportFileName <- "newport-news-arrest-reports.csv"
    dailyJuvenileReportFileName <- "newport-news-juvenile-reports.csv"
    dailyOffensesReportFileName <- "newport-news-offenses-reports.csv"
    fieldContactsReportFileName <- "newport-news-field-contacts-reports.csv"
    theftFromVehicleReportFileName <- "newport-news-theft-from-vehicle-reports.csv"
    
    ## Set Google Cloud Storage environment variables
    ## From: https://cran.r-project.org/web/packages/googleCloudStorageR/vignettes/googleCloudStorageR.html
    
    # for OAuth 2.0 - "R clients" app ID
    Sys.setenv("GCS_CLIENT_ID" = GCS_CLIENT_ID,
        "GCS_CLIENT_SECRET" = GCS_CLIENT_SECRET,
        "GCS_DEFAULT_BUCKET" = GCS_DEFAULT_BUCKET)
    # eventually, need to implement Sys.setenv("GCS_AUTH_FILE" = "/fullpath/to/auth.json") to automate authorization
    
    ## Set control scope and log in
    # Scope options include:
    # https://www.googleapis.com/auth/devstorage.full_control
    # https://www.googleapis.com/auth/devstorage.read_write
    # https://www.googleapis.com/auth/cloud-platform
    options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/devstorage.read_write")
    gcs_auth()
    
    ## Get your project name from the API console
    proj <- "public-data-sets-194421"
    
    ## get bucket info
    buckets <- gcs_list_buckets(proj)
    bucket <- "newport-news-open-police-data"
    bucket_info <- gcs_get_bucket(bucket)
    print(bucket_info)
    
    ## Download remote datasets
        # 1. download data sets one at a time
    
    ## get object info in the default bucket
    objects <- gcs_list_objects(bucket=proj)
    print(objects)
        # 2. load each downloaded data set into separate data frames
        # 3. if file exists, load it into a data frame
        # 4. append existing data frame to downloaded data frame
        # 5. overwrite downloaded data fram back to CSV
}