library(survival)
library(survminer)  # for better plots

lung_url <- "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/survival/lung.csv"
lung <- read.csv(lung_url)
lung <- lung[ , -1]  # Remove index column
head(lung)