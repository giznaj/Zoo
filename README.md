# Zoo
SVM Classification

Using SVM classification to predict 'Animal Class'.  Using svm, predict and confusionmatrix to predict and display results

## Classification with SVM

### High Level
1. Import data files (.csv) into R objects
2. Clasification / predictions
3. Compare the results
4. Visualize the results

### Low Level
* import data
* merge data
* re-order columns in dataframe
* remove uneccesary objects
* split data 60:20:20
* partition and create batches
* display for review
* remove name and class from training data
* generate sample/seed
* model with svm
* run prediction on test data
* compare actual vs prediction
* display again
* summary again and tune/fix

### Analysis
N/A

#### Notes
This project makes use of the librarys
library(caret) # Supporting model
library(dplyr) # For splitting data
library(e1071) # For SVM.  

To use the script, clone the repo and run the Zoo.R script.  Script contains relative paths so this project can be cloned in any location.