# =================================================================================
# Kenapa Regresi Tidak Cocok untuk Kasus Ini?
# =================================================================================
# 1. Regresi digunakan untuk memprediksi variabel numerik kontinu, sedangkan 
#    Risk Level adalah variabel kategorikal (Low, Medium, High).
#
# 2. Jika dipaksa menggunakan regresi linier, hasilnya bisa tidak interpretatif
#    karena model akan mengasumsikan hubungan linier antara variabel independen 
#    dan Risk Level, padahal Risk Level bukan angka kontinu.
#
# 3. Regresi juga menghasilkan nilai prediksi yang bisa berada di luar kategori yang ada.
#    Misalnya, model bisa memprediksi Risk Level = 1.5, padahal tidak ada kategori 
#    "setengah Medium".
#
# 4. Oleh karena itu, klasifikasi (seperti Logistic Regression) lebih tepat karena 
#    dirancang untuk memprediksi kategori, bukan angka.
#
# 5. Model yang digunakan dalam script ini adalah Logistic Regression 
#    (baik sederhana, berganda, maupun polinomial), yang cocok untuk kasus klasifikasi.
# =================================================================================

# 1. Load library
library(caret)
library(nnet)

# 2. Load dataset
df

# 3. Konversi Risk Level ke faktor (kategori)
df$Risk.Level <- factor(df$Risk.Level, levels = c("Low", "Medium", "High"))

# 4. Split data menjadi training (80%) dan testing (20%)
set.seed(123)
train_index <- createDataPartition(df$Risk.Level, p = 0.8, list = FALSE)
train_data <- df[train_index, ]
test_data <- df[-train_index, ]

# 5. Membuat tiga model klasifikasi
# Model 1: Logistic Regression (Sederhana)
model_sederhana <- multinom(Risk.Level ~ Stress.Level..GSR., data = train_data)

# Model 2: Logistic Regression (Berganda)
model_berganda <- multinom(Risk.Level ~ Stress.Level..GSR. + Sleep.Hours + Anxiety.Level + Mood.Score, data = train_data)

# Model 3: Polinomial Logistic Regression
train_data$Stress.Level.Squared <- train_data$Stress.Level..GSR. ^ 2
model_poly <- multinom(Risk.Level ~ Stress.Level..GSR. + Stress.Level.Squared, data = train_data)

# 6. Fungsi untuk menghitung akurasi model
calculate_metrics <- function(model, test_data) {
  predictions <- predict(model, newdata = test_data)
  accuracy <- sum(predictions == test_data$Risk.Level) / nrow(test_data)
  return(accuracy)
}

# 7. Evaluasi model
test_data$Stress.Level.Squared <- test_data$Stress.Level..GSR. ^ 2
accuracy_sederhana <- calculate_metrics(model_sederhana, test_data)
accuracy_berganda <- calculate_metrics(model_berganda, test_data)
accuracy_poly <- calculate_metrics(model_poly, test_data)

# 8. Membuat tabel perbandingan
comparison_table <- data.frame(
  Model = c("Logistic Sederhana", "Logistic Berganda", "Polinomial"),
  Accuracy = c(accuracy_sederhana, accuracy_berganda, accuracy_poly)
)

print(comparison_table)

# 9. Visualisasi perbandingan akurasi model
barplot(comparison_table$Accuracy, names.arg = comparison_table$Model,
        main = "Perbandingan Akurasi Model",
        col = c("skyblue", "lightgreen", "pink"), ylim = c(0, 1))
grid()

# 10. Menentukan model terbaik
best_model <- comparison_table[which.max(comparison_table$Accuracy), ]
cat("\nModel terbaik berdasarkan akurasi tertinggi:\n")
print(best_model)

# 11. Visualisasi Prediksi Model Terbaik
best_model_name <- best_model$Model
best_predictions <- if (best_model_name == "Logistic Sederhana") {
  predict(model_sederhana, newdata = test_data)
} else if (best_model_name == "Logistic Berganda") {
  predict(model_berganda, newdata = test_data)
} else {
  predict(model_poly, newdata = test_data)
}

table_actual_vs_pred <- table(Actual = test_data$Risk.Level, Predicted = best_predictions)
print(table_actual_vs_pred)

# =================================================================================
# 📊 Analisis Akurasi Model
# =================================================================================
# 1. Model paling akurat dalam memprediksi kategori "High", 
#    karena dari 1676 data asli "High", sebanyak 1290 berhasil diprediksi benar.
#
# 2. Model sering salah memprediksi "Medium" sebagai "High". 
#    Ini menunjukkan bahwa fitur yang digunakan bisa jadi kurang membedakan kelas Medium dan High.
#
# 3. Kelas "Low" sering salah diklasifikasikan sebagai "High". 
#    Mungkin karena ada kemiripan pola dalam fitur yang digunakan.
#
# 4. Cara meningkatkan akurasi model:
#    - Menambah fitur lain yang lebih membedakan antar kelas.
#    - Menggunakan balancing data (jika jumlah sample tiap kelas tidak seimbang).
#    - Menguji model lain seperti Random Forest atau SVM untuk membandingkan performa.
# =================================================================================