# so I can use melt and decast later
library(reshape2)

# download zip file
zipFilePath <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("zipFile"))
    download.file(zipFilePath, destfile = "zipFile")
#unzip file
if (!file.exists("UCI HAR Dataset"))
    unzip("zipFile")

# 1. Merge the training and the test sets to create one data set.

# read in test data
# testData is the test set of readings 
# testLabels is a vector of numbers between 1-6 representing the activity type
# testSubjects is a vector of numbers between 1-30 representing
#   which of the 30 people is performing the activity
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read in training data"
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Combine training data tables into one training table.
# Combine test data tables into one test table.
trainData <- cbind(trainData, trainLabels, trainSubjects)
testData <- cbind(testData, testLabels, testSubjects)

# put the test and training data together into one table by appending
# the rows of the test data to the bottom of the training data table
fullData <- rbind(trainData, testData)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
featureNamesTbl <- read.table("UCI HAR Dataset/features.txt")

# create a vector of column indices from the list of feature names
# that include either mean() or std(). See the ReadMe for more information
# on the decisions I've made here.
featureIndex <- grep('mean\\(\\)|std\\(\\)', featureNamesTbl[, 2])
featureIndex <- append(featureIndex, c(562,563))
meanStdData <- fullData[, featureIndex]

# 3. Use descriptive activity names to name the activities in the data set
# Change the activity column to the descriptive activity names using
# activity_labels.txt file as reference.
activityLabelsTbl <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels <- as.data.frame(activityLabelsTbl[,2])

meanStdData <- merge(meanStdData, activityLabelsTbl, by.x=67, by.y=1)
# drop column with activity numbers as they have been replaced by descriptions
meanStdData <- meanStdData[,2:69]


#4 Appropriately label the data set with descriptive variable names.

# Replace default column names with feature descriptions from features.txt
featureNames <- grep('mean\\(\\)|std\\(\\)', featureNamesTbl[, 2], value = TRUE)

# I'm going to tidy up the names a bit. Don't want to do too much here
# as I don't want to change the meaning of the variable names and expanding
# the abbreviations will make for unbelievably long column names. 
# I'll take out the pair of parentheses for good measure, lowercase the X,Y and Zs 
# and leave it at that. I think lower-casing everything might make things slightly
# less clear.
featureNames <- gsub('\\(\\)', '', featureNames)
featureNames <- gsub('-X$', '-x', featureNames)
featureNames <- gsub('-Y$', '-y', featureNames)
featureNames <- gsub('-Z$', '-z', featureNames)

# add the column names of the 2 extra columns we've added
featureNames <- c(featureNames, "subject", "activity")

colnames(meanStdData) <- featureNames

# 5. Creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.

meanStdDataMelted <- melt(meanStdData, id = c("subject", "activity"))
meanStdDataCast <- dcast(meanStdDataMelted, subject + activity ~ variable, mean)

# write the file
write.table(meanStdDataCast, file="tidy.txt", sep=" ", row.names = FALSE)



