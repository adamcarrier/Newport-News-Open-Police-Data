## Dependencies
install.packages("googleCloudStorageR")

runCloudStorageSync <- function(workingDirectory,dataSetDirectory="./data/") {
    ## Initial set up
    setwd(workingDirectory)
    source("cloud-storage-env-vars.R") # my Google Cloud Storage API variables
    
    ## Set Google Cloud Storage environment variables
    ## From: https://cran.r-project.org/web/packages/googleCloudStorageR/vignettes/googleCloudStorageR.html
    # for OAuth 2.0 - "R clients" app ID
    
    Sys.setenv(
        #"GCS_CLIENT_ID" = GCS_CLIENT_ID,
        #"GCS_CLIENT_SECRET" = GCS_CLIENT_SECRET,
        #"GCS_DEFAULT_BUCKET" = GCS_DEFAULT_BUCKET,
        "GCS_AUTH_FILE" = paste(workingDirectory,".httr-oauth",sep="/") # auto authentication
        )
    
    ## Set control scope
    options(googleAuthR.scopes.selected = "https://www.googleapis.com/auth/devstorage.read_write")
    
    ## Load the library after the env vars are set
    require("googleCloudStorageR")
    gcs_auth() # init connection
    
    ## Get object info in the default bucket
    gcs_global_bucket(GCS_DEFAULT_BUCKET)
    cloudStorageFiles <- gcs_list_objects() # get a data frame listing all the files with their storage meta data
    
    ## Download each data set as CSV
    #for(i in 1:nrow(cloudStorageFiles)) {
    #    gcs_get_object(cloudStorageFiles$name[[i]],saveToDisk=paste(dataSetDirectory,cloudStorageFiles$name[[i]],sep=""),overwrite=TRUE)
    #}
    
    ## Merge old and new data sets
    
    ## Upload each data set as CSV --only files listed in the cloudStorageFiles data frame will get uploaded
    for(i in 1:nrow(cloudStorageFiles)) {
        gcs_upload(paste(dataSetDirectory,cloudStorageFiles$name[[i]],sep=""),name=cloudStorageFiles$name[[i]])
    }
}