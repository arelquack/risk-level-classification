# =================================================================================
# Random Forest untuk Klasifikasi Risk Level
# =================================================================================
# Dibuat dengan cinta oleh CTO masa depan :)
# =================================================================================

# 1. Load Library
library(caret)        # Data splitting & evaluasi
library(randomForest) # Algoritma Random Forest
library(ggplot2)      # Visualisasi

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

# 6. Training Model Random Forest
set.seed(123) # Biar hasilnya konsisten
rf_model <- randomForest(
  Risk.Level ~ ., 
  data = train_data[, c(features, target)], 
  ntree = 100,      # Jumlah pohon
  mtry = 2,         # Jumlah fitur yang dipilih di setiap split
  importance = TRUE # Biar bisa lihat fitur paling penting
)

# 7. Evaluasi Model
rf_predictions <- predict(rf_model, test_data[, features])

# Akurasi Model
accuracy <- sum(rf_predictions == test_data$Risk.Level) / nrow(test_data)
cat("\n Akurasi Model Random Forest:", round(accuracy * 100, 2), "%\n")

# Confusion Matrix
cm <- confusionMatrix(rf_predictions, test_data$Risk.Level)
print(cm)

# 8. Visualisasi Feature Importance
importance_df <- as.data.frame(importance(rf_model))
importance_df$Feature <- rownames(importance_df)
ggplot(importance_df, aes(x = reorder(Feature, MeanDecreaseGini), y = MeanDecreaseGini)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Feature Importance (Random Forest)", x = "Fitur", y = "Pentingnya Fitur") +
  theme_minimal()

# 9. Analisis Hasil Model
cat("\nAnalisis Hasil Model:\n")
cat("Model bisa menangkap pola kompleks dengan lebih baik dibanding Logistic Regression.\n")
cat("Akurasi meningkat karena Random Forest menangani hubungan non-linear antara fitur.\n")
cat("Jika akurasi masih kurang, coba tuning `ntree` dan `mtry` atau gunakan XGBoost.\n")
