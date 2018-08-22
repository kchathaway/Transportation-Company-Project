bike <- read.csv("./data/bike_share_data.csv")
str(bike) # str function used for viewing structure of dataset

# first extract for days bikes rented to casual users with revenue grouped by season

library(dplyr)

extracted_rows <- filter(bike, registered == 0, season == 1 | season == 2)
dim(extracted_rows)

# created subset of data using filter function combined with '==' operator to data frame
# named extracted_rows. The 'dim' function calls 10 observations that meet the filter
# criteria. Confirmation of observations can be determined using '%in% opeartor.

use_membership <- filter(bike, registered == 0, season %in% c(1,2))
identical(extracted_rows, use_membership)

# additional dataset created to compare criteria. 'True' indicates identical datasets.

# 'select' function used for creating columns for the final dataset for determination of season and casual renters.

extracted_columns <- select(extracted_rows, season, casual)

# add computation column for renatl costs assuming renters pay $5 per day using 'mutate' function

add_revenue <- mutate(extracted_columns, revenue = casual * 5)

# use group by function to group by season

grouped <- group_by(add_revenue, season)

# summarize function used to arrange data frame and associated variables and parameters

report <- summarize(grouped, sum(casual), sum (revenue))

# quick view of results

report

# writing data results to CSV file

write.csv(report, "revenue_report.csv", row.names = FALSE)


