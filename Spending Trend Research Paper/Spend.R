library(tidymodels)
library(tidyverse)
library(tidytext)
library(readxl)
columns <- c("year", "GDP", "PCE")

GDP <- read_xls(path = 'C:/Users/thy phan/Desktop/R LAB FILES/Table.xls', skip = 1, col_names = columns, na = ".")

GDP_model <- lm(PCE ~ GDP, data=GDP)
summary(GDP_model)


log_model <- lm(log(PCE) ~ log(GDP), data = GDP)
summary(log_model)