
# Clear workspace
rm(list=ls())

# Set working directory
setwd("./Desktop/coursera/3_Getting_And_Cleaning_Data/Week_4")

# Set file path to directories
mainpath <- file.path(getwd(), "UCI HAR Dataset")
trainsetpath <- file.path(mainpath, "train")
testsetpath <- file.path(mainpath, "test")

# Read the train set
trainset <- read.delim(paste0(trainsetpath, "/X_train.txt"), colClasses = "numeric",
                       sep = "", header = FALSE) # n = 7352
# Read train set subject list
trainsetsubjects <- read.delim(paste0(trainsetpath, "/subject_train.txt"), sep = "", header = FALSE) # n = 7352
# Read train set activities
trainsetactivities <- read.delim(paste0(trainsetpath, "/y_train.txt"), sep = "", header = FALSE) # n = 7352
# Combine train set with subject list
trainset <- cbind(trainsetsubjects, trainsetactivities, trainset)

# Read the test set
testset <- read.delim(paste0(testsetpath, "/X_test.txt"), colClasses = "numeric", 
                      sep = "", header = FALSE) # n = 2947
# Read test set subject list
testsetsubjects <- read.delim(paste0(testsetpath, "/subject_test.txt"), sep = "", header = FALSE) # n = 2947
# Read test set activities
testsetactivities <- read.delim(paste0(testsetpath, "/y_test.txt"), sep = "", header = FALSE) # n = 7352
# Combine test set with subject list
testset <- cbind(testsetsubjects, testsetactivities, testset)

# Combine train and test data sets
fulldata <- rbind(trainset, testset)

# Get variable names (n = 561)
varnames <- read.delim(paste0(mainpath, "/features.txt"), sep = "", header = FALSE)
varnames <- as.vector(varnames[, 2])

# Apply descriptive variable names to data set
# (first column is the subject nr, the second column the activity, the rest are the variable names)
names(fulldata) <- c('subjectnr', 'activity', varnames)

# Find the variables that contain "mean()" or "std()" plus the subject nr and acitivy
variablestokeep <- grepl("mean[()]|std[()]|subjectnr|activity", names(fulldata))
# Keep only the defined variables
datashort <- fulldata[, variablestokeep]
# Define the activity list according to "activity_labels.txt"
datashort$activity <- factor(datashort$activity,
                             labels = c("walking", "walkingupstairs",
                                        "walkdingdownstairs", "sitting",
                                        "standing", "laying"))
# Compute the mean for all variables for each subject nr and activity 
dataaverages <- datashort %>% group_by(activity, subjectnr) %>% summarize_each(funs(mean(., na.rm=TRUE)))


