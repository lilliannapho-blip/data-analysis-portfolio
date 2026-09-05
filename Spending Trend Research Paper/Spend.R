#Load libraries to run regression model
library(tidymodels)
library(tidyverse)
library(tidytext)
library(readxl)

#Create desired column names
columns <- c("year", "GDP", "PCE")

#Read the excel file with the column names
GDP <- read_xls(path = 'C:/Users/thy phan/Desktop/R LAB FILES/Table.xls', skip = 1, col_names = columns, na = ".")

#Run a linear regression model of the relationship between GDP and PCE
GDP_model <- lm(PCE ~ GDP, data=GDP)
summary(GDP_model)

#Run a log-log model to show the relationship in percent changes
log_model <- lm(log(PCE) ~ log(GDP), data = GDP)
summary(log_model)