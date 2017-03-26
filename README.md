# Getting-and-Cleaning-Data-Course-Project


1. Merges the Training and Testing Sets into 1 data set called data.all

data.all <- rbind(data.train, data.test)

2. Extracts only the measurements on the mean and standard deviation for each measurement.

mean_std.select <- grep('mean|std', features)
data.sub <- data.all[,c(1,2,mean_std.select + 2)]

3. Uses descriptive activity names to name the activities in the data set

This is done by reading the labels from the activity_labels.txt file

activity.labels <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]

4. Appropriately labels the data set with descriptive variable names.

Replace the names in data set with names from activity labels

name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Tidy data as output as data_tidy.txt file

data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)
