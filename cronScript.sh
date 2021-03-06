#!/bin/bash

# change to repo directory
cd "/Users/adam/Documents/Data Projects/Personal/Newport-News-Open-Police-Data"

# run cron script that runs the daily collection, cloud sync, and leaflet plot
# output goes to a file called a.Rout, which git will ignore
R CMD BATCH "./cron-job.R"

# commit updated index.html Leaflet map
git add index.html
git commit -m "Daily update"
git push