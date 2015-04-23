library(plyr)

# Course Project for Coursera - Getting and Cleaning Data
# Name: Huy Nguyen
# Date: 23.04.2015

# Task 1. Merge the training and test sets to create one data set
###############################################################################

# Read data from files
xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
subjectTrain <- read.table("train/subject_train.txt")

xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")

# Create 'x' data set
xData <- rbind(xTrain, xTest)

# Create 'y' data set
yData <- rbind(yTrain, yTest)

# Create 'subject' data set
subjectData <- rbind(subjectTrain, subjectTest)



# Task 2. Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("features.txt")

# Subset  columns with mean() or std() in their names
meanStdFeatures <- grep("-(mean|std)\\(\\)", features[, 2])

# Subset the desired columns
xData <- xData[, meanStdFeatures]

# Correct the column names
names(xData) <- features[meanStdFeatures, 2]



# Task 3. Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("activity_labels.txt")

# update values with correct activity names
yData[, 1] <- activities[yData[, 1], 2]

# correct column name
names(yData) <- "activity"


# Task 4. Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subjectData) <- "subject"

# bind all the data in a single data set
allData <- cbind(xData, yData, subjectData)


# Task 5. Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averagesData <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averagesData, "tidydata.txt", row.name=FALSE)