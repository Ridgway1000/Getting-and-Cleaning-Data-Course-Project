

#### read in all required data and store them into variables

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))

#### test data

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
functions_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
code_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")

#### train data

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
functions_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
code_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


##### merge the test and train data sets together into 1 variable named combined_data

functions_bind <- rbind(functions_train, functions_test)
code_bind <- rbind(code_train, code_test)
subject <- rbind(subject_train, subject_test)
combined_data <- cbind(subject, code_bind, functions_bind)


#### Extracts only the measurements on the mean and standard deviation for each measurement into a variable named tidy_data

tidy_data <- combined_data %>% select(subject, code, contains("mean"), contains("std"))


#### Use descriptive activity names to name the activities in the data set.

tidy_data$code <- activity_labels[tidy_data$code, 2]


#### label the variables with descriptive names using gsub

names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "Time_Body", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data))
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data))
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))


#####create an independant data set with an average of each variable - assigned it to final_average_data

final_average_data <- tidy_data %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(final_average_data, "Final_Average_Data.txt", row.name=FALSE)


