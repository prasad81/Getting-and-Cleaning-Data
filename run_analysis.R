
##Here are the data for the project:

##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##You should create one R script called run_analysis.R that does the following.

##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement.
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names.
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# Read the data from files


setwd("C:\\R\\coursera\\github\\Getting-and-Cleaning-Data")
getwd()
## create a directory if not exist
if(!file.exists("data")){
  dir.create("data")
}
## download the data file
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "data/dataset.zip")

##unzip dataset
unzip(zipfile = "data/dataset.zip", exdir = "data")

## reading the data

training_x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
training_y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
training_subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

test_x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")



# Read the feature list file
features <- read.table("data/UCI HAR Dataset/features.txt")

# Read the activity labels
activityLabels <- read.table("data/UCI HAR Dataset/activity_labels.txt")


#### 1. Merges the training and the test sets to create one data set.

##merging the datasets by rows
mergeddatafeatures <- rbind(training_x, test_x)
mergeddataactivity <- rbind(training_y, test_y)
mergeddatasubject <- rbind(training_subject, test_subject)


## set the variable names
names(mergeddatasubject)<-c("subject")
names(mergeddataactivity)<- c("activity") 
names(mergeddatafeatures)<- features$V2

#merge the columns to get the single datafram
dataCombine <- cbind(mergeddatasubject, mergeddataactivity)
Data <- cbind(mergeddatafeatures, dataCombine)
##View(Data)

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

##Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
 

#### 3. Uses descriptive activity names to name the activities in the data set
#### 4. Appropriately labels the data set with descriptive variable names.

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

##names(Data)
 
 

####5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.csv",row.name=FALSE)
 
 
 ## generating codebook md file
install.packages("knitr")
library(knitr)
knit2html("codebook.Rmd");
