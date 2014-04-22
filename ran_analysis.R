run_analysis <- function(directory) {
  library(reshape)
  wdir <- getwd()
  # Loanding necessary files for merging the dataset
  dir1 <- "train"
  dir2 <- "test"

  filetrain <- paste0(paste0(wdir,"/",directory,"/",dir1),"/X_train.txt")
  filetest <- paste0(paste0(wdir,"/",directory,"/",dir2),"/X_test.txt")
  filefeatures <- paste0(wdir,"/",directory,"/features.txt")
  fileActTrain <- paste0(paste0(wdir,"/",directory,"/",dir1),"/y_train.txt")
  fileActTest <- paste0(paste0(wdir,"/",directory,"/",dir2),"/y_test.txt")
  filesubtrain <- paste0(paste0(wdir,"/",directory,"/",dir1),"/subject_train.txt")
  filesubtest <- paste0(paste0(wdir,"/",directory,"/",dir2),"/subject_test.txt")
  train <- read.table(filetrain,header=FALSE, sep="")
  test <- read.table(filetest,header=FALSE, sep="")
  features <- read.table(filefeatures,header=FALSE, sep="")
  activitytrain <- read.table(fileActTrain,header=FALSE, sep="")
  activitytest <- read.table(fileActTest,header=FALSE, sep="")
  #Question 1
  dataset <- rbind(train,test) #merging the test and the training sets
  colnames <- features[,2] # Extracting columns name from freatures
  
  # shaping the dataset by adding columns nuames
  names(dataset)<- colnames 
  #Question 2
  # Extracting columns name containing "mean" and "std" from freatures
  colmeans <- features[which(grepl("*mean",features$V2)|grepl("*std",features$V2)),]
  colmeans <- as.vector(unlist(colmeans["V2"]))
  #Extracts only the measurements on the mean and standard deviation for each measurement.
  meansDataset <- dataset[colmeans]
  #Question 3 using descriptive activity names to name the activities in the dataset
  activityVector <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
  datasetAct <- rbind(activitytrain,activitytest)
  activityVector[c(1,2,3,4,5,6)]
  datasetAct$activity <- activityVector[datasetAct[[1]]]
 # Question 4 Appropriately labels the data set with descriptive activity names.
 # naming actvitity in dataset
  datasetNameAct <- cbind(datasetAct,dataset)
  datasetNameAct <- rename(datasetNameAct,c(V1 ="activity_ID"))

#Question 5 independent tidy data set with the average of each variable for each activity and each subject
  
  directory1 <- paste0(wdir,paste0("/",directory,"/train/Inertial Signals"))
  
  directory2 <- paste0(wdir,paste0("/",directory,"/test/Inertial Signals"))
  
  dataMeansTrain <- getFunMeans(directory1,FALSE) # call on getFunMeans() to calculer each row means from training set
  #Merging activity and subject data set
  dataMeansTest <- getFunMeans(directory2,TRUE) # call on getFunMeans() to calculer each row means from test set
  # Merging the two datasets
  datasetMeans <- rbind(dataMeansTrain ,dataMeansTest)

  #Merging activity and subject data set

  subtrain <- read.table(filesubtrain,header=FALSE, sep="")
  subtest <- read.table(filesubtest,header=FALSE, sep="")
  subjectdataset <- rbind(subtrain,subtest)
  subjectdataset <- rename(subjectdataset,c(V1 ="subject_ID"))

  datasetActSub <- cbind(subjectdataset,datasetNameAct)
  
   #Merging activity and subject data set and Means dataset
  
   datasetMeans <- cbind(datasetAct,datasetMeans)
   datasetMeans <- rename(datasetMeans,c(V1 ="activity_ID"))
   datasetMeans <- cbind(subjectdataset,datasetMeans)
  # generating datasets in csv format in the working directory
  
  write.csv2(datasetNameAct,"dataset.csv")
  write.csv2(datasetMeans,"datasetMeans.csv")

  
}
# function that calculates the means of each row for each variable
getFunMeans <- function(directory,test=FALSE) {
  library(reshape)
  
  file_list <- list.files(directory)  
  dataMeans <- do.call("cbind",lapply(file_list,
                                      FUN=function(files){
                                        colname <- as.vector(unlist(strsplit(files, ".", fixed = TRUE)))
                                        if (test == "FALSE"){
                                          colname <- paste0(sub("train","",colname[1]))
                                        }else{
                                          colname <- paste0(sub("test","",colname[1]))
                                        }
                                        colname <- paste0(colname, "Mean")
                                        vardata <- read.table(paste0(directory,"/",files),header=FALSE, sep="")
                                        tempdata <- data.frame(col=rowMeans(vardata[,-1])) 
                                        tempdata <- rename(tempdata, c(col=colname))
                                      }))
  
  return(dataMeans)
}
