## download and extract the zip files
temp=tempfile()
givency<-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(givency,destfile=temp)
unzip(temp,exdir=tempdir())
unlink(temp)
setwd(tempdir())

## read data
setwd("UCI HAR Dataset/")
features<-read.table("features.txt")["V2"]
activity_labels<-read.table("activity_labels.txt")["V2"]
means_or_stds<-grep("mean(+[()]{1})|std",features$V2) # columns corresponding to mean or std data 

setwd("train")
X_train<-read.table("X_train.txt")
names(X_train)<-features$V2
y_train<-read.table("y_train.txt")
names(y_train)<-"labels"
subject_train<-read.table("subject_train.txt")
names(subject_train)<-"subjects"

setwd("../test/")
X_test<-read.table("X_test.txt")
names(X_test)<-features$V2

y_test<-read.table("y_test.txt")
names(y_test)<-"labels"

subject_test<-read.table("subject_test.txt")
names(subject_test)<-"subjects"

setwd(curDir)
##easurements on mean and standard deviation for each measurement 
means_and_std<-colnames(X_test)[means_or_stds]
X_testSet<-cbind(subject_test,y_test,subset(X_test,select=means_and_std))
X_trainSet<-cbind(subject_train,y_train,subset(X_train,select=means_and_std))

## Merge the training and the test sets.
mergedSet<-rbind(X_testSet, X_trainSet)

##second dataset
##set with the average of each variable for each activity 
finalData<-aggregate(mergedSet[,3:ncol(mergedSet)],list(Subject=mergedSet$subjects, Activity=mergedSet$labels), mean)
finalData<-finalData[order(finalData$Subject),]


finalData$Activity<-activity_labels[finalData$Activity,]
write.table(finalData, file="./finalizeData.txt", sep="\t", row.names=FALSE)

