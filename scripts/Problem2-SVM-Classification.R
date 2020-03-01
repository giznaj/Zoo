library(caret) # Supporting model
library(dplyr) # For splitting data
library(e1071) # For SVM



local.dir <- "E:/school/University.Guelph/8020002 - DEOL Data Mining and Machine Learning/Unit 04 Practice/Zoo/"
setwd(local.dir)

# do not set factoring on string columns.  Explicitly set later on
class.data <- read.csv("class.csv", header=T, sep=",", stringsAsFactors=F)
raw.data <- read.csv("zoo.csv", header=T, sep=",", stringsAsFactors=F)
# colnames(raw.data) <- tolower(colnames(raw.data))


# Given class_type is what we will use, let's factor this variable
colnames(class.data) <- c("class_type", "no_of_animal_species_in_class", "class_name", "animal_name")
class.data <- select(class.data, class_type, class_name)
raw.data$class_type <- as.factor(raw.data$class_type)
zoo.data <- merge(x = raw.data, y = class.data, by = "class_type", all.x = TRUE)

## reorder zoo.data columns and put 'class type' beside 'class name' ##
#zoo.data <- zoo.data[c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,1,19)]
## done column re-order ##

head(zoo.data, 5)
rm(raw.data, class.data)


# Build classification model. 
# Setting up the training (70%) and testing (30%) datasets. 

#intraining <- createDataPartition(y=zoo.data$class_type, p=0.7, list=F)
#train.batch <- zoo.data[intraining,]
#test.batch <- zoo.data[-intraining,]

# Aaron - Split data @ 60:20:20 and ensure ratio integrity
intraining <- createDataPartition(y=zoo.data$class_type, p=0.5, list=F)
train.batch <- zoo.data[intraining,]
test.validate.batch <-zoo.data[-intraining,]

testing.validation <- createDataPartition(y=test.validate.batch$class_type, p=0.5, list=F)
test.batch <- test.validate.batch[testing.validation,]
validate.batch <- test.validate.batch[-testing.validation,]
# Aaron #

cat("----- Training batch -----")
table(train.batch$class_type)

cat("----- Testing batch -----")
table(test.batch$class_type)

cat("----- Validation batch -----")
table(validate.batch$class_type)

train.batch <- select(train.batch, -animal_name, -class_name) 
train.x <- select(train.batch, -class_type)
train.y <- train.batch$class_type
set.seed(501)

# For non-linear decision boundaries to separate non linear data
# Using radial kernel support vector classifier.

svm.model <- svm(class_type ~ ., data=train.batch, kernel = "radial")
summary(svm.model)
test.x <- select(test.batch, -class_type, -animal_name, -class_name)
test.y <- test.batch$class_type
test.pred <- predict(svm.model, test.x)
confusionMatrix(test.pred, test.y)