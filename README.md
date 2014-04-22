assessment
==========

Assessment repository for Data cleaning course on Coursera.org


The R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive activity names. 
Creates a second, independent tidy data set with the average of each variable for each activity and each subject
This last part is handle by a function within the sript called getFunMeans()

Tu run the sript, unzip the raw data folder into your working directory and call it in the R cammand line passing the forlder name as parameter. for instance: ran_analysis("UCI HAR Dataset") will generate two tidy datasets in your working directory in txt format called dataset.txt and datsetmeans.txt
