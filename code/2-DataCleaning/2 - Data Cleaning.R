# Summarize data for inspection

bike <- read.csv("./data/raw_bikeshare_data.csv",
                 stringsAsFactors = FALSE)
str(bike)

# Find and fix flawed data

# Missing values

table(is.na(bike))

if(!require("stringr")) install.packages("stringr")
suppressMessages(suppressWarnings(library(stringr)))
str_detect(bike, "NA")
table(is.na(bike$sources))

# Erroneous values

bad_data <- str_subset(bike$humidity, "[a-z A-Z]")
location <- str_detect(bike$humidity, bad_data)
bike[location, ]

# Fixing of flaws in dataset

bike$humidity <- str_replace_all(bike$humidity, bad_data, "61")
bike[location, ]

# Convert inputs to data types suitable for analysis

# Convert between data types

bike$humidity <- as.numeric(bike$humidity)

bike$holiday <- factor(bike$holiday, levels = c(0, 1),
                       labels = c("no", "yes"))

bike$workingday <- factor(bike$workingday, levels = c(0, 1),
                          labels = c("no", "yes"))

bike$season <- factor(bike$season, levels = c(1, 2, 3, 4),
                      labels = c("spring", "summer",
                                 "fall", "winter"),
                      ordered = TRUE )

bike$weather <- factor(bike$weather, levels = c(1, 2, 3, 4),
                       labels = c("clr_part_cloud",
                                  "mist_cloudy",
                                  "lt_rain_snow",
                                  "hvy_rain_snow"),
                       ordered = TRUE )
str(bike)

# Date and time conversion

if(!require("lubridate")) install.packages("lubridate")
suppressMessages(suppressWarnings(library(lubridate)))
bike$datetime <- mdy_hm(bike$datetime)
str(bike)

# Adapting String Variables to a Standard

unique(bike$sources)
bike$sources <- tolower(bike$sources)
bike$sources <- str_trim(bike$sources)
na_loc <- is.na(bike$sources)
bike$sources[na_loc] <- "unknown"
unique(bike$sources)

# power of seven, plus or minus two

if(!require("DataCombine")) install.packages("DataCombine")
suppressMessages(suppressWarnings(library(DataCombine)))
web_sites <- "(www.[a-z]*.[a-z]*)"
current <- unique(str_subset(bike$sources, web_sites))
replace <- rep("web", length(current))
replacements <- data.frame(from = current, to = replace)
bike <- FindReplace(data = bike, Var = "sources", replacements,
                    from = "from", to = "to", exact = FALSE)
unique(bike$sources)

bike$sources <- as.factor(bike$sources)

# ready data for analysis

str(bike)

write.csv(bike, "clean_bike_sharing_data.csv",
          row.names = FALSE)