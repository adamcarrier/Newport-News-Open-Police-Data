Newport-News-Open-Police-Data
=============================

My attempts to collect, save, and visualize daily police reports, which are listed on the [Newport News Police Open Data](https://www.nnva.gov/2229/Open-Data) page.

Usage
============

## Daily report collection

Using the `daily-collection.R` file, you can run the `runDailyCollection` function to automatically download all the daily [Newport News Police Open Data](https://www.nnva.gov/2229/Open-Data) reports and append them to CSV file data sets. Notice, you must tell the function your working directory where these repo files are stored.

``` r
cwd <- "/Users/adam/Documents/Newport News Open Police Data"
runDailyCollection(cwd)
```

If you're saavy, you could use a scheduler like `cron` to run this on a daily basis after midnight. This would allow you to create your own database of of police reports.

## Plotting the reports

Using the `plot-reports.R` file, you can run the `plotReports` function to automatically plot on a Leaflet map all police activity stored in the CSV data sets. It saves the plot in an HTML file that you can view from a web server. I use [MAMP](https://www.mamp.info/) on my Mac for this. On Windows, you can use [WAMP](http://www.wampserver.com/en/) or [XAMMP](https://www.apachefriends.org/index.html) to serve the HTML Leaflet plot. Notice, you must tell the function your working directory where these repo files are stored.

You can view a sample of the Leaflet plot [here](https://adamcarrier.github.io/Newport-News-Open-Police-Data/).

``` r
cwd <- "/Users/adam/Documents/Newport News Open Police Data"
plotReports(cwd)
```

Public Data Sets
================

Public versions of the appended daily reports are available as CSV files on Google Cloud Storage, which I maintain:

* [Accident Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-accident-reports.csv)
* [Arrest Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-arrest-reports.csv)
* [Juvenile Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-juvenile-reports.csv)
* [Offenses Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-offenses-reports.csv)
* [Field Contacts Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-field-contacts-reports.csv)
* [Theft from Vehicle Reports](https://storage.googleapis.com/newport-news-open-police-data/newport-news-theft-from-vehicle-reports.csv)

Roadmap
================

A list of things still to accomplish:
* Remove trailing whitespace from all ingested reports
* Automate daily report collection using hosted `cron` job (maybe use Google App Engine Cron Service?)
* Automate CSV data set upload to Google Cloud storage
* Try to make this more DRY--Put config variables like file and column names into vectored lists that can be passed to granular worker functions