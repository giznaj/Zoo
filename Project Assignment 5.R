# ==========================================#
# SVM Classification for animal class types #
# Project Assignment #5                     #
#===========================================#

#Libraries
library(caret) # Supporting model
library(dplyr) # For splitting data
library(e1071) # For SVM

# Set working directory as needed.
setwd('E:/workspaces/r projects/Zoo/Zoo')

# do not set factoring on string columns.  Explicitly set later on
class.data <- read.csv("class.csv", header=T, sep=",", stringsAsFactors=F)
raw.data <- read.csv("zoo.csv", header=T, sep=",", stringsAsFactors=F)

# class_type is output prediction variable (factor categoricial variable)
# this merges the class_name column/variable into the dataset
colnames(class.data) <- c("class_type", "no_of_animal_species_in_class", "class_name", "animal_name")
class.data <- select(class.data, class_type, class_name)
raw.data$class_type <- as.factor(raw.data$class_type)
zoo.data <- merge(x = raw.data, y = class.data, by = "class_type", all.x = TRUE)

## reorder zoo.data columns and put 'class type' beside 'class name' ##
zoo.data <- zoo.data[c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1,19)]
## done column re-order ##

# remove uneccesary objects
rm(raw.data, class.data)

# Start unit demo #
#intraining <- createDataPartition(y=zoo.data$class_type, p=0.75, list=F)
#train.batch <- zoo.data[intraining,]
#test.batch <- zoo.data[-intraining,]
# End unit demo #

# Aaron - Split data @ 60:20:20 and ensure ratio integrity
trainingdata <- createDataPartition(y=zoo.data$class_type, p=0.6, list=F)
train.batch <- zoo.data[trainingdata,]
test.validate.batch <-zoo.data[-trainingdata,]

testing.validation <- createDataPartition(y=test.validate.batch$class_type, p=0.5, list=F)
test.batch <- test.validate.batch[testing.validation,]
validate.batch <- test.validate.batch[-testing.validation,]
# Aaron #

## Warning message ##
# the test & validate data sets do not have some class_types #
# you can see this 'table' commands below

# display each batch
cat("----- Training batch -----")
table(train.batch$class_type)

cat("----- Testing batch -----")
table(test.batch$class_type)

cat("----- Validation batch -----")
table(validate.batch$class_type)

# counts for each batch
nrow(train.batch); nrow(test.batch); 
nrow(validate.batch)

# remove animal_name and class_name from training dataset
train.batch <- select(train.batch, -animal_name, -class_name) 
# remove class_type
train.x <- select(train.batch, -class_type)
# 
train.y <- train.batch$class_type
summary(train.y)
set.seed(501)

# stand svm model for output variable 'class_type'
svm.model <- svm(class_type ~ ., data=train.batch, kernel = "radial")
summary(svm.model)
# data used for testing model
test.x <- select(test.batch, -class_type, -animal_name, -class_name)
# data to predict
test.y <- test.batch$class_type
table(test.y)
# prediction using test data
test.pred <- predict(svm.model, test.x)
# compare actual observation of class_type in test.y compared to prediction output (test.pred) using text.x input
confusionMatrix(test.pred, test.y)
# display again
misClassifiError = mean(test.pred != test.y)
print(paste('Accuracy', 1 - misClassifiError))

# tuning - experimental
tune.fix <- tune(svm, class_type~., data = train.batch, 
            ranges = list(gamma = 2^(-1:1), cost = 2^(2:4)),
            tunecontrol = tune.control(sampling = "fix")
)

summary(tune.fix)

# model after fixing (add parameters from output of summary(tune.fix)
svm.tuned.model <- svm(class_type ~ ., data=train.batch, kernel = "radial", cost=4, gamma=0.5)
summary(svm.tuned.model)

# tuned prediction
tuned.pred <- predict(svm.tuned.model, test.x)

# compare before and after
cat("----- Confusion Matrix TEST -----")
confusionMatrix(test.pred, test.y)
cat("----- Confusion Matrix TUNED -----")
confusionMatrix(tuned.pred, test.y)

