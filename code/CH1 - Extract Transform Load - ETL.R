> bike <- read.csv("./data/bike_share_data.csv")
> str(bike)
'data.frame':	17379 obs. of  12 variables:
  $ datetime  : Factor w/ 17379 levels "1/1/2011 0:00",..: 1 2 13 18 19 20 21 22 23 24 ...
$ season    : int  1 1 1 1 1 1 1 1 1 1 ...
$ holiday   : int  0 0 0 0 0 0 0 0 0 0 ...
$ workingday: int  0 0 0 0 0 0 0 0 0 0 ...
$ weather   : int  1 1 1 1 1 2 1 1 1 1 ...
$ temp      : num  9.84 9.02 9.02 9.84 9.84 ...
$ atemp     : num  14.4 13.6 13.6 14.4 14.4 ...
$ humidity  : int  81 80 80 75 75 75 80 86 75 76 ...
$ windspeed : num  0 0 0 0 0 ...
$ casual    : int  3 8 5 3 0 0 2 1 1 8 ...
$ registered: int  13 32 27 10 1 1 0 2 7 6 ...
$ count     : int  16 40 32 13 1 1 2 3 8 14 ...
> # str function used for viewing structure of dataset
  > # first extract for days bikes rented to casual users with revenue grouped by season
  > library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:
  
  filter, lag

The following objects are masked from ‘package:base’:
  
  intersect, setdiff, setequal, union

> extracted_rows <- filter(bike, registered == 0, season == 1 | season == 2)
> dim(extracted_rows)
[1] 10 12
> #
  > # Created subset of data using filter function combined with == operator to data frame extracted_rows. The dim function calls 10 observations that meet the filter criteria. Confirmation of observations can be determined using %in% operator.
  > #
  > using_membership <- filter(bike, registered == 0, season %in% c(1,2))
> identical(extracted_rows, using_membership)
[1] TRUE
> #
  > # Additional dataset created to compare criteria. True indicates identical datasets.
  > #
  > # Select function used for creating columns for the final dataset for determination of season and casual renters.
  > #
  > extracted_columns <- select(extracted_rows, season, casual)
> #
  > # Add computation column for rental costs assuming renters pay $5 per day pass using mutate function.
  > #
  > add_revenue <- mutate(extracted_columns, revenue = casual * 5)
> #
  > # Use group by function to group by season
  > #
  > grouped <- group_by(add_revenue, season)
> #
  > # Summarize function used to arrange data frame and associated variables and parameters.
  > report <- summarize(grouped, sum(casual), sum(revenue))
> # quick view of results
  > report
# A tibble: 2 x 3
season `sum(casual)` `sum(revenue)`
<int>         <int>          <dbl>
  1      1            14             70
2      2             4             20
> #
  > # Writing data results to CSV file
  > #
  > write.csv(report, "revenue_report.csv", row.names = FALSE)
> 