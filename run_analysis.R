# load test data

subtest <- read.table("test/subject_test.txt")
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")

# load training data

subtrain <- read.table("train/subject_train.txt")
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")

# Test subjects are unique to each data set

table(subtest)
table(subtrain)

# merge testing data

test <- cbind(subtest,ytest,xtest)
train <- cbind(subtrain,ytrain,xtrain)

alldata <- rbind(test,train)

# Load Features

features <- read.table("features.txt")
features <- rbind(c(1,"Subject"),c("2","Activity"),features)
features$V1 <- c(1:nrow(features))

# Extract features which describe means and standard deviations
featuresKeep <- features[grepl(pattern = "mean|std",features$V2),]
featuresKeep <- rbind(features[1:2,],featuresKeep)

# Clean up column names
featuresKeep$V2 <- gsub("-m","M",featuresKeep$V2)
featuresKeep$V2 <- gsub("-s","S",featuresKeep$V2)
featuresKeep$V2 <- gsub("[()-]","",featuresKeep$V2)

keepcols <- featuresKeep$V1

# Extract data for columns which describe means and standrad deviations

tidydata = alldata[,keepcols]
colnames(tidydata)<-featuresKeep$V2

# Factor Activity and Subject columns
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

tidydata$Subject <- factor(tidydata$Subject)

tidydata$Activity <- factor(tidydata$Activity) 
levels(tidydata$Activity) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING", "LAYING")

library(dplyr)

# summarize data means of all variables grouped by subject and activity

tidysummary <- tidydata %>% 
  group_by(Subject,Activity) %>% 
  summarise_if(is.numeric, mean, na.rm = TRUE)

# removes temp data

rm(alldata)
rm(features,featuresKeep)
rm(subtest,xtest,ytest)
rm(subtrain,xtrain,ytrain)
rm(train,test)
rm(keepcols)

# Clean data in tidydata
# Summary of tidaydata in tidysummary

write.table(tidydata,"tidydata.txt",row.name=FALSE)
write.table(tidysummary,"tidysummary.txt",row.name=FALSE)
