setwd("D:/coursera/C3W4")

# 1. Merge the training and the test sets to create one data set.

## download data from website and unzip
if(!file.exists("./data")) {
  dir.create("./data")
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, "./data/projectData_getCleanData.zip")
  listZip <- unzip("./data/projectData_getCleanData.zip", exdir = "./data")
}

## assigning all data frames
featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test<- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## merging train and test data
trainData <- cbind(subject_train, y_train, x_train)
testData <- cbind(subject_test, y_test, x_test)
allData <- rbind(trainData, testData)


# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

## extracting mean and standard deviation of each measurements
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
tidyData <- allData[, c(1, 2, featureIndex+2)]
colnames(tidyData) <- c("subject", "activity", featureName[featureIndex])

# 3. Uses descriptive activity names to name the activities in the data set

## replace 1 to 6 with activity names
tidyData$activity <- factor(tidyData$activity, levels = activityName[,1], labels = activityName[,2])

# 4. Appropriately labels the data set with descriptive variable names.

names(tidyData) <- gsub("\\()", "", names(tidyData))
names(tidyData) <- gsub("^t", "time", names(tidyData))
names(tidyData) <- gsub("^f", "frequence", names(tidyData))
names(tidyData) <- gsub("-mean", "Mean", names(tidyData))
names(tidyData) <- gsub("-std", "Std", names(tidyData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
finalData <- tidyData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(finalData, "FinalData.txt", row.names = FALSE)

