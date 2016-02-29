

# This is an summary of how the data analysis was done
## Load the required packages and download the data files and unzip them

	library(readr)
	library(dplyr)
	
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "HARDataset.zip")
	
	unzip("HARDataset.zip") ```

## Read in the data files


	setwd("UCI HAR Dataset")

## Read in the labels for the activities that were monitored

	activityLabels <- read_table("activity_labels.txt", 
							col_names = c("level", "label"))

## Read in the names of the variables that were measured or calculated and get rid of parentheses, commas and slashes that could interfere with their use in R commands

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


## Read in the test data and add columns for the subjects & activities

	setwd("test")
	
	subject <- read_table("subject_test.txt", col_names = "subject")
	sensor_results <- read_table("X_test.txt", col_names = measurements)
	activity <- read_table("Y_test.txt", col_names = "activity")

	test_data <- bind_cols(subject, activity, sensor_results)
	rm(list = c("subject", "activity", "sensor_results"))
	setwd("..")

## Read in the train data and add columns for the subjects & activities

	setwd("train")

	subject <- read_table("subject_train.txt", col_names = "subject")
	sensor_results <- read_table("X_train.txt", col_names = measurements)
	activity <- read_table("Y_train.txt", col_names = "activity")
	
	train_data <- bind_cols(subject, activity, sensor_results)
	rm(list = c("subject", "activity", "sensor_results"))
	setwd("..")

## Combine the two sets of data

	combined_data <- bind_rows(test_data, train_data)

## Set the activity levels to their character names to make the dataset more comprehensible

	combined_data$activity <- factor(combined_data$activity, 
				levels = activityLabels$level, 
				labels = activityLabels$label)

## Pick out the variables from the dataset that include means or standard deviations. In this analysisgit I have decided to include any variable that contains "Mean" "mean" or "std" in the name

	mean_std_data <- combined_data  %>%
				select(subject, activity, matches("[Mm]ean|std"))

## Calculate the averages for each subject, broken down by activity
	avg_data <- mean_std_data %>%
				group_by(subject, activity) %>%
				summarise_each(funs(mean))

	setwd("..")	

## Write out the data into a csv file.

	write_csv(avg_data, path = "average_data.csv")



