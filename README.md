# README --- Getting and Cleaning Data --- Final Peer Reviewed project

This readme file is provided to explain how the associated scripts included in this Github Repo work.
To carry out this project I've only needed to create one script which is the *run_analysis.R* script included in this repository.

## Requirements/Assumptions

The following assumptions are made/requirements must be in place before the script is run:
* You have already downloaded the zipped data file from the [link provided](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
* The zipped data file is saved in the directory that corresponds to your working directory in R/Rstudio.
* You do not need to manually extract the zippped data file before running as the script will do this. 
* The dplyr package is installed on your system.

## Purpose & Overview

The script is written to specifically process the data captured by (Anguita *et al.* - see footnote) as per the link provided in the previous section.
To use the script you only need to download the dataset as described above and set the working directory to it's location.
Using the source command to run the script will then extract the zipped data file, consolidate the data, extracting only mean and st. dev measurements and then provide averages for each variable per test subject and activity.
This data is then written to an output text file, "jndata_tidy_data_out.txt". Subsequently, the extracted data folder is deleted.

## Files provided in the repository

README.md           - This README file.
CodeBook.md         - The CodeBook describing the source data, processing carried out and format of the final output data.
run_analysis.R      - the R script used to process the source data.


## Reference:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012