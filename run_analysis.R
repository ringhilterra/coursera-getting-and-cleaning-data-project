#TidyData Script Ryan Inghilterra
library(plyr);
#make sure you have the zip downloaded and unzipped the data into working directory
#there should be a directory called "UCI HAR Dataset" in your working directory
# this is necessary for the script to run 
#1. Merges the training and the test sets to create one data set.#
subjectTrainData <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
activityTrainData <- read.table("UCI HAR Dataset/train/Y_train.txt", header = FALSE)
featureTrainData <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
subjectTestData <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTestData <- read.table("UCI HAR Dataset/test/Y_test.txt", header = FALSE)
featureTestData <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

combinedSubject <- rbind(subjectTrainData, subjectTestData)
combinedActivity <- rbind(activityTrainData, activityTestData)
combinedFeature <- rbind(featureTrainData, featureTestData)
names(combinedActivity) <- c("Activity")
names(combinedSubject) <- c("Subject")
featureNames <- read.table("UCI HAR Dataset/features.txt", header= FALSE)
names(combinedFeature) <- featureNames$V2
combinedSubjectActivity <- cbind(combinedSubject, combinedActivity)
fullMergedData <- cbind(combinedSubjectActivity, combinedFeature)
#2.Extracts only the measurements on the mean and standard deviation for each measurement.#
subsettedFeatureNames <- featureNames$V2[grep("std\\(\\)|mean\\(\\)", featureNames$V2)]
subsettedColumnNames<-c("Subject", "Activity", as.character(subsettedFeatureNames))
fullMergedData <- subset(fullMergedData, select=subsettedColumnNames)
#3.Uses descriptive activity names to name the activities in the data set#
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE)
activityLabels2 <- unlist(lapply(activityLabels$V2, as.character))
fullMergedData$Activity[fullMergedData$Activity == 1] <- activityLabels2[1]
fullMergedData$Activity[fullMergedData$Activity == 2] <- activityLabels2[2]
fullMergedData$Activity[fullMergedData$Activity == 3] <- activityLabels2[3]
fullMergedData$Activity[fullMergedData$Activity == 4] <- activityLabels2[4]
fullMergedData$Activity[fullMergedData$Activity == 5] <- activityLabels2[5]
fullMergedData$Activity[fullMergedData$Activity == 6] <- activityLabels2[6]
#4. Appropriately labels the data set with descriptive variable names. #
colNames  = colnames(fullMergedData); 
for (i in 1:length(colNames)) 
{
    colNames[i] <- gsub("^t", "time", colNames[i])
    colNames[i] <- gsub("^f", "frequency", colNames[i])
    colNames[i] <-gsub("Acc", "Accelerometer", colNames[i])
    colNames[i] <-gsub("Gyro", "Gyroscope", colNames[i])
    colNames[i] <-gsub("Mag", "Magnitude", colNames[i])
    colNames[i] <-gsub("BodyBody", "Body", colNames[i])
};
colnames(fullMergedData) = colNames;

#5. From the data set in step 4, creates a second, independent tidy data set with 
#   the average of each variable for each activity and each subject.#
fullMergedData2<-aggregate(. ~Subject + Activity, fullMergedData, mean)
write.table(fullMergedData2, file = "finaldata.txt",row.name=FALSE)