#First Unziping the Data Set

# Unzip dataSet to /data directory
setwd("C:\\Users\\xyz\\Downloads")
unzip(zipfile="./getdata_projectfiles_UCI HAR Dataset.zip",exdir="./data")

# lets check the zip file and the new folder that has been unzipped
list.files("./data")

#define the path where the new folder has been unziped
pathdata = file.path("./data", "UCI HAR Dataset")
#create a file which has the 28 file names
files = list.files(pathdata, recursive=TRUE)
#show the files
files

##All 28 files are listed if the Zip file is successfully unzipped


### Create the data set of training and test
#Reading training tables - xtrain / ytrain, subject train
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')

###Merging the train and test data
### 1. Merges the training and the test sets to create one data set.

mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables
setAllInOne = rbind(mrg_train, mrg_test)

### 2. Extracting only the measurements on the mean and standard deviation for each measurement
# Need step is to read all the values that are available
colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

###3. Use descriptive activity names to name the activities in the data set
setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]


### 4 & 5 Write the ouput to a text file 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
