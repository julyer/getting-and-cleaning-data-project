# Coursera *Getting and Cleaning Data* Final Week Project - Code Book

## Data Overview
File name: *tidy.txt*  
Number of observations: 180  
Number of variables: 68

## Summary
This is the Code Book for *tidy.txt*. The original data from which this dataset was derived is here: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

*tidy.txt* takes a subset of the variables in the original dataset and calculates the average of each variable for each activity and each subject. That is to say that each subject performed each of the 6 activities (e.g. WALKING, SITTING etc.) a number of times. For each one of the subjects, the tidy data set calculates the average value of each type of reading for each of the 6 activities.

A full description of how the data has been manipulated from the original dataset is included in the README file.

## Features

**subject**  
 An integer between 1 and 30 identifying the subject performing the activity  

**activity**  
 One of the 6 activities that the subject was performing when the readings were taken
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING


The rest of the features are positive and negative decimal numbers to 15 decimal places.

Because each subject performed each activity several times, the feature columns contain the **mean** of all of the readings for each activity and each subject.

The following text is from the original Data Set Description linked above. It describes how the data collected are generated and manipulated. A subset of these readings were used to calculate the means in the tidy data set as described further down.

----------------

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
>
>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
>
>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
>
>These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
>
* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

-----------------

The set of variables that were estimated from these signals for the tidy dataset are: 

mean: Mean value  
std: Standard deviation  

For each of the above readings ending in XYZ would result in 6 features in the new tidy dataset. For example:
tBodyGyroJerk-XYZ would become:
* tBodyGyroJerk-mean-x
* tBodyGyroJerk-mean-y
* tBodyGyroJerk-mean-z
* tBodyGyroJerk-std-x
* tBodyGyroJerk-std-y
* tBodyGyroJerk-std-z

Readings that don't end in XYZ would result in 2 features. 
For example *fBodyGyroJerkMag* would become:
* fBodyGyroJerkMag-mean
* fBodyGyroJerkMag-std

For more information on the feature selection and variable name changes, please see the README file.
