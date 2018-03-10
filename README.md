# Coursera *Getting and Cleaning Data* Final Week Project - README

This project contains the following files:

* README.md
* CodeBook.md
* run_analysis.R
* tidy.txt

The main task for this assignment was to take the data collected from the study *Human Activity Recognition Using Smartphones* and tidy and manipulate it to produce a new tidy dataset that is saved to *tidy.txt*.

##About the original data

The original data folder and the data description are available from this site:
[link](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The data are contained in a zip file in the folder *UCI HAR Dataset*. For the purposes of this assignment, the data contained in the *Inertial Signals* folders were ignored as this data would have been stripped out again in the creation of the new tidy dataset.

Information about how the original data has been gathered and a description of the features can be found in their *README.txt* and *features_info.txt* from the zip file referred to above. I will refer to that information only as it pertains to the changes I've made in this assignment.

##Transforming the original dataset

The file run_analysis.R performs the transformation from the original dataset to the final tidy.txt.

These are the steps that were used to transform the data and some of the decisions I made regarding the more subjective areas of the assignment.

##Preparation
Load the *reshape2* library as in order to use *melt* and *dcast* later on.

Download and unzip the original data.

```r
library(reshape2)

# download zip file
zipFilePath <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("zipFile"))
    download.file(zipFilePath, destfile = "zipFile")
#unzip file
if (!file.exists("UCI HAR Dataset"))
    unzip("zipFile")
```
## 1. Merge the training and the test sets to create one data set.

The original data has been split into test and training data.

###Read in both the test and training data

*testData* and *trainData* are the set of processed sensor readings obtained from the accelerometer and gyroscope from the phone worn by each of the 30 subjects as they performed the activities. The different types of readings are recorded in the various features in this dataset.

*testLabels* and *trainLabels* are each a vector of numbers between 1-6 representing the activity type. The activity names that correspond to the numbers can be found in the file *activity_labels.txt* in the zip file.

*testSubjects* and *trainSubjects* are each a vector of numbers between 1-30 identifying which of the 30 people is performing the activity

```r
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read in training data"
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
```
###Combine the data into one table
First, the labels and subjects are appended as columns to their respective test or training data table. Then the test and training tables put together by appending the rows of the test data to the bottom of the training data table.

```r
trainData <- cbind(trainData, trainLabels, trainSubjects)
testData <- cbind(testData, testLabels, testSubjects)

fullData <- rbind(trainData, testData)
```
## 2. Extract only the measurements on the mean and standard deviation for each measurement.

Create a vector of column indices from the list of feature names that include either mean() or std() as part of the feature name. 

Because what exactly to include is a bit subjective, I've chosen not to include the means from the additional vectors referenced at the bottom of *features_info.txt* (e.g. gravityMean, tBodyAccMean etc.) as they a seem to be somewhat separate from the main set of features. If I were to include them, I would add '|Mean' to my grep expression. Each of the features I've selected has both mean() and a std() features associated with it.

Append the indices for the subject and activity columns as you don't want to eliminate them from the data table subset that is being created.

The data subset of features containing std() and mean() are stored in the new table *meanStdData*.

```r
featureNamesTbl <- read.table("UCI HAR Dataset/features.txt")

featureIndex <- grep('mean\\(\\)|std\\(\\)', featureNamesTbl[, 2])
featureIndex <- append(featureIndex, c(562,563))
meanStdData <- fullData[, featureIndex]
```
## 3. Use descriptive activity names to name the activities in the data set

Change the activity column to the descriptive activity names using activity_labels.txt file as reference. 

Drop column with activity numbers as they have been replaced by descriptions. (This step is not strictly speaking necessary but I found it a bit confusing as this column became column 1 after the merge and it shifted everything over by one column and confused the hell out of me.)

```r
activityLabelsTbl <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels <- as.data.frame(activityLabelsTbl[,2])

meanStdData <- merge(meanStdData, activityLabelsTbl, by.x=67, by.y=1)

# drop column with activity numbers as they have been replaced by descriptions
meanStdData <- meanStdData[,2:69]
```

##4 Appropriately label the data set with descriptive variable names.

Tidy up the names a bit. 

I don't want to do too much here as I don't want inadvertantly to change the meaning of the variable names. Also, expanding the abbreviations will make for unbelievably long column names. I've taken out the pair of parentheses after mean() and std() and lowercased the X,Y and Zs. I've chosen to leave the hyphens where they are as they separate the different parts of the feature name. I think lower-casing everything or removing hyphens and pushing everything together in camel case might make things slightly less clear. Could probably have gone either way on that one.

The feature descriptions that correspond to the column names are included in the *features.txt* file in the original data zip file.

```r
featureNames <- grep('mean\\(\\)|std\\(\\)', featureNamesTbl[, 2], value = TRUE)

featureNames <- gsub('\\(\\)', '', featureNames)

# there must be a way to do this in a single line but I haven't figured that out yet.
featureNames <- gsub('-X$', '-x', featureNames)
featureNames <- gsub('-Y$', '-y', featureNames)
featureNames <- gsub('-Z$', '-z', featureNames)

# add the column names of the 2 extra columns we've added
featureNames <- c(featureNames, "subject", "activity")

colnames(meanStdData) <- featureNames
```

## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

So here I'm melting the data so that each row has a unique id based on the combination of subject and activity. As the subject in the initial experiment performed each of the 6 activities (e.g. WALKING, SITTING, etc.) a number of times, the average of these readings for each of the subsequent features is calculated for each activity and each subject. 

The result of all this is written to file *tidy.txt*.

```r
meanStdDataMelted <- melt(meanStdData, id = c("subject", "activity"))
meanStdDataCast <- dcast(meanStdDataMelted, subject + activity ~ variable, mean)

# write the file
write.table(meanStdDataCast, file="tidy.txt", sep=" ", row.names = FALSE)
```
