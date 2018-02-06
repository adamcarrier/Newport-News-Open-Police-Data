Newport-News-Open-Police-Data
=============================

My attempts to collect, save, and visualize daily police reports, which are listed on the [Newport News Police Open Data](https://www.nnva.gov/2229/Open-Data) page.

Usage
============

## Daily report collection

Using the `daily-collection.R` file, you can run the `runDailyCollection` function to automatically download all the daily [Newport News Police Open Data](https://www.nnva.gov/2229/Open-Data) reports and append them to CSV file data sets. For this to work, you must provide the working directory where these repo files are stored.

``` r
cwd <- "/Users/adam/Documents/Newport News Open Police Data"
runDailyCollection(cwd)
```

If you're saavy, you could use a scheduler like `cron` to run this on a daily basis after midnight. This would allow you to create your own database of of police reports.

## Plotting the reports

Using the `plot-reports.R` file, you can run the `plotReports` function to automatically display all police activity stored in the CSV file data sets on a Leaflet map. For this to work, you must provide the working directory where these repo files are stored.

Currently, only the Daily Arrest Report is plotted, as I still need to build out the other reports and loop through them to plot them all. 

 ``` r
cwd <- "/Users/adam/Documents/Newport News Open Police Data"
plotReports(cwd)
```

Public Data Sets
================

Public versions of the appended daily reports are available as CSV files on Google Cloud Storage, which I maintain:

* Accident Reports (coming soon)
* [Arrest Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-arrest-reports.csv)
* Juvenile Reports (coming soon)
* Offenses Reports (coming soon)
* Field Contacts Reports (coming soon)
* Theft from Vehicle Reports (coming soon)

Roadmap
================

A list of things still to accomplish
* Create ingest and processing R scripts for each remaining report
* Upload CSV data set to Google Cloud storage for for each remaining report
* Automate daily report collection using hosted `cron` job
* Automate CSV data set upload to Google Cloud storage
* Find public hosting for RStudio Leaflet widget