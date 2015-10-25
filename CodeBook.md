# README

As follows the instructions for running correctly the R Script

- Read the Code Book to understand the dataset transformation
- Download and unzip the dataset from <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>
- Copy run_analysis.R to the folder that contains the train and test folders

### Run the script:
- source("run_analysis.R") 
- DT<-run_analysis()

The R script creates the "independent_tidy_data.txt" file with te result of the excecution.

The main function of the Script does the following
- Reads the training and test data sets
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- Write the tidy data set into independent_tidy_data.txt
