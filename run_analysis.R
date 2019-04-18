#Set directory.
#File was saved and unzipped at this directory.
setwd("~/02 Coursera/03 Getting and Cleaning Data/Programming Homework/UCI HAR Dataset")

#Cleaning R environment
rm(list=ls())

#Reading tables: features and activity labels
features <- read.table("features.txt",col.names=c("n","Feature"))
activitylabels<-read.table("activity_labels.txt",col.names=c("code","Activity"))

#Reading tables: training data
x_train<-read.table("train/X_train.txt",col.names=features[,2])
y_train<-read.table("train/y_train.txt",col.names="code")
subject_train<-read.table("train/subject_train.txt",col.names="SubjectID")

#Final training data
train<-cbind(subject_train,x_train,y_train)

#Reading tables: testing data
x_test<-read.table("test/X_test.txt",col.names=features[,2])
y_test<-read.table("test/y_test.txt",col.names="code")
subject_test<-read.table("test/subject_test.txt",col.names="SubjectID")

#Final testing data
test<-cbind(subject_test,x_test,y_test)

#Merging training and test sets in one data set: test_train
test_train<-rbind(train,test)
View(test_train)

#Extracting only the measurements on the mean and standard deviation (std)
colnames<-names(test_train)
newcolumns<-grepl("mean",colnames)|grepl("std",colnames)|grepl("SubjectID",colnames)|grepl("code",colnames)

meanstd<-test_train[,which(newcolumns)]
View(meanstd)             

#Renaming data: making parameter labels more descriptive
newnames<-names(meanstd)
newnames<-gsub("^t","Time_",newnames)
newnames<-gsub("^f","Frequency_",newnames)
newnames<-gsub("Acc","Accelerometer",newnames)
newnames<-gsub("Gyro","Gyroscope",newnames)
newnames<-gsub("Mag","Magnitude",newnames)
newnames<-gsub("mean","_Mean_",newnames)
newnames<-gsub("std","_StandardDeviation_",newnames)
newnames<-gsub("-","_",newnames)

names(meanstd)<-newnames

#Renaming data: assigning activity labels on the data
tidy1<-merge(meanstd,activitylabels,by.x="code",by.y="code",all=TRUE)
tidy2<-tidy1[c(2,82,3:80)]

#Melt and Cast Operation 
library(reshape2)

#Melting the data frame
tidy3<-melt(tidy2,id=c("SubjectID","Activity"))
View(tidy3)

#Casting the data frame: mean of each variable for each activity and each subject
TidyData<-dcast(tidy3,SubjectID + Activity ~ variable,mean,value='value')

#Final data set
View(TidyData)

#Saving as .txt file
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)
