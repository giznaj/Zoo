# Load the data from the csv file
library (rstudioapi)
library(e1071)


# Get the cuurent working directory of the running script
WD = dirname(rstudioapi::getSourceEditorContext()$path)
if (!is.null(WD)) setwd(WD)

data <- read.csv("regression_data.csv", header = TRUE)

# Plot the data
plot(data, pch=16)

# Create a linear regression model
model <- lm(Y ~ X, data)

# Add the fitted line
abline(model)


data <- read.csv("regression_data.csv", header = TRUE)

plot(data, pch=16)
model <- lm(Y ~ X , data)

# make a prediction for each X
predictedY <- predict(model, data)

# display the predictions
points(data$X, predictedY, col = "blue", pch=4)


rmse <- function(error)
{
  sqrt(mean(error^2))
}

error <- model$residuals  # same as data$Y - predictedY
predictionRMSE <- rmse(error) 



model <- svm(Y ~ X , data)

predictedY <- predict(model, data)

points(data$X, predictedY, col = "red", pch=4)


# /!\ this time  svrModel$residuals  is not the same as data$Y - predictedY
# so we compute the error like this
error <- data$Y - predictedY
svrPredictionRMSE <- rmse(error)  

