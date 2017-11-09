require(RODBC)
require(rpart)
require(randomForest)
require(e1071)

##create a connection to the database
my_connection<- odbcDriverConnect("driver={ODBC Driver 13 for SQL Server};
                    server=applicant-testing.database.windows.net;
                    Database=AdventureWorks;
                    uid=applicant@applicant-testing;
                    pwd=jwV/=dYtLefC@BP0")


##run the query on the connection
my_data <- sqlQuery(my_connection, 
                    "SELECT *
                    FROM predictive.predict_class_assignment")

##close connection
odbcClose(my_connection)

##split data into test and train
smp_size <- floor(0.75 * nrow(my_data))

set.seed(123)
train_ind <- sample(seq_len(nrow(my_data)), size = smp_size)

train <- my_data[train_ind, ]
test <- my_data[-train_ind, ]

##create formula, I'm using all the data here
fol <- formula(class ~ att_1 + att_2 + att_3 + att_4 + att_5 + att_6 + att_7 + att_8 + att_9 + att_10 + att_11 + att_12 + att_13)

##train a decision tree model
d_tree_model <- rpart(fol, method="class", data=train)
print(d_tree_model)

##make predictions for decision tree model
d_tree_predictions <- predict(d_tree_model, test)

##get column name of highest predicted value into a dataframe
d_tree_max <- colnames(d_tree_predictions)[apply(d_tree_predictions, 1, which.max)]

##evaluate the model
d_tree_evals <- test$class == d_tree_max
d_tree_accuracy <- sum(d_tree_evals)/45
print(d_tree_accuracy)

##train random forest model
rand_model <- randomForest(y = train$class, x = train[,2:14], ntree = 10)
plot(rand_model)

##make prections
rand_predictions <- ceiling(predict(rand_model, test[,2:14]))

##evaluate the model
rand_evals <- test$class == rand_predictions
rand_accuracy <- sum(rand_evals)/45
print(rand_accuracy)

##train svm model
svm_model <- svm(y = train$class, x = train[,2:14])

##make prections
svm_predictions <- ceiling(predict(svm_model, test[,2:14]))

##evaluate the model
svm_evals <- test$class == svm_predictions
svm_accuracy <- sum(svm_evals)/45
print(svm_accuracy)

d_tree_conf_table <- table(pred=d_tree_max, test$class)
rand_conf_table <- table(pred=rand_predictions, test$class)
svm_conf_table <- table(pred=svm_predictions, test$class)

print(d_tree_conf_table)
print(rand_conf_table)
print(svm_conf_table)
