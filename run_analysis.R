


## Download the data files and unzip them

library(readr)
library(dplyr)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "HARDataset.zip")

unzip("HARDataset.zip")

## read in the data files


setwd("UCI HAR Dataset")

## read in the labels for the activities that were monitored

activityLabels <- read_table("activity_labels.txt", 
							col_names = c("level", "label"))

## read in the names of the variables that were measured or calculated
## and get rid of parentheses, commas and slashes
## that could interfere with their use in R commands

measurements <- read.table("features.txt", stringsAsFactors = FALSE)
measurements <- as.vector(measurements[,2])
measurements <- gsub(pattern = "*\\(\\)", 
					replacement = "", 
					x = measurements)
measurements <- gsub(pattern = "*\\(", 
					replacement = "_", 
					x = measurements)
measurements <- gsub(pattern = "*\\)", 
					replacement = "", 
					x = measurements)
measurements <- gsub(pattern = ",", 
					replacement = "_", 
					x = measurements)


## read in the test data and add columns for the subjects & activities

setwd("test")

subject <- read_table("subject_test.txt", col_names = "subject")
sensor_results <- read_table("X_test.txt", col_names = measurements)
activity <- read_table("Y_test.txt", col_names = "activity")

test_data <- bind_cols(subject, activity, sensor_results)
rm(list = c("subject", "activity", "sensor_results"))
setwd("..")

## read in the train data

setwd("train")

subject <- read_table("subject_train.txt", col_names = "subject")
sensor_results <- read_table("X_train.txt", col_names = measurements)
activity <- read_table("Y_train.txt", col_names = "activity")
train_data <- bind_cols(subject, activity, sensor_results)
rm(list = c("subject", "activity", "sensor_results"))

setwd("..")

## combine the two sets of data

combined_data <- bind_rows(test_data, train_data)

## set the activity levels to their character names

combined_data$activity <- factor(combined_data$activity, 
				levels = activityLabels$level, 
				labels = activityLabels$label)

## pick out the variables 
## in this case I have decided to include any variable that
## contains "Mean" "mean" or "std" in the name

mean_std_data <- combined_data  %>%
				select(subject, activity, matches("[Mm]ean|std"))

avg_data <- mean_std_data %>%
				group_by(subject, activity) %>%
				summarise_each(funs(mean))

setwd("..")	
write_csv(avg_data, path = "average_data.csv")



