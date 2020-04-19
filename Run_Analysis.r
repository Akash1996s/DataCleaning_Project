#Loading Dplyr package
library(dplyr)

#Set working Directory..
setwd("F:/Dplyr/DataCleaning/week4/Project/UCI HAR Dataset")

# Reading Activity Data for Test data..
X_TestData <- read.table("./test/X_test.txt", header = F)
#Reading Activity Data for Train Data..
X_TrainData <- read.table("./train/X_train.txt")

#Reading Features File.
FeaturesData <- read.table("features.txt")

#Reading Activity labels file..
ActvLabel <- read.table("activity_labels.txt")

#Reading Label files for Train and Test..
Y_TestData <- read.table("./test/y_test.txt")
y_TrainData <- read.table("./train/y_train.txt")

#Reading Subject File for test and train..
sub_test <- read.table("./test/subject_test.txt")
sub_train <- read.table("./train/subject_train.txt")


##Combining Subject Data..
Sub_data <- rbind(sub_test,sub_train)

##Combining Activity Data..
CombinedSet <- rbind(X_TestData,X_TrainData)

##Combining Label Data..
CombinedLabel <- rbind(Y_TestData,y_TrainData) 


###Renaming the Column Names..
names(Sub_data) <- "Subject"
names(ActvLabel) <- c("ActivityNum", "Activity")
names(CombinedLabel) <- "ActivityNum"
names(FeaturesData) <- c("V1","Features")

###Renaming Combined Activity data column names with Features Names..
names(CombinedSet) <- FeaturesData$Features

###Left Joining the Activity Label to link it with Activity Names..
Label <- left_join(CombinedLabel,ActvLabel, by = "ActivityNum")[,2]

###Combining all the Data to make a combined data set..
DataSet <- cbind(Sub_data,Label)
DataSet <- cbind(DataSet, CombinedSet)

###Filtering the Mean and Standard deviation Features.
Sub_FeaturesData <- FeaturesData$Features[grep("mean\\(\\)| std\\(\\)",FeaturesData$Features)]

####Selecting the Desired Column From the Combined DataSet..
ColNames <- c("Subject", "Label", as.character(Sub_FeaturesData))
DataSet <- subset(DataSet, select = ColNames)


#####Making Data Tidy Replacing the Abbreviations with their Full Names...
names(DataSet) <- gsub("^t", "Time", names(DataSet))
names(DataSet) <- gsub("^f", "Frequency", names(DataSet))
names(DataSet) <- gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet) <- gsub("Mag", " Magnitude", names(DataSet))
names(DataSet) <- gsub("Acc", "Acceleration", names(DataSet))
names(DataSet) <- gsub("^t", "Time", names(DataSet))


#####Making Data Tidy by aggregating the by means.

TidyDataSet<-aggregate(. ~Subject + Label, DataSet, mean)
TidyDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Label),]

#Writing the tidy data to a text file..
write.table(TidyDataSet, file = "tidydata.txt",row.name=FALSE)
