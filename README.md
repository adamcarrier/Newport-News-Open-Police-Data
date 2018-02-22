Newport-News-Open-Police-Data
=============================

My attempts at using the R language to collect, save, and visualize daily police reports, which are listed on the [Newport News Police Open Data](https://www.nnva.gov/2229/Open-Data) page.

Usage
============

## Daily report collection

Using the `daily-collection.R` file, you can run the `runDailyCollection` function to automatically download all the daily [Newport News Police Open Data](https://www.nnva.gov/2229/Open-Data) reports and append them to CSV file data sets. Notice, you must tell the function your working directory where these repo files are stored.

``` r
repo <- "/Users/adam/Documents/Newport News Open Police Data"
source("/Users/adam/Documents/Newport News Open Police Data/daily-collection.R")
runDailyCollection(repo)
```

If you're saavy, you could use a scheduler like `cron` to run this on a daily basis after midnight. This would allow you to create your own database of of police reports.

## Plotting the reports

Using the `plot-reports.R` file, you can run the `plotReports` function to automatically plot on a Leaflet map all police activity stored in the CSV data sets. It saves the plot in an HTML file that you can view from a web server. I use [MAMP](https://www.mamp.info/) on my Mac for this. On Windows, you can use [WAMP](http://www.wampserver.com/en/) or [XAMMP](https://www.apachefriends.org/index.html) to serve the HTML Leaflet plot. Notice, you must tell the function your working directory where these repo files are stored.

You can view a sample of the Leaflet plot [here](https://adamcarrier.github.io/Newport-News-Open-Police-Data/).

``` r
repo <- "/Users/adam/Documents/Newport News Open Police Data"
source("/Users/adam/Documents/Newport News Open Police Data/plot-reports.R")
plotReports(repo)
```

## Automatic data collection

I've included some scripts for automating the entire process of downloading and cleaning the daily CSVs, uploading them to a Google Cloud Storage account (via API keys), and creating the HTML Leaflet plot.

Modify them for your needs, but here's how they work for me:

* `cron-job.R`: This R script automates the jobs. You must change the `repo` variable to point to your repo directory.
* `cronScript`: This bash shell script will call the `cron-job.R` R script to run the jobs. It then pushes the updated `index.html` Leaflet plot to your fork of this repo. I call this script daily, as you'd guess, via `cron` on my Mac.

**Just one caveat...**

Before running the Leaflet plot via R on a command-line, I suggest you also install [Pandoc](https://pandoc.org/installing.html). On a Mac, you'd need to do this via [Homebrew](https://brew.sh/). Pandoc is responsible for combining and encoding all the Leaflet HTML and JavaScript assets into the single `index.html` file. Pandoc is included with [RStudio](https://www.rstudio.com/)'s binaries and runs automatically via the GUI, but it's unavailable if you're running R headless.

If you don't install [Pandoc](https://pandoc.org/installing.html), you'll still get the `index.html` file, but you'll also get a subfolder `index_files` in the repo with all the assets needed to run Leaflet--it's quite a lot of files.

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
* Make the public data sets a daily log
* Try to make this more DRY--Put config variables like file and column names into vectored lists that can be passed to granular worker functions