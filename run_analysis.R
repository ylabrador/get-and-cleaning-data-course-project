#################################################
# principal function
run_analysis <- function() {
        data <- marge_train_test()
        reduce_data <- extract_columns(data)
        activity_data <- changes_activities_name(reduce_data)
        data_with_names <- changes_variable_name(activity_data)
        independent_tidy_data <- average_data(data_with_names)
        
        # write tidy data
        write.table(independent_tidy_data, file = "independent_tidy_data.txt", row.name=FALSE)
        
        # return tidy data
        independent_tidy_data
}

#################################################
#  Creates a second, independent tidy data set with the average of each variable for each activity and each subject
average_data <- function(data) {
        library(plyr);
        
        average_data_variable <- aggregate(. ~subject + activity_name, data, mean)
        average_data_variable <- average_data_variable[order(average_data_variable$subject,average_data_variable$activity_name),]
        average_data_variable
}

#################################################
# Appropriately labels the data set with descriptive variable names. 
changes_variable_name <- function(data) {
        library(stringr)
        
        # replace column names with descriptive names
        names(data) <- str_replace_all(names(data), "^f", "frecuency")
        names(data) <- str_replace_all(names(data), "^t", "time")
        names(data) <- str_replace_all(names(data), "BodyBody", "Body")
        names(data) <- str_replace_all(names(data), "-", "_")
        names(data) <- str_replace_all(names(data), "Acc", "Accelerometer")
        names(data) <- str_replace_all(names(data), "Gyro", "Gyroscope")
        names(data) <- str_replace_all(names(data), "Mag", "Magnitude")
        data
}

#################################################
# Uses descriptive activity names to name the activities in the data set
changes_activities_name <- function(data) {
        # read axtivities names
        activity <- read.table("activity_labels.txt")
        names(activity) <- c("activity-index", "activity-name")
        
        # merge the data to include activity name in it
        data2 <- merge(data, activity, by.x ="activity-index", by.y = "activity-index")
        # remove id activity column
        data2[,-c(1)]
}

#################################################
# Extracts only the measurements on the mean and standard deviation for each measurement.
extract_columns <- function(data) {
        # Load the measurements names
        c <- read.table("features.txt")
        # Select only the measurements on the mean and standard deviation
        index <- c$V1[which(grepl("mean", c$V2) | grepl("std", c$V2))]
        column_names <- c$V2[index]
        
        # Add index for subject and activity variables
        index <- index +2
        index[length(index)+1] <- 1
        index[length(index)+1] <- 2
        
        # create a vector with the column names
        column_names <- as.character(column_names)
        column_names[length(column_names)+1] <- "subject"
        column_names[length(column_names)+1] <- "activity-index"
        
        # select only the columns presents in index
        new_data <- data[,index]
        # set column names
        names(new_data) <- column_names
        new_data
}

#################################################
#  Reads the training and test data sets
marge_train_test <- function () {
        #  Reads the training data set
        train_data <- marge_files("./train/", "subject_train.txt" , "X_train.txt", "y_train.txt");
        #  Reads the test data sets
        test_data <- marge_files("./test/", "subject_test.txt", "X_test.txt", "y_test.txt");
        # Merges the training and the test sets to create one data set
        rbind(train_data, test_data)
}

marge_files <- function (file_dir, subject_file, x_file, y_file) {
        #  Reads the data sets
        subject <- read.table(paste(file_dir, subject_file, sep = ""))
        x <- read.table(paste(file_dir, x_file, sep = ""))
        y <- read.table(paste(file_dir, y_file, sep = ""))
        
        #  create one dataframe with all data
        data <- cbind(subject, y)
        data <- cbind(data, x)
        
        data
}