###Reading the files from the local directory
###Note: Download the zip file and extract the zip file into a folder named Course Project in your current directory. Don't forget to set your current directory appropiately

###Loading x data first
data_train<-read.table("./Course Project/UCI HAR Dataset/train/X_train.txt")

data_test<-read.table("./Course Project/UCI HAR Dataset/test/X_test.txt")

###Loading y data
data_testy<-read.table("./Course Project/UCI HAR Dataset/test/y_test.txt")

data_trainy<-read.table("./Course Project/UCI HAR Dataset/train/y_train.txt")

###Loading Subject Data

subject_train<-read.table("./Course Project/UCI HAR Dataset/train/subject_train.txt")
subject_test<-read.table("./Course Project/UCI HAR Dataset/test/subject_test.txt")

###Loading the y and Subject data into the datasets 

data_test$label<-data_testy[,1]

data_train$label<-data_trainy[,1]

data_train$Subject<-subject_train[,1]

data_test$Subject<-subject_test[,1]

###Converting to tbl 

library(dplyr)
library(plyr)


data_test<-tbl_df(data_test)

data_train<-tbl_df(data_train)

#Note that for rbind the variables of both the data sets should be same and the rownames unique and different

data_final<-rbind(data_test,data_train)


#Applying the sapply function for getting mean and standard deviation of each column
measurements<-rbind(sapply(data_final,mean),sapply(data_final,sd))

measurements<-tbl_df(measurements)

rownames(measurements)<-c("mean","standard deviation")

#Reading the Corresponding Activity Names from the file to match to labels.
activity_names<-read.table("./Course Project/UCI HAR Dataset/activity_labels.txt")

#Labeling all the observations with respect to the respective activity

###Note: We did not convert to character so that the levels remain preserved and we can easily carry out the step 5 of the course project.

data_final$label<-sapply(data_final$label,function(x){activity_names$V2[match(x,activity_names$V1)]})


###Using summarise_all for getting mean for each of the activities grouped according to the per activity per person.


data_final<-group_by(data_final,Subject,label)

tidydata<-summarise_all(data_final,mean)

write.table(tidydata,dest="./Course Project/UCI HAR Dataset/Coursera Project.txt")
