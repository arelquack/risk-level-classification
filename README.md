# 🎯 Risk Level Classification

## 📌 Deskripsi Proyek  
Proyek ini bertujuan untuk membangun **model klasifikasi machine learning** yang dapat **memprediksi tingkat risiko (Risk Level) mahasiswa** berdasarkan beberapa faktor kesejahteraan mental mereka.  

Model ini menggunakan dataset yang berisi informasi tentang:  
- **📊 Stress Level (GSR)** → Mengukur tingkat stres menggunakan sensor GSR.  
- **💤 Sleep Hours** → Jumlah jam tidur setiap hari.  
- **😟 Anxiety Level** → Tingkat kecemasan berdasarkan skala tertentu.  
- **😊 Mood Score** → Skor suasana hati sebagai indikator kesejahteraan mental.  

Hasil klasifikasi akan menentukan apakah mahasiswa masuk dalam kategori:  
✅ **Low (Risiko Rendah)**  
⚠️ **Medium (Risiko Sedang)**  
🚨 **High (Risiko Tinggi)**  

---

## 🔬 Metode yang Digunakan  
Proyek ini menerapkan dan membandingkan **tiga model klasifikasi** untuk menemukan solusi terbaik:

| Model                  | Akurasi (%) | Keunggulan | Kekurangan |
|------------------------|------------|------------|------------|
| **Logistic Regression** | **~64.15%** | Simpel, cepat, mudah diinterpretasi | Kurang mampu menangkap pola non-linear |
| **Random Forest**       | **73.42%** | Lebih akurat, menangkap pola kompleks | Bisa lambat, butuh tuning |
| **XGBoost**            | **75-78%** | Akurasi tertinggi, paling optimal | Butuh tuning hyperparameter |

🛠️ **Logistic Regression** digunakan sebagai baseline model.  
🌲 **Random Forest** menawarkan akurasi lebih baik dengan menangkap pola lebih kompleks.  
🚀 **XGBoost menjadi model terbaik**, dengan akurasi **75-78%**, mengungguli model lainnya.  

---

## ⚙️ Cara Menjalankan Proyek  
1️⃣ **Clone repository ini:**  
   ```bash
   git clone https://github.com/username/risk-level-classification.git
   cd risk-level-classification
   ```

2️⃣ **Pastikan semua dependensi sudah terinstall:**  
   ```r
   install.packages(c("caret", "randomForest", "xgboost", "ggplot2", "nnet"))
   ```

3️⃣ **Jalankan model yang diinginkan:**  

4️⃣ **Lihat hasil evaluasi dan bandingkan performa model.**  

---

## 📈 Hasil dan Insight  
🔍 **Hasil evaluasi menunjukkan bahwa model XGBoost memberikan performa terbaik**, dengan **akurasi 75-78%**.  
📊 **Fitur yang paling berpengaruh:**  
1. **Stress Level (GSR)** → Faktor utama dalam menentukan risiko.  
2. **Anxiety Level** → Sangat berkontribusi dalam membedakan kategori **Medium dan High**.  
3. **Mood Score** → Indikator penting dalam kesejahteraan mental.  
4. **Sleep Hours** → Berpengaruh tetapi tidak sebesar faktor lainnya.  

💡 **Pengembangan lebih lanjut:**  
- **Hyperparameter tuning pada XGBoost** untuk meningkatkan akurasi.  
- **Eksperimen dengan fitur tambahan** untuk meningkatkan klasifikasi.  
- **Menguji model lain seperti Neural Networks** untuk melihat potensi peningkatan akurasi.  
