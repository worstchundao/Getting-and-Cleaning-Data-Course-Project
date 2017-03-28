## Set up work directory to the right work directory

setwd("C:/Daily Mail/R")

## Download the zip file to the right work directory

## Unzip the downloaded file

unzip("UCI HAR Dataset.zip")

## Read the test data and train data

x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

## Read the subject data

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Read features and activities

features <- read.table("UCI HAR Dataset/features.txt")
activity <- read.table("UCI HAR Dataset/activity_labels.txt")

## 1.Merges the training and the test sets to create one data set

x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
whole_data <- cbind(x,y)
subject<-rbind(subject_test, subject_train)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement

feature_index <- grep("mean\\(\\)|std\\(\\)", features[,2]) 
feature_data <- features[feature_index,]

## 3.Uses descriptive activity names to name the activities in the data set

y[,1] <- as.character(y[,1])
activity[,1] <- as.character(activity[,1])
y[,1] <- activity[y[,1],2]

## 4.Appropriately labels the data set with descriptive variable names

x <- x[,feature_index]
feature_name <- features[feature_index,2]
names(x) <-feature_name
names(subject) <- "Subject"
names(y)<- "Activity"
tidy_data <- cbind(subject, y, x)

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

library(plyr)
output_data <- aggregate(. ~Subject + Activity, tidy_data, mean)
output_data <- output_data[order(output_data$Subject,output_data$Activity),]
write.table(output_data, file = "tidydata.txt",row.name=FALSE)
