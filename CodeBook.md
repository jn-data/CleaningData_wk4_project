# CodeBook for the "Getting and Cleaning Data" Week 4 final peer-reviewed project

## Source Data

The source data was provided at the following [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

The below reference pertains to this source data:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Please consult the README.txt and features_info.txt files provided with the dataset for the experimental details, measurements and the original mathematical processing carried out. 


## Description of the data processing carried out

The test data is provided in piece-meal manner. So the first step of the data processing is to correctly align and combine all the data together into one data set.

The provided files are comprised of the data files and some auxiliary data files (holding variable names and activity key-value pairs). 

The data set itself is comprised of the subject ID, the activity ID and 561 measured variables. The subject ID values, the activity ID values and the 561 measured variables are each stored in separate files (prefixed with subject, y & x respectively).
The dataset has then been further (randomly) partitioned into a 'test' set and a 'train' set. The partitioning here means that the observations have been divided into two sets but there's been no change to the column (variable) order. I refer to each of these sets of datta as datapools and will reference as such from now on.

It is assumed that the three component files (subject, y, x) have the exact same order of observations (otherwise impossible to reconcile) and that the columns have the exact same configuration/order in both the train and test datapools. Note: the total number of observations and columns has been confirmed to match for each file within the test and train data files.

The auxilliary data files are the activity_labels.txt and features.txt file. The features.txt file holds the list of the 561 variable names and the activity_labels.txt file has a two column table that has the mapping of each of 6 activity names to the activity IDs used in the dataset.

### Reading in the data

Each file is loaded into r using either the read.table function or the read.delim2 functions. Specifically x files holding the 561 variable observations were the ones that were better served with the read.delim2 function. In each case teh following arguments were used:
* header = FALSE - no headers in these files to interpret.
* blank.lines.skip = TRUE   - used to ignore blank lines at the end (and any others appearing).
* col.names = \<appropriate string vector\> - to give meaningful names to each column.
* sep = " " - all files except for the x ones.


Additionally/instead for the x files (containing the 561 variables of measurement data) the following arguments were used:
* sep = "" - uses white space as the delimiter to account for multiple spaces in certain parts.
* encoding = UTF-8 - to account for specific encoding of these data files.
* strip.white = TRUE            - removes excess white space.
* dec = "."       - prevents teh default of using "," as the decimal point.
* colclasses = (a vector of the string numeric repeated 561 times).
* colnames = (a vector formed from the loading of the 561 elements of features.txt file into a vector)

The output of reading in the data as above was 6 variables described by the regex pattern (test|train)(subject|activity|data).
Here the test/train prefix details the datapoool source and the suffixes refer to the following data variables:
* -subject - SubjectID.
* -activity - ActivityID.
* -data - the 561 variables names in the features.txt file.

#  Combining datasets

For each datapool (test| train) the cbind command was used to combine into one dataframe along with an additonal "datapool" column.
The output then for each datapool is a data frame with the following variables:
"SubjectID","datapool", "ActivityID", <561 variables from features.txt file ...>

The test and train datasets were then joined using the rbind command to form one continuous set of observation records in the dataframe, rawdata.

# Extracting mean and standard deviation measurements

This rawdata data frame is then subsetted using grep with the regex pattern string: ".\*(mean[^Ff]|std).\*".
The output is assigned to the procdata data frame and selects only the mean (not meanfrequency) and standard deviation measurements.
This reduces the number of measurement variables down to 66.

This data frame is then merged with the activitymap dataframe (from the activity_labels.txt file) to provide an AcivityName column that has the activity name string for each observation. 

Subsetting is then further used to rearrange the columns. The variables are then (in order):

 "datapool","SubjectID", "ActivityName","ActivityID",\< 66 measurement variables\>

The variable names are then cleaned up to remove extraneous periods (.), "" is removed from all and mean and std have their first letter Capitalised. Additionally the measurement variable names are re-ordered so that mean or std is then a suffix for each variable name for consistency.

## Final tidy data output format

In producing the final tidy data the dplyr package is used to drop the ActivityID and datapool columns and then it is grouped by SubjectID and ActivityName and then summarised using the mean function on all the measurement variables.


The Final output variables/ column names are then:

"SubjectID", "ActivityName",\< 66 measurement variables as detailed below\>

The 66 measurement variables are then formatted as:
* Initial letter is either t for time-series data or f frequency domain data (from processing with the Fast Fourier Transform).
* Names with Acc are generated from Accelerometer readings.
* Names with Gravity in them are from the Gravity component of the Accelerometer readings whereas other Acc variables (without the Gravity term) are based on the body component of the Acceleerometer data.
* X,Y,Z in the name denotes the x,y,z axial components of the relevant Accelerometer or Gyroscope readings.
* Jerk in the name denotes calculated Jerk values based on derived linear acceleration and angular velocity.
* Mag inthe name denotes computed magnitude based on a Euclidean norm.
* Mean/Std in the suffix denotes either the mean or standard deviation measurement taken from the original experiment.
* For each measurement (mean or standard deviation) the final output is again averaged by subject ID and activity. I.e. each measurement is either the mean of a mean measure or the mean of standard deviation measure.
The full list of column names is shown below and in the order that they appear in the written file.

"SubjectID"          
"ActivityName"       
"tAccXMean"          
"tAccYMean"          
"tAccZMean"          
"tAccXStd"          
"tAccYStd"           
"tAccZStd"           
"tGravityAccXMean"   
"tGravityAccYMean"   
"tGravityAccZMean"   
"tGravityAccXStd"   
"tGravityAccYStd"    
"tGravityAccZStd"    
"tAccJerkXMean"      
"tAccJerkYMean"      
"tAccJerkZMean"      
"tAccJerkXStd"      
"tAccJerkYStd"       
"tAccJerkZStd"       
"tGyroXMean"         
"tGyroYMean"         
"tGyroZMean"         
"tGyroXStd"         
"tGyroYStd"          
"tGyroZStd"          
"tGyroJerkXMean"     
"tGyroJerkYMean"     
"tGyroJerkZMean"     
"tGyroJerkXStd"     
"tGyroJerkYStd"      
"tGyroJerkZStd"      
"tAccMagMean"        
"tAccMagStd"         
"tGravityAccMagMean" 
"tGravityAccMagStd" 
"tAccJerkMagMean"    
"tAccJerkMagStd"     
"tGyroMagMean"       
"tGyroMagStd"        
"tGyroJerkMagMean"   
"tGyroJerkMagStd"   
"fAccXMean"          
"fAccYMean"          
"fAccZMean"          
"fAccXStd"           
"fAccYStd"           
"fAccZStd"          
"fAccJerkXMean"      
"fAccJerkYMean"      
"fAccJerkZMean"      
"fAccJerkXStd"       
"fAccJerkYStd"       
"fAccJerkZStd"      
"fGyroXMean"         
"fGyroYMean"         
"fGyroZMean"         
"fGyroXStd"          
"fGyroYStd"          
"fGyroZStd"         
"fAccMagMean"        
"fAccMagStd"         
"fAccJerkMagMean"    
"fAccJerkMagStd"     
"fGyroMagMean"       
"fGyroMagStd"       
"fGyroJerkMagMean"   
"fGyroJerkMagStd"  