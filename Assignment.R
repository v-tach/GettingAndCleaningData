setwd("/Users/emergencydoc/Sync/Coursera/Getting and cleaning data/Assignment")

library(readr)
library(dplyr)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "HARDataset.zip")

unzip("HARDataset.zip")

setwd("/Users/emergencydoc/Sync/Coursera/Getting and cleaning data/Assignment/UCI HAR Dataset")

activityLabels <- read_table("activity_labels.txt", 
							col_names = c("label", "activity"))


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



setwd("/Users/emergencydoc/Sync/Coursera/Getting and cleaning data/Assignment/UCI HAR Dataset/test")

subject <- read_table("subject_test.txt", col_names = "subject")
sensor_results <- read_table("X_test.txt", col_names = measurements)
activity <- read_table("Y_test.txt", col_names = "activity")

test_data <- bind_cols(subject, activity, sensor_results)

setwd("/Users/emergencydoc/Sync/Coursera/Getting and cleaning data/Assignment/UCI HAR Dataset/train")

subject <- read_table("subject_train.txt", col_names = "subject")
sensor_results <- read_table("X_train.txt", col_names = measurements)
activity <- read_table("Y_train.txt", col_names = "activity")

train_data <- bind_cols(subject, activity, sensor_results)

grepl(pattern = "mean|std", x = measurements)