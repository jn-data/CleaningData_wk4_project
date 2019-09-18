# Note this script asssumes the working directory is the same as the location of the zipped data file and that the zip file has not yet been extracted.

# Unzip the data

unzip("./getdata_projectfiles_UCI HAR Dataset.zip")

setwd("./UCI HAR Dataset")

## 1. Merges the training and the test sets to create one data set.

# Load parameter mapping data frames:

activitymap <- read.table("./activity_labels.txt", header = FALSE, sep = " ", col.names = c("ActivityID", "ActivityName"), blank.lines.skip = TRUE)

featuresmap <- read.table("./features.txt", header = FALSE, sep = " ", col.names = c("FeatureID", "FeatureName"), blank.lines.skip = TRUE)

# Load test data

testactivity <- read.table("./test/y_test.txt", header = FALSE, col.names = "ActivityID", blank.lines.skip = TRUE)

testsubjects <- read.table("./test/subject_test.txt", header = FALSE, col.names = "SubjectID", blank.lines.skip = TRUE)

testdata <- read.delim2("./test/x_test.txt", header = FALSE, sep = "", blank.lines.skip = TRUE, encoding = "UTF-8", strip.white = TRUE, dec = ".",col.names = as.vector(featuresmap$FeatureName),colClasses = rep("numeric",561) )

# Combine test data into 1 dataframe with datapool column:

testpooldf <- data.frame(datapool = rep("test",dim(testdata)[1]))


testdata <- cbind(testsubjects, testpooldf,testactivity, testdata)

# Load train data


trainactivity <- read.table("./train/y_train.txt", header = FALSE, col.names = "ActivityID", blank.lines.skip = TRUE)

trainsubjects <- read.table("./train/subject_train.txt", header = FALSE, col.names = "SubjectID", blank.lines.skip = TRUE)

traindata <- read.delim2("./train/x_train.txt", header = FALSE, sep = "", blank.lines.skip = TRUE, encoding = "UTF-8", strip.white = TRUE, dec = ".",col.names = as.vector(featuresmap$FeatureName),colClasses = rep("numeric",561) )


# Combine load data into 1 dataframe with datapool column:

trainpooldf <- data.frame(datapool = rep("train",dim(traindata)[1]))


traindata <- cbind(trainsubjects, trainpooldf,trainactivity, traindata)



# Merge the train and test data sets:

rawdata <- rbind(traindata,testdata)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.


procdata <- rawdata[,c(1:3, grep(".*(mean[^Ff]|std).*",names(rawdata))) ]

# 3. Uses descriptive activity names to name the activities in the data set

procdata <- merge(x = procdata, y = activitymap, by.x = "ActivityID" )

procdata <- procdata[, c(3,2,70,1,4:69)]

# 4. Appropriately labels the data set with descriptive variable names.


names(procdata) <- gsub("\\.","",names(procdata))  # Removes periods from the column names

names(procdata) <- gsub("Body","",names(procdata) ) # Removes body from the column names to improve readability.

names(procdata) <- gsub("mean","Mean",names(procdata) ) # Capitalise mean in column name

names(procdata) <- gsub("std","Std",names(procdata) ) # Capitalise std in column name


names(procdata) <- gsub("(.*)(Std|Mean)(.?)","\\1\\3\\2", names(procdata))  # Re-order so mean/std is a suffix for consistency


rm(activitymap, featuresmap, rawdata, testactivity, testdata, testpooldf, testsubjects, trainactivity, traindata, trainpooldf, trainsubjects) # Clean up unnecsary variables

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)


outputdata <- procdata %>% select(-ActivityID, -datapool) %>% group_by(SubjectID,ActivityName) %>% summarise_all(mean)


## Writing data frame out to a txt file:


write.table(outputdata, file = "../jndata_tidy_data_out.txt",row.names = FALSE)

setwd("../")   # Reset the working directory as it was before the script was run
unlink("./UCI HAR Dataset", recursive = TRUE)        # Deletes the directory of extracted data