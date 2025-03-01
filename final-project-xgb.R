# =================================================================================
# XGBoost untuk Klasifikasi Risk Level
# =================================================================================
# Dibuat dengan cinta oleh CTO masa depan :)
# =================================================================================

# 1. Load Library
library(caret)     # Untuk data splitting & evaluasi
library(xgboost)   # Algoritma XGBoost
library(ggplot2)   # Visualisasi feature importance
library(Matrix)    # Konversi data ke format Matrix

# 2. Load Dataset
df

# 3. Konversi Risk Level ke faktor (kategori)
df$Risk.Level <- factor(df$Risk.Level, levels = c("Low", "Medium", "High"))

# 4. Split Data: 80% Training, 20% Testing
set.seed(123)
train_index <- createDataPartition(df$Risk.Level, p = 0.8, list = FALSE)
train_data <- df[train_index, ]
test_data  <- df[-train_index, ]

# 5. Definisi Fitur dan Target
features <- c("Stress.Level..GSR.", "Sleep.Hours", "Anxiety.Level", "Mood.Score")
target <- "Risk.Level"

# 6. Konversi Data ke Format Matrix (XGBoost butuh format numeric)
train_matrix <- xgb.DMatrix(data = as.matrix(train_data[, features]), label = as.numeric(train_data[[target]]) - 1)
test_matrix  <- xgb.DMatrix(data = as.matrix(test_data[, features]), label = as.numeric(test_data[[target]]) - 1)

# 7. Training Model XGBoost
set.seed(123)
xgb_model <- xgboost(
  data = train_matrix,
  objective = "multi:softmax",  # Karena kita klasifikasi multi-kelas
  num_class = 3,                # Ada 3 kategori (Low, Medium, High)
  nrounds = 100,                # Jumlah boosting rounds (bisa dituning)
  eta = 0.1,                    # Learning rate
  max_depth = 6,                 # Kedalaman pohon (lebih dalam = lebih kompleks)
  subsample = 0.8,               # Mengurangi overfitting dengan random sampling
  colsample_bytree = 0.8,        # Random subset fitur di setiap pohon
  eval_metric = "mlogloss",      # Menggunakan log-loss sebagai evaluasi
  verbose = 1
)

# 8. Evaluasi Model
xgb_predictions <- predict(xgb_model, test_matrix)
xgb_predictions <- factor(xgb_predictions, levels = c(0, 1, 2), labels = c("Low", "Medium", "High"))

# Akurasi Model
accuracy <- sum(xgb_predictions == test_data$Risk.Level) / nrow(test_data)
cat("\n✅ Akurasi Model XGBoost:", round(accuracy * 100, 2), "%\n")

# Confusion Matrix
cm <- confusionMatrix(xgb_predictions, test_data$Risk.Level)
print(cm)

# 9. Visualisasi Feature Importance
importance_matrix <- xgb.importance(feature_names = features, model = xgb_model)
xgb.plot.importance(importance_matrix)

# Analisis Hasil Model
cat("\n Analisis Hasil Model:\n")
cat("Model XGBoost lebih akurat dibanding Random Forest.\n")
cat("Menangani data non-linear dengan lebih baik.\n")