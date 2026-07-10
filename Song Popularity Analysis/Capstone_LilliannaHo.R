#linear model

path <- "C:/Users/thy phan/Desktop/R LAB FILES/train.csv"
song_data <- read.csv(path) %>% 
  as_tibble()

clean_data <- subset(song_data, select = -c(valence, liveness, acousticness))



Q1_d <- quantile(clean_data$danceability, 0.25)
Q3_d <- quantile(clean_data$danceability, 0.75)
IQR_d <- Q3_d - Q1_d
lower_d <- Q1_d - 1.5 * IQR_d
upper_d <- Q3_d + 1.5 * IQR_d  # corrected: use `+`, not another `-`

# Tempo bounds
Q1_t <- quantile(clean_data$tempo, 0.25)
Q3_t <- quantile(clean_data$tempo, 0.75)
IQR_t <- Q3_t - Q1_t
lower_t <- Q1_t - 1.5 * IQR_t
upper_t <- Q3_t + 1.5 * IQR_t








# Filtered data
filtered_data <- clean_data %>%
  filter(
    danceability >= lower_d & danceability <= upper_d,
    tempo >= lower_t & tempo <= upper_t
  )






#transforming data 
newduration <- log10(filtered_data$duration_ms)
hist(newduration)
hist(filtered_data$duration_ms)

max_energy <- max(filtered_data$energy)
newenergy <- sqrt(max_energy - filtered_data$energy)
hist(newenergy)
hist(filtered_data$energy)

max_loudness <- max(filtered_data$loudness)
newloudness <- log10(max_loudness - filtered_data$loudness)
hist(newloudness)

newspeechiness <- 1/(filtered_data$speechiness)
hist(newspeechiness)
hist(filtered_data$speechiness)





hist(filtered_data$danceability)

hist(filtered_data$speechiness)





transformed_data <- filtered_data %>%
  mutate(
    newduration = log10(duration_ms),
    newenergy = sqrt(max_energy - energy),
    newloudness = log10(max_loudness - loudness),
    newspeechiness = 1 / speechiness
  )



clean_data1 <- transformed_data[
  is.finite(transformed_data$newspeechiness) &
    is.finite(transformed_data$newduration) &
    is.finite(transformed_data$newloudness), 
]



explicitT <- subset(clean_data1, explicit == "True")
explicitF <- subset(clean_data1, explicit == "False")

#linear model for explicit:true
model <- lm(popularity ~ newloudness+  newspeechiness  +  newenergy+
           newduration  +track_genre  , data = explicitT)
summary(model)

res <- residuals(model)

qqnorm(res)
qqline(res, col="red")



#Linear Model for Explicit:False

model2 <- lm(popularity ~  newloudness+ newspeechiness + newenergy 
             + newduration + danceability + tempo + track_genre
             , data = explicitF)
summary(model2)

res2 <- residuals(model2)

qqnorm(res2)
qqline(res2, col="red")


leverage <- hatvalues(model)
which(abs(stud_res) > 3 & leverage < 2*mean(leverage))

stud_res <- rstudent(model)
which(abs(stud_res) > 3)
plot(stud_res, 
     ylab = "Studentized Residuals", 
     xlab = "Observation Index", 
     main = "Studentized Residuals Plot")
abline(h = c(-3, 0, 3), col = c("red", "blue", "red"), lty = 2)

hist(stud_res, breaks = 30, main = "Histogram of Studentized Residuals",
     xlab = "Studentized Residuals")





cooksd <- cooks.distance(model)
plot(cooksd, pch = 16)

# Influence threshold
which(cooksd > 4 / length(cooksd))


head(sort(cooksd, decreasing = TRUE), 20)



stud_res2 <- rstudent(model2)
which(abs(stud_res2) > 3)

cooksd2 <- cooks.distance(model2)
plot(cooksd, pch = 16)

# Influence threshold
which(cooksd > 4 / length(cooksd2))


head(sort(cooksd2, decreasing = TRUE), 20)






# Random Forest Model 


install.packages("randomForest")
library(randomForest)
install.packages("ranger")
suppressPackageStartupMessages({
  library(tidyverse)
  library(car)
  library(ranger)
})
          



set.seed(123)
train_index <- sample(1:nrow(explicitF), 0.7*nrow(explicitF))
train <- explicitF[train_index, ]
test  <- explicitF[-train_index, ]

rf_model <- ranger(
  popularity ~ newduration + danceability + newspeechiness +newenergy+ tempo+ newloudness+ track_genre, 
  data = train,
  num.trees = 500,
  mtry = 3,
  importance = "impurity"
)




rf_pred <- predict(rf_model, data = test)$predictions


rmse_value <- Metrics::rmse(test$popularity, rf_pred)
rmse_value

r2_value <- 1 - sum((test$popularity - rf_pred)^2) / sum((test$popularity - mean(test$popularity))^2)
r2_value




#random forest model for 2nd dataset

set.seed(123)
train_index2 <- sample(1:nrow(explicitT), 0.7*nrow(explicitT))
train2 <- explicitT[train_index2, ]
test2  <- explicitT[-train_index2, ]

rf_model2 <- ranger(
  popularity ~ newduration + danceability + newspeechiness +newenergy+ tempo+ newloudness+ track_genre, 
  data = train2,
  num.trees = 500,
  mtry = 3,
  importance = "impurity"
)

rf_model2
rf_pred2 <- predict(rf_model2, data = test2)$predictions


rmse_value2 <- Metrics::rmse(test2$popularity, rf_pred2)
rmse_value2

r2_value2 <- 1 - sum((test2$popularity - rf_pred2)^2) / sum((test2$popularity - mean(test2$popularity))^2)
r2_value2

mae <- mean(abs(rf_pred2 - test2$popularity))
mae


library(ggplot2)
importance_df <- data.frame(
  Feature = names(rf_model$variable.importance),
  Importance = rf_model$variable.importance
)

ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_col() + coord_flip() + theme_minimal()+
  labs(title = "Variable Importance")




library(ggplot2)
importance_df <- data.frame(
  Feature = names(rf_model2$variable.importance),
  Importance = rf_model2$variable.importance
)

ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_col() + coord_flip() + theme_minimal()+
  labs(title = "Variable Importance")


ggplot(data = data.frame(
  Observed = test2$popularity,
  Predicted = rf_pred2
), aes(x = Observed, y = Predicted)) +
  geom_point(color = "steelblue", alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  theme_minimal() +
  labs(title = "Predicted vs Observed",
       x = "Observed Popularity",
       y = "Predicted Popularity")







install.packages("lightgbm", repos = "https://cran.r-project.org")
library(lightgbm)

#set x and y
x <- explicitF[, c("newduration", "newloudness", "danceability", "newspeechiness", 
               "newenergy", "tempo", "track_genre")]
y <- explicitF$popularity

x <- data.matrix(x)

#train/test model
set.seed(123)
train_idx <- sample(1:nrow(x), size = 0.8 * nrow(x))

x_train <- x[train_idx, ]
y_train <- y[train_idx]

x_test  <- x[-train_idx, ]
y_test  <- y[-train_idx]

#convert to lightgbm dataset

lgb_train <- lgb.Dataset(data = x_train, label = y_train)
lgb_test  <- lgb.Dataset(data = x_test,  label = y_test)

#set parameters

params <- list(
  objective = "regression",
  metric = "rmse",
  boosting = "gbdt",
  learning_rate = 0.05,
  num_leaves = 64,
  feature_fraction = 0.9,
  bagging_fraction = 0.8,
  bagging_freq = 5
)


params$num_leaves <- 64
params$max_depth <- -1
params$min_data_in_leaf <- 20
params$learning_rate <- 0.03

#train model
lgbmodel <- lgb.train(
  params = params,
  data = lgb_train,
  nrounds = 1000,
  valids = list(test = lgb_test),
  early_stopping_rounds = 50
)

lgbmodel


#make predictions
lgbpred <- predict(lgbmodel, x_test)
rmselg <- sqrt(mean((y_test - lgbpred)^2))
rmselg

sselg <- sum((y_test - lgbpred)^2)
sstlg <- sum((y_test - mean(y_test))^2)
rsqlg <- 1 - sselg/sstlg
rsqlg

#most important factors

importance <- lgb.importance(lgbmodel, percentage = TRUE)
lgb.plot.importance(importance, top_n = 20)





#for true
x2 <- explicitT[, c("newduration", "newloudness", "danceability", "newspeechiness", 
                   "newenergy", "tempo", "track_genre")]
y2 <- explicitT$popularity

x2 <- data.matrix(x2)

#train/test model
set.seed(123)
train_idx2 <- sample(1:nrow(x2), size = 0.8 * nrow(x2))

x_train2 <- x2[train_idx2, ]
y_train2 <- y2[train_idx2]

x_test2  <- x2[-train_idx2, ]
y_test2  <- y2[-train_idx2]

#convert to lightgbm dataset

lgb_train2 <- lgb.Dataset(data = x_train2, label = y_train2)
lgb_test2  <- lgb.Dataset(data = x_test2,  label = y_test2)

#set parameters

params <- list(
  objective = "regression",
  metric = "rmse",
  boosting = "gbdt",
  learning_rate = 0.05,
  num_leaves = 64,
  feature_fraction = 0.9,
  bagging_fraction = 0.8,
  bagging_freq = 5
)


params$num_leaves <- 64
params$max_depth <- -1
params$min_data_in_leaf <- 20
params$learning_rate <- 0.03

#train model
lgbmodel2 <- lgb.train(
  params = params,
  data = lgb_train2,
  nrounds = 1000,
  valids = list(test = lgb_test2),
  early_stopping_rounds = 50
)

lgbmodel2
lgb.plot.tree(model = lgbmodel2, tree_index = 0)

pred <- predict(lgbmodel2, data = x_test2)
plot(y_test2, pred)
abline(a=0, b=1, col="red")

#make predictions
lgbpred2 <- predict(lgbmodel2, x_test2)
rmselg2 <- sqrt(mean((y_test2 - lgbpred2)^2))
rmselg2

sselg2 <- sum((y_test2 - lgbpred2)^2)
sstlg2 <- sum((y_test2 - mean(y_test2))^2)
rsqlg2 <- 1 - sselg2/sstlg2
rsqlg2

#most important factors

importance2 <- lgb.importance(lgbmodel2, percentage = TRUE)
lgb.plot.importance(importance2, top_n = 20)



